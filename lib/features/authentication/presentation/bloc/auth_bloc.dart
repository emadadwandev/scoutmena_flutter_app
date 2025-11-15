import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/login_with_email_password.dart';
import '../../domain/usecases/login_with_firebase.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/register_user.dart';
import '../../domain/usecases/sign_in_with_phone.dart';
import '../../domain/usecases/usecase.dart';
import '../../domain/usecases/verify_otp.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithPhone signInWithPhone;
  final VerifyOTP verifyOTP;
  final RegisterUser registerUser;
  final LoginWithFirebase loginWithFirebase;
  final LoginWithEmailPassword loginWithEmailPassword;
  final GetCurrentUser getCurrentUser;
  final Logout logout;

  AuthBloc({
    required this.signInWithPhone,
    required this.verifyOTP,
    required this.registerUser,
    required this.loginWithFirebase,
    required this.loginWithEmailPassword,
    required this.getCurrentUser,
    required this.logout,
  }) : super(const AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<PhoneAuthRequested>(_onPhoneAuthRequested);
    on<OTPVerificationRequested>(_onOTPVerificationRequested);
    on<RegistrationRequested>(_onRegistrationRequested);
    on<FirebaseLoginRequested>(_onFirebaseLoginRequested);
    on<EmailPasswordLoginRequested>(_onEmailPasswordLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<AuthUserUpdated>(_onAuthUserUpdated);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await getCurrentUser(NoParams());

    result.fold(
      (failure) => emit(const AuthUnauthenticated()),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onPhoneAuthRequested(
    PhoneAuthRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await signInWithPhone(
      SignInWithPhoneParams(phoneNumber: event.phoneNumber),
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (verificationId) => emit(PhoneAuthCodeSent(
        verificationId: verificationId,
        phoneNumber: event.phoneNumber,
      )),
    );
  }

  Future<void> _onOTPVerificationRequested(
    OTPVerificationRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await verifyOTP(
      VerifyOTPParams(
        verificationId: event.verificationId,
        otp: event.otp,
      ),
    );

    await result.fold(
      (failure) async {
        emit(AuthError(message: failure.message));
      },
      (firebaseUser) async {
        final loginResult = await loginWithFirebase(NoParams());

        loginResult.fold(
          (failure) {
            emit(AuthRegistrationRequired(firebaseUid: firebaseUser.uid));
          },
          (user) {
            emit(AuthAuthenticated(user: user));
          },
        );
      },
    );
  }

  Future<void> _onRegistrationRequested(
    RegistrationRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    // Small delay to ensure Firebase is fully initialized after OTP verification
    await Future.delayed(const Duration(milliseconds: 300));

    final result = await registerUser(
      RegisterUserParams(
        firebaseUid: event.firebaseUid,
        userData: event.userData,
      ),
    );

    result.fold(
      (failure) {
        // Check if this is a parental consent required failure
        if (failure is ParentalConsentRequiredFailure) {
          // Create a minimal user entity for the parental consent state
          // This is just for UI display, the actual account is locked on backend
          final minorUser = UserEntity(
            id: 'pending', // Placeholder ID
            firebaseUid: event.firebaseUid,
            name: event.userData['name'] as String,
            email: event.userData['email'] as String,
            phone: event.userData['phone'] as String?,
            accountType: event.userData['account_type'] as String,
            dateOfBirth: event.userData['date_of_birth'] as String?,
            country: event.userData['country'] as String?,
            isActive: false, // Account is locked pending consent
            emailVerified: false,
            phoneVerified: true, // Phone was verified via OTP
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          
          emit(AuthParentalConsentRequired(
            user: minorUser,
            consentSentTo: event.userData['parent_email'] as String?,
          ));
        } else {
          emit(AuthError(message: failure.message));
        }
      },
      (user) {
        // Normal registration success (adult user)
        emit(AuthAuthenticated(user: user));
      },
    );
  }

  Future<void> _onFirebaseLoginRequested(
    FirebaseLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await loginWithFirebase(NoParams());

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onEmailPasswordLoginRequested(
    EmailPasswordLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await loginWithEmailPassword(
      LoginWithEmailPasswordParams(
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await logout(NoParams());

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(const AuthUnauthenticated()),
    );
  }

  void _onAuthUserUpdated(
    AuthUserUpdated event,
    Emitter<AuthState> emit,
  ) {
    if (event.user != null) {
      emit(AuthAuthenticated(user: event.user!));
    } else {
      emit(const AuthUnauthenticated());
    }
  }
}
