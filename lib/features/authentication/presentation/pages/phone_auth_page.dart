import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../../../core/navigation/routes.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../l10n/app_localizations_temp.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/primary_button.dart';

class PhoneAuthPage extends StatefulWidget {
  final String mode; // 'login' or 'register'

  const PhoneAuthPage({
    super.key,
    this.mode = 'login',
  });

  @override
  State<PhoneAuthPage> createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  String _completePhoneNumber = '';
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onSendOTP() {
    if (_formKey.currentState!.validate()) {
      if (!_acceptedTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.pleaseAcceptTerms),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Bypass OTP for testing if flag is enabled
      if (AppConstants.bypassOTPVerification) {
        // Skip Firebase OTP and go directly to OTP verification screen with test ID
        Navigator.pushNamed(
          context,
          AppRoutes.otpVerification,
          arguments: {
            'verificationId': AppConstants.testVerificationId,
            'phoneNumber': _completePhoneNumber,
            'mode': widget.mode,
          },
        );
      } else {
        // Normal flow - send OTP via Firebase
        context.read<AuthBloc>().add(
              PhoneAuthRequested(phoneNumber: _completePhoneNumber),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
            if (state is PhoneAuthCodeSent) {
              Navigator.pushNamed(
                context,
                AppRoutes.otpVerification,
                arguments: {
                  'verificationId': state.verificationId,
                  'phoneNumber': state.phoneNumber,
                  'mode': widget.mode, // Pass mode to OTP page
                },
              );
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 32),
                      Text(
                        widget.mode == 'register' ? l10n.createAccount : l10n.welcomeToScoutMena,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.mode == 'register' ? l10n.registerDescription : l10n.enterPhoneToGetStarted,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      const SizedBox(height: 48),
                      IntlPhoneField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: l10n.phoneNumber,
                          hintText: '123456789',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                        initialCountryCode: 'SA',
                        onChanged: (phone) {
                          _completePhoneNumber = phone.completeNumber;
                        },
                        validator: (phone) {
                          if (phone == null || phone.number.isEmpty) {
                            return l10n.phoneRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: _acceptedTerms,
                            onChanged: isLoading
                                ? null
                                : (value) {
                                    setState(() {
                                      _acceptedTerms = value ?? false;
                                    });
                                  },
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: isLoading
                                  ? null
                                  : () {
                                      setState(() {
                                        _acceptedTerms = !_acceptedTerms;
                                      });
                                    },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: Text.rich(
                                  TextSpan(
                                    text: l10n.iAgreeToThe,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                    children: [
                                      TextSpan(
                                        text: ' ${l10n.termsAndConditions}',
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(text: ' ${l10n.and} '),
                                      TextSpan(
                                        text: l10n.privacyPolicy,
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      PrimaryButton(
                        text: widget.mode == 'register' ? l10n.sendOTP : l10n.login,
                        onPressed: _onSendOTP,
                        isLoading: isLoading,
                      ),
                      const SizedBox(height: 24),
                      
                      // Registration/Login Link
                      if (widget.mode == 'login')
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                l10n.dontHaveAccount,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              TextButton(
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const PhoneAuthPage(mode: 'register'),
                                          ),
                                        );
                                      },
                                child: Text(
                                  l10n.registerNow,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (widget.mode == 'register')
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                l10n.alreadyHaveAccount,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              TextButton(
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const PhoneAuthPage(mode: 'login'),
                                          ),
                                        );
                                      },
                                child: Text(
                                  l10n.loginNow,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 24),
                      Center(
                        child: Text(
                          l10n.orContinueWith,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      OutlinedButton.icon(
                        onPressed: isLoading ? null : () {},
                        icon: Image.asset(
                          'assets/icons/google.png',
                          height: 24,
                          width: 24,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.g_mobiledata);
                          },
                        ),
                        label: Text(l10n.continueWithGoogle),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: isLoading ? null : () {},
                        icon: const Icon(Icons.apple, color: Colors.black),
                        label: Text(l10n.continueWithApple),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
    );
  }
}
