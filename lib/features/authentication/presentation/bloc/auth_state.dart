import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class PhoneAuthCodeSent extends AuthState {
  final String verificationId;
  final String phoneNumber;

  const PhoneAuthCodeSent({
    required this.verificationId,
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [verificationId, phoneNumber];
}

class OTPVerified extends AuthState {
  final String firebaseUid;

  const OTPVerified({required this.firebaseUid});

  @override
  List<Object?> get props => [firebaseUid];
}

class AuthAuthenticated extends AuthState {
  final UserEntity user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthRegistrationRequired extends AuthState {
  final String firebaseUid;

  const AuthRegistrationRequired({required this.firebaseUid});

  @override
  List<Object?> get props => [firebaseUid];
}

class AuthParentalConsentRequired extends AuthState {
  final UserEntity user;
  final String? consentSentTo;

  const AuthParentalConsentRequired({
    required this.user,
    this.consentSentTo,
  });

  @override
  List<Object?> get props => [user, consentSentTo];
}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}
