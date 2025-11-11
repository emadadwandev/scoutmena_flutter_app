import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../error/failures.dart';

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
    final user = _auth.currentUser;
    if (user != null) {
      final token = await user.getIdToken();
      if (token != null) {
        await _secureStorage.write(key: 'firebase_token', value: token);
      }
      return token;
    }
    return await _secureStorage.read(key: 'firebase_token');
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
