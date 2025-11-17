import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  // ===== FIREBASE PHONE AUTH (Legacy - Deprecated) =====
  Future<Either<Failure, String>> signInWithPhone(String phoneNumber);
  
  Future<Either<Failure, firebase_auth.User>> verifyOTP({
    required String verificationId,
    required String otp,
  });
  
  // ===== BREVO OTP AUTH (New Primary Method) =====
  /// Send OTP via Brevo SMS/WhatsApp
  Future<Either<Failure, String>> sendBrevoOtp({
    required String phoneNumber,
    String method = 'sms',
  });
  
  /// Verify OTP from Brevo
  Future<Either<Failure, String>> verifyBrevoOtp({
    required String verificationId,
    required String otp,
  });
  
  /// Resend OTP via Brevo
  Future<Either<Failure, String>> resendBrevoOtp({
    required String verificationId,
  });
  
  /// Register with Brevo OTP verification
  Future<Either<Failure, UserEntity>> registerWithBrevoOtp({
    required String verificationId,
    required Map<String, dynamic> userData,
  });
  
  /// Login with Brevo OTP verification
  Future<Either<Failure, UserEntity>> loginWithBrevoOtp({
    required String verificationId,
    required String accountType,
  });
  
  // ===== FIREBASE LOGIN (Legacy) =====
  Future<Either<Failure, UserEntity>> register({
    required String firebaseUid,
    required Map<String, dynamic> userData,
  });
  
  Future<Either<Failure, UserEntity>> loginWithFirebase();
  
  // ===== EMAIL/PASSWORD AUTH =====
  Future<Either<Failure, UserEntity>> loginWithEmailPassword({
    required String email,
    required String password,
  });
  
  // ===== COMMON AUTH METHODS =====
  Future<Either<Failure, UserEntity>> getCurrentUser();
  
  Future<Either<Failure, void>> logout();
  
  Stream<firebase_auth.User?> get authStateChanges;
}
