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
import '../../domain/usecases/send_brevo_otp.dart';
import '../../domain/usecases/verify_brevo_otp.dart';
import '../../domain/usecases/register_with_brevo_otp.dart';
import '../../domain/usecases/login_with_brevo_otp.dart';
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
  final SendBrevoOtp sendBrevoOtp;
  final VerifyBrevoOtp verifyBrevoOtp;
  final RegisterWithBrevoOtp registerWithBrevoOtp;
  final LoginWithBrevoOtp loginWithBrevoOtp;

  AuthBloc({
    required this.signInWithPhone,
    required this.verifyOTP,
    required this.registerUser,
    required this.loginWithFirebase,
    required this.loginWithEmailPassword,
    required this.getCurrentUser,
    required this.logout,
    required this.sendBrevoOtp,
    required this.verifyBrevoOtp,
    required this.registerWithBrevoOtp,
    required this.loginWithBrevoOtp,
  }) : super(const AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<PhoneAuthRequested>(_onPhoneAuthRequested);
    on<OTPVerificationRequested>(_onOTPVerificationRequested);
    on<RegistrationRequested>(_onRegistrationRequested);
    on<FirebaseLoginRequested>(_onFirebaseLoginRequested);
    on<EmailPasswordLoginRequested>(_onEmailPasswordLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<AuthUserUpdated>(_onAuthUserUpdated);
    // Brevo OTP event handlers
    on<BrevoOtpSendRequested>(_onBrevoOtpSendRequested);
    on<BrevoOtpVerificationRequested>(_onBrevoOtpVerificationRequested);
    on<BrevoOtpResendRequested>(_onBrevoOtpResendRequested);
    on<BrevoRegistrationRequested>(_onBrevoRegistrationRequested);
    on<BrevoLoginRequested>(_onBrevoLoginRequested);
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

  // ===== BREVO OTP EVENT HANDLERS =====

  Future<void> _onBrevoOtpSendRequested(
    BrevoOtpSendRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await sendBrevoOtp(
      SendBrevoOtpParams(
        phoneNumber: event.phoneNumber,
        method: event.method,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (verificationId) => emit(BrevoOtpSent(
        verificationId: verificationId,
        phoneNumber: event.phoneNumber,
        method: event.method,
      )),
    );
  }

  Future<void> _onBrevoOtpVerificationRequested(
    BrevoOtpVerificationRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await verifyBrevoOtp(
      VerifyBrevoOtpParams(
        verificationId: event.verificationId,
        otp: event.otp,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (message) {
        // Extract phone number from the success message if available
        // The backend returns: "OTP verified successfully"
        emit(BrevoOtpVerified(
          verificationId: event.verificationId,
          phoneNumber: '', // Will be populated from previous state
        ));
      },
    );
  }

  Future<void> _onBrevoOtpResendRequested(
    BrevoOtpResendRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    // Note: We need to call sendBrevoOtp again with the phone number
    // This requires storing the phone number from the previous state
    // For now, we'll emit an error if phone number is not available
    if (state is BrevoOtpSent) {
      final currentState = state as BrevoOtpSent;
      final result = await sendBrevoOtp(
        SendBrevoOtpParams(
          phoneNumber: currentState.phoneNumber,
          method: currentState.method,
        ),
      );

      result.fold(
        (failure) => emit(AuthError(message: failure.message)),
        (verificationId) => emit(BrevoOtpResent(
          verificationId: verificationId,
          phoneNumber: currentState.phoneNumber,
        )),
      );
    } else {
      emit(const AuthError(message: 'Cannot resend OTP. Please start over.'));
    }
  }

  Future<void> _onBrevoRegistrationRequested(
    BrevoRegistrationRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await registerWithBrevoOtp(
      RegisterWithBrevoOtpParams(
        verificationId: event.verificationId,
        userData: event.userData,
      ),
    );

    result.fold(
      (failure) {
        // Check if this is a parental consent required failure
        if (failure is ParentalConsentRequiredFailure) {
          // Create a minimal user entity for the parental consent state
          final minorUser = UserEntity(
            id: 'pending',
            firebaseUid: '', // Not applicable for Brevo OTP
            name: event.userData['name'] as String,
            email: event.userData['email'] as String,
            phone: event.userData['phone'] as String?,
            accountType: event.userData['account_type'] as String,
            dateOfBirth: event.userData['date_of_birth'] as String?,
            country: event.userData['country'] as String?,
            isActive: false,
            emailVerified: false,
            phoneVerified: true,
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
        emit(AuthAuthenticated(user: user));
      },
    );
  }

  Future<void> _onBrevoLoginRequested(
    BrevoLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await loginWithBrevoOtp(
      LoginWithBrevoOtpParams(
        verificationId: event.verificationId,
        accountType: event.accountType,
      ),
    );

    result.fold(
      (failure) {
        // Check if user needs to register
        if (failure is UserNotFoundFailure && failure.requiresRegistration) {
          // User needs to register first
          emit(BrevoOtpVerified(
            verificationId: event.verificationId,
            phoneNumber: '', // Will be populated from context
          ));
        } else {
          emit(AuthError(message: failure.message));
        }
      },
      (user) {
        emit(AuthAuthenticated(user: user));
      },
    );
  }
}
