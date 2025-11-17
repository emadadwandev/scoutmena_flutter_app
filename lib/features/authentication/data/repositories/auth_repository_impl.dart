import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/services/firebase_auth_service.dart';
import '../../../../core/services/brevo_otp_service.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final FirebaseAuthService firebaseAuthService;
  final BrevoOtpService brevoOtpService;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.firebaseAuthService,
    required this.brevoOtpService,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, String>> signInWithPhone(String phoneNumber) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }

    return await firebaseAuthService.signInWithPhone(phoneNumber);
  }

  @override
  Future<Either<Failure, firebase_auth.User>> verifyOTP({
    required String verificationId,
    required String otp,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }

    return await firebaseAuthService.verifyOTP(
      verificationId: verificationId,
      otp: otp,
    );
  }

  @override
  Future<Either<Failure, UserEntity>> register({
    required String firebaseUid,
    required Map<String, dynamic> userData,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final response = await remoteDataSource.register(
        firebaseUid: firebaseUid,
        userData: userData,
      );

      // Handle parental consent required case
      if (response.requiresParentalConsent == true) {
        // Return a special failure that indicates parental consent is needed
        return Left(ParentalConsentRequiredFailure(
          message: response.message,
          consentId: response.consentSentTo,
        ));
      }

      if (response.user == null) {
        return Left(ServerFailure(message: 'Registration failed'));
      }

      await localDataSource.cacheUser(response.user!);

      return Right(response.user!.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithFirebase() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final userModel = await remoteDataSource.loginWithFirebase();
      await localDataSource.cacheUser(userModel);
      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Login failed'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final userModel = await remoteDataSource.loginWithEmailPassword(
        email: email,
        password: password,
      );
      await localDataSource.cacheUser(userModel);
      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Login failed'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final cachedUser = await localDataSource.getCachedUser();
      if (cachedUser != null) {
        return Right(cachedUser.toEntity());
      }

      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure(message: 'No internet connection'));
      }

      final userModel = await remoteDataSource.getCurrentUser();
      await localDataSource.cacheUser(userModel);
      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to get current user'));
    }
  }

  // ===== BREVO OTP METHODS =====

  @override
  Future<Either<Failure, String>> sendBrevoOtp({
    required String phoneNumber,
    String method = 'sms',
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }

    return await brevoOtpService.sendOtp(
      phoneNumber: phoneNumber,
      method: method,
    );
  }

  @override
  Future<Either<Failure, String>> verifyBrevoOtp({
    required String verificationId,
    required String otp,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }

    return await brevoOtpService.verifyOtp(
      verificationId: verificationId,
      otp: otp,
    );
  }

  @override
  Future<Either<Failure, String>> resendBrevoOtp({
    required String verificationId,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }

    return await brevoOtpService.resendOtp(
      verificationId: verificationId,
    );
  }

  @override
  Future<Either<Failure, UserEntity>> registerWithBrevoOtp({
    required String verificationId,
    required Map<String, dynamic> userData,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final result = await brevoOtpService.registerWithOtp(
        verificationId: verificationId,
        userData: userData,
      );

      return result.fold(
        (failure) => Left(failure),
        (data) async {
          // Handle parental consent required case
          if (data['requires_parental_consent'] == true) {
            return Left(ParentalConsentRequiredFailure(
              message: data['message'] ?? 'Parental consent required',
              consentId: data['parental_consent_id'],
            ));
          }

          // Extract user from response
          final userMap = data['user'] as Map<String, dynamic>;

          // Create user model from response
          final userModel = UserModel.fromJson(userMap);

          // Cache user locally
          await localDataSource.cacheUser(userModel);

          return Right(userModel.toEntity());
        },
      );
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Registration failed: $e'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithBrevoOtp({
    required String verificationId,
    required String accountType,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final result = await brevoOtpService.loginWithOtp(
        verificationId: verificationId,
        accountType: accountType,
      );

      return result.fold(
        (failure) => Left(failure),
        (data) async {
          // Extract user from response
          final userMap = data['user'] as Map<String, dynamic>;

          // Create user model from response
          final userModel = UserModel.fromJson(userMap);

          // Cache user locally
          await localDataSource.cacheUser(userModel);

          return Right(userModel.toEntity());
        },
      );
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Login failed: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      if (await networkInfo.isConnected) {
        await remoteDataSource.logout();
      }

      await firebaseAuthService.signOut();
      await localDataSource.clearCache();

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Logout failed'));
    }
  }

  @override
  Stream<firebase_auth.User?> get authStateChanges =>
      firebaseAuthService.authStateChanges;
}
