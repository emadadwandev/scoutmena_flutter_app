import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

class PhoneAuthRequested extends AuthEvent {
  final String phoneNumber;

  const PhoneAuthRequested({required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber];
}

class OTPVerificationRequested extends AuthEvent {
  final String verificationId;
  final String otp;

  const OTPVerificationRequested({
    required this.verificationId,
    required this.otp,
  });

  @override
  List<Object?> get props => [verificationId, otp];
}

class RegistrationRequested extends AuthEvent {
  final String firebaseUid;
  final Map<String, dynamic> userData;

  const RegistrationRequested({
    required this.firebaseUid,
    required this.userData,
  });

  @override
  List<Object?> get props => [firebaseUid, userData];
}

class FirebaseLoginRequested extends AuthEvent {
  const FirebaseLoginRequested();
}

class EmailPasswordLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const EmailPasswordLoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

class AuthUserUpdated extends AuthEvent {
  final UserEntity? user;

  const AuthUserUpdated({this.user});

  @override
  List<Object?> get props => [user];
}

// ===== BREVO OTP EVENTS =====

class BrevoOtpSendRequested extends AuthEvent {
  final String phoneNumber;
  final String method; // 'sms' or 'whatsapp'

  const BrevoOtpSendRequested({
    required this.phoneNumber,
    this.method = 'sms',
  });

  @override
  List<Object?> get props => [phoneNumber, method];
}

class BrevoOtpVerificationRequested extends AuthEvent {
  final String verificationId;
  final String otp;

  const BrevoOtpVerificationRequested({
    required this.verificationId,
    required this.otp,
  });

  @override
  List<Object?> get props => [verificationId, otp];
}

class BrevoOtpResendRequested extends AuthEvent {
  final String verificationId;

  const BrevoOtpResendRequested({required this.verificationId});

  @override
  List<Object?> get props => [verificationId];
}

class BrevoRegistrationRequested extends AuthEvent {
  final String verificationId;
  final Map<String, dynamic> userData;

  const BrevoRegistrationRequested({
    required this.verificationId,
    required this.userData,
  });

  @override
  List<Object?> get props => [verificationId, userData];
}

class BrevoLoginRequested extends AuthEvent {
  final String verificationId;
  final String accountType;

  const BrevoLoginRequested({
    required this.verificationId,
    required this.accountType,
  });

  @override
  List<Object?> get props => [verificationId, accountType];
}
