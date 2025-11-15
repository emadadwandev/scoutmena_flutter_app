import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, String>> signInWithPhone(String phoneNumber);
  
  Future<Either<Failure, firebase_auth.User>> verifyOTP({
    required String verificationId,
    required String otp,
  });
  
  Future<Either<Failure, UserEntity>> register({
    required String firebaseUid,
    required Map<String, dynamic> userData,
  });
  
  Future<Either<Failure, UserEntity>> loginWithFirebase();
  
  Future<Either<Failure, UserEntity>> loginWithEmailPassword({
    required String email,
    required String password,
  });
  
  Future<Either<Failure, UserEntity>> getCurrentUser();
  
  Future<Either<Failure, void>> logout();
  
  Stream<firebase_auth.User?> get authStateChanges;
}
