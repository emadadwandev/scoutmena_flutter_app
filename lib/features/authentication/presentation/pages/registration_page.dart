import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/navigation/routes.dart';
import '../../../../l10n/app_localizations_temp.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/primary_button.dart';
import '../widgets/role_selection_card.dart';
import '../../../../core/theme/app_colors.dart';

class RegistrationPage extends StatefulWidget {
  final String firebaseUid;
  final String phoneNumber;
  final String? accountType; // Optional - can be selected in form

  const RegistrationPage({
    super.key,
    required this.firebaseUid,
    required this.phoneNumber,
    this.accountType,
  });

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _countryController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  final _parentNameController = TextEditingController();
  final _parentEmailController = TextEditingController();

  DateTime? _selectedDateOfBirth;
  bool _isMinor = false;
  String? _selectedRole; // 'player' or 'scout'
  String? _parentRelationship; // 'parent' or 'legal_guardian'
  bool _obscurePassword = true;
  bool _obscurePasswordConfirmation = true;

  @override
  void initState() {
    super.initState();
    // If accountType is passed from previous screen, use it
    _selectedRole = widget.accountType;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _dateOfBirthController.dispose();
    _countryController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    _parentNameController.dispose();
    _parentEmailController.dispose();
    super.dispose();
  }

  int? _calculateAge(DateTime? birthDate) {
    if (birthDate == null) return null;
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month || (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  void _onDateOfBirthSelected() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2005, 1, 1),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDateOfBirth = picked;
        _dateOfBirthController.text = DateFormat('yyyy-MM-dd').format(picked);
        
        final age = _calculateAge(picked);
        _isMinor = age != null && age < 18;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => getIt<AuthBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.registration),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              // After registration, redirect based on role
              if (state.user.isPlayer) {
                // Players go to profile setup to complete their profile
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.playerProfileSetup,
                  (route) => false,
                );
              } else if (state.user.isScout) {
                // Scouts go directly to dashboard for now
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.scoutDashboard,
                  (route) => false,
                );
              } else {
                // Coaches and other roles go to dashboard (placeholder)
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.scoutDashboard, // Using scout dashboard as placeholder for coach
                  (route) => false,
                );
              }
            } else if (state is AuthParentalConsentRequired) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => AlertDialog(
                  title: Text(l10n.parentalConsentRequired),
                  content: Text(
                    '${l10n.parentalConsentMessage}\n\n${l10n.consentSentTo}: ${state.consentSentTo}',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.phoneAuth,
                          (route) => false,
                        );
                      },
                      child: Text(l10n.ok),
                    ),
                  ],
                ),
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
                      Text(
                        l10n.completeYourProfile,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.tellUsAboutYourself,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      const SizedBox(height: 32),

                      // Role Selection
                      Text(
                        l10n.selectYourRole,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),
                      // Three roles in column
                      RoleSelectionCard(
                        title: l10n.player,
                        description: l10n.playerRoleDescription,
                        icon: Icons.sports_soccer,
                        color: AppColors.playerPrimary,
                        isSelected: _selectedRole == 'player',
                        onTap: isLoading
                            ? () {}
                            : () {
                                setState(() {
                                  _selectedRole = 'player';
                                });
                              },
                      ),
                      const SizedBox(height: 12),
                      RoleSelectionCard(
                        title: l10n.scout,
                        description: l10n.scoutRoleDescription,
                        icon: Icons.visibility,
                        color: AppColors.scoutPrimary,
                        isSelected: _selectedRole == 'scout',
                        onTap: isLoading
                            ? () {}
                            : () {
                                setState(() {
                                  _selectedRole = 'scout';
                                });
                              },
                      ),
                      const SizedBox(height: 12),
                      RoleSelectionCard(
                        title: l10n.coach,
                        description: l10n.coachRoleDescription,
                        icon: Icons.sports,
                        color: AppColors.coachPrimary,
                        isSelected: _selectedRole == 'coach',
                        onTap: isLoading
                            ? () {}
                            : () {
                                setState(() {
                                  _selectedRole = 'coach';
                                });
                              },
                      ),
                      const SizedBox(height: 32),

                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: l10n.fullName,
                          hintText: l10n.enterFullName,
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.nameRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: l10n.email,
                          hintText: l10n.enterEmail,
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.emailRequired;
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return l10n.invalidEmail;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _dateOfBirthController,
                        readOnly: true,
                        onTap: _onDateOfBirthSelected,
                        decoration: InputDecoration(
                          labelText: l10n.dateOfBirth,
                          hintText: l10n.selectDateOfBirth,
                          prefixIcon: const Icon(Icons.calendar_today),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.dateOfBirthRequired;
                          }
                          return null;
                        },
                      ),
                      if (_isMinor) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.orange[300]!),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info, color: Colors.orange[700]),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  l10n.minorAccountNotice,
                                  style: TextStyle(
                                    color: Colors.orange[700],
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _countryController,
                        decoration: InputDecoration(
                          labelText: l10n.country,
                          hintText: l10n.enterCountry,
                          prefixIcon: const Icon(Icons.flag),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.countryRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          // Check for at least one uppercase letter
                          if (!value.contains(RegExp(r'[A-Z]'))) {
                            return 'Password must contain at least one uppercase letter';
                          }
                          // Check for at least one lowercase letter
                          if (!value.contains(RegExp(r'[a-z]'))) {
                            return 'Password must contain at least one lowercase letter';
                          }
                          // Check for at least one number
                          if (!value.contains(RegExp(r'[0-9]'))) {
                            return 'Password must contain at least one number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordConfirmationController,
                        obscureText: _obscurePasswordConfirmation,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          hintText: 'Re-enter your password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePasswordConfirmation ? Icons.visibility_off : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePasswordConfirmation = !_obscurePasswordConfirmation;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      if (_isMinor) ...[
                        const SizedBox(height: 32),
                        Text(
                          l10n.parentalInformation,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _parentRelationship,
                          decoration: InputDecoration(
                            labelText: 'Parent Relationship',
                            hintText: 'Select relationship',
                            prefixIcon: const Icon(Icons.family_restroom),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'mother',
                              child: Text('Mother'),
                            ),
                            DropdownMenuItem(
                              value: 'father',
                              child: Text('Father'),
                            ),
                            DropdownMenuItem(
                              value: 'legal_guardian',
                              child: Text('Legal Guardian'),
                            ),
                            DropdownMenuItem(
                              value: 'other',
                              child: Text('Other'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _parentRelationship = value;
                            });
                          },
                          validator: (value) {
                            if (_isMinor && (value == null || value.isEmpty)) {
                              return 'Please select parent relationship';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _parentNameController,
                          decoration: InputDecoration(
                            labelText: l10n.parentGuardianName,
                            hintText: l10n.enterParentName,
                            prefixIcon: const Icon(Icons.person_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (_isMinor && (value == null || value.trim().isEmpty)) {
                              return l10n.parentNameRequired;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _parentEmailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: l10n.parentGuardianEmail,
                            hintText: l10n.enterParentEmail,
                            prefixIcon: const Icon(Icons.email_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (_isMinor) {
                              if (value == null || value.trim().isEmpty) {
                                return l10n.parentEmailRequired;
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                return l10n.invalidEmail;
                              }
                            }
                            return null;
                          },
                        ),
                      ],
                      const SizedBox(height: 32),
                      Builder(
                        builder: (btnContext) => PrimaryButton(
                          text: l10n.register,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final l10nBtn = AppLocalizations.of(btnContext)!;

                              // Check if role is selected
                              if (_selectedRole == null) {
                                ScaffoldMessenger.of(btnContext).showSnackBar(
                                  SnackBar(
                                    content: Text(l10nBtn.pleaseSelectRole),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              if (_isMinor) {
                                if (_parentNameController.text.isEmpty || 
                                    _parentEmailController.text.isEmpty ||
                                    _parentRelationship == null) {
                                  ScaffoldMessenger.of(btnContext).showSnackBar(
                                    SnackBar(
                                      content: Text(l10nBtn.parentInfoRequired),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }
                              }

                              final userData = {
                                'name': _nameController.text.trim(),
                                'email': _emailController.text.trim(),
                                'phone': widget.phoneNumber,
                                'date_of_birth': _dateOfBirthController.text,
                                'country': _countryController.text.trim(),
                                'account_type': _selectedRole!,
                                'password': _passwordController.text,
                                'password_confirmation': _passwordConfirmationController.text,
                              };

                              if (_isMinor) {
                                userData['parent_name'] = _parentNameController.text.trim();
                                userData['parent_email'] = _parentEmailController.text.trim();
                                userData['parent_relationship'] = _parentRelationship!;
                              }

                              btnContext.read<AuthBloc>().add(
                                    RegistrationRequested(
                                      firebaseUid: widget.firebaseUid,
                                      userData: userData,
                                    ),
                                  );
                            }
                          },
                          isLoading: isLoading,
                        ),
                      ),
                      const SizedBox(height: 16),
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
