import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../error/failures.dart';
import '../constants/app_constants.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FlutterSecureStorage _secureStorage;

  FirebaseAuthService(this._secureStorage);

  Future<Either<Failure, String>> signInWithPhone(String phoneNumber) async {
    try {
      String? verificationId;
      Failure? failure;

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          failure = ServerFailure(message: e.message ?? 'Verification failed');
        },
        codeSent: (String verId, int? resendToken) {
          verificationId = verId;
        },
        codeAutoRetrievalTimeout: (String verId) {
          verificationId = verId;
        },
        timeout: const Duration(seconds: 60),
      );

      if (failure != null) {
        return Left(failure!);
      }

      if (verificationId == null) {
        return Left(ServerFailure(message: 'Failed to send OTP'));
      }

      return Right(verificationId!);
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Authentication failed'));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  Future<Either<Failure, User>> verifyOTP({
    required String verificationId,
    required String otp,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final user = userCredential.user;
      if (user == null) {
        return Left(ServerFailure(message: 'User not found after verification'));
      }

      String? idToken = await user.getIdToken();
      if (idToken != null) {
        await _secureStorage.write(key: 'firebase_token', value: idToken);
      }

      return Right(user);
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Invalid OTP';
      if (e.code == 'invalid-verification-code') {
        errorMessage = 'The verification code is invalid';
      } else if (e.code == 'session-expired') {
        errorMessage = 'The verification code has expired';
      }
      return Left(ServerFailure(message: e.message ?? errorMessage));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to verify OTP'));
    }
  }

  Future<String?> getFirebaseToken() async {
    try {
      // UI TESTING MODE: Return mock token if bypass is enabled
      if (AppConstants.enableUITestingMode && AppConstants.bypassFirebaseAuth) {
        await _secureStorage.write(
          key: 'firebase_token', 
          value: AppConstants.mockFirebaseToken,
        );
        return AppConstants.mockFirebaseToken;
      }
      
      // First, try to get token from current user
      final user = _auth.currentUser;
      if (user != null) {
        // Force refresh the token to ensure it's valid
        final token = await user.getIdToken(true);
        if (token != null) {
          await _secureStorage.write(key: 'firebase_token', value: token);
          return token;
        }
      }
      
      // Fallback: try to read from secure storage
      final storedToken = await _secureStorage.read(key: 'firebase_token');
      if (storedToken != null) {
        return storedToken;
      }
      
      // Last resort: wait a bit and try again (Firebase user might be initializing)
      await Future.delayed(const Duration(milliseconds: 500));
      final retryUser = _auth.currentUser;
      if (retryUser != null) {
        final retryToken = await retryUser.getIdToken(true);
        if (retryToken != null) {
          await _secureStorage.write(key: 'firebase_token', value: retryToken);
          return retryToken;
        }
      }
      
      return null;
    } catch (e) {
      // If there's an error getting token, try stored token
      return await _secureStorage.read(key: 'firebase_token');
    }
  }

  Future<void> refreshFirebaseToken() async {
    final user = _auth.currentUser;
    if (user != null) {
      final token = await user.getIdToken(true);
      if (token != null) {
        await _secureStorage.write(key: 'firebase_token', value: token);
      }
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  String? getCurrentUserId() {
    // UI TESTING MODE: Return mock user ID if bypass is enabled
    if (AppConstants.enableUITestingMode && AppConstants.bypassFirebaseAuth) {
      return AppConstants.mockUserId;
    }
    return _auth.currentUser?.uid;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _secureStorage.delete(key: 'firebase_token');
    await _secureStorage.delete(key: 'user_data');
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Stream<User?> get userChanges => _auth.userChanges();
}
