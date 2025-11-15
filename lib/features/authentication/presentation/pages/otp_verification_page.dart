import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/navigation/routes.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../l10n/app_localizations_temp.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/primary_button.dart';

class OTPVerificationPage extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
  final String mode; // 'login' or 'register'

  const OTPVerificationPage({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
    this.mode = 'login',
  });

  @override
  State<OTPVerificationPage> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Timer? _timer;
  int _secondsRemaining = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _secondsRemaining = 60;
      _canResend = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Check if widget is still mounted before calling setState
      if (!mounted) {
        timer.cancel();
        return;
      }
      
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  void _onResendCode() {
    context.read<AuthBloc>().add(
          PhoneAuthRequested(phoneNumber: widget.phoneNumber),
        );
    _startTimer();
  }

  void _onVerifyOTP() {
    if (_formKey.currentState!.validate()) {
      // Bypass OTP for testing if flag is enabled
      if (AppConstants.bypassOTPVerification) {
        // Check if the entered OTP matches the test OTP
        if (_otpController.text == AppConstants.testOTP) {
          // Go directly to registration since this is a new user in testing
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.registration,
            arguments: {
              'firebaseUid': 'test-user-${DateTime.now().millisecondsSinceEpoch}',
              'phoneNumber': widget.phoneNumber,
            },
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Invalid OTP. Use ${AppConstants.testOTP} for testing'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        // Normal flow - verify OTP via Firebase
        context.read<AuthBloc>().add(
              OTPVerificationRequested(
                verificationId: widget.verificationId,
                otp: _otpController.text,
              ),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => getIt<AuthBloc>(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthRegistrationRequired) {
              // New user needs to register - go directly to registration form
              // User will select role and enter details in the registration form
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.registration,
                arguments: {
                  'firebaseUid': state.firebaseUid,
                  'phoneNumber': widget.phoneNumber,
                },
              );
            } else if (state is AuthAuthenticated) {
              // User already exists, logged in successfully
              if (widget.mode == 'register') {
                // If they were trying to register but account exists, show message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.accountAlreadyExists),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
              // Navigate to dashboard
              if (state.user.isPlayer) {
                Navigator.pushReplacementNamed(context, AppRoutes.playerDashboard);
              } else if (state.user.isScout) {
                Navigator.pushReplacementNamed(context, AppRoutes.scoutDashboard);
              }
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is PhoneAuthCodeSent) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.otpResent),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 32),
                      Icon(
                        Icons.phone_android,
                        size: 80,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 32),
                      Text(
                        l10n.verifyPhoneNumber,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${l10n.weHaveSentOTPTo}\n${widget.phoneNumber}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey[600],
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),
                      PinCodeTextField(
                        appContext: context,
                        length: 6,
                        controller: _otpController,
                        keyboardType: TextInputType.number,
                        autoFocus: true,
                        enableActiveFill: true,
                        animationType: AnimationType.fade,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(12),
                          fieldHeight: 56,
                          fieldWidth: 48,
                          activeFillColor: Colors.white,
                          inactiveFillColor: Colors.grey[100],
                          selectedFillColor: Colors.white,
                          activeColor: Theme.of(context).colorScheme.primary,
                          inactiveColor: Colors.grey[300]!,
                          selectedColor: Theme.of(context).colorScheme.primary,
                        ),
                        onCompleted: (code) {
                          _onVerifyOTP();
                        },
                        onChanged: (value) {},
                        validator: (value) {
                          if (value == null || value.length < 6) {
                            return l10n.otpRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      if (_canResend)
                        TextButton(
                          onPressed: isLoading ? null : _onResendCode,
                          child: Text(
                            l10n.resendCode,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      else
                        Text(
                          '${l10n.resendCodeIn} $_secondsRemaining ${l10n.seconds}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                      const SizedBox(height: 32),
                      PrimaryButton(
                        text: l10n.verify,
                        onPressed: _onVerifyOTP,
                        isLoading: isLoading,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
