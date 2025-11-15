import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/navigation/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/player_profile_bloc.dart';
import '../bloc/player_profile_event.dart' as profile_events;
import '../bloc/player_profile_state.dart';
import '../models/profile_setup_form_data.dart';
import '../widgets/steps/basic_info_step.dart';
import '../widgets/steps/football_info_step.dart';
import '../widgets/steps/contact_info_step.dart';
import '../widgets/steps/parent_info_step.dart';

/// Player Profile Setup - Multi-step profile creation
class PlayerProfileSetupPage extends StatefulWidget {
  const PlayerProfileSetupPage({super.key});

  @override
  State<PlayerProfileSetupPage> createState() => _PlayerProfileSetupPageState();
}

class _PlayerProfileSetupPageState extends State<PlayerProfileSetupPage> {
  int _currentStep = 0;
  late ProfileSetupFormData _formData;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _formData = ProfileSetupFormData();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int get _totalSteps => _formData.isMinor ? 4 : 3;

  void _goToNextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToPreviousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return _formData.isBasicInfoComplete;
      case 1:
        return _formData.isFootballInfoComplete;
      case 2:
        return _formData.isContactInfoComplete;
      case 3:
        return _formData.isParentInfoComplete;
      default:
        return false;
    }
  }

  void _submitProfile(BuildContext context) {
    if (!_canProceed()) return;

    // Create profile first, then upload photo in BlocListener
    context.read<PlayerProfileBloc>().add(
          profile_events.CreatePlayerProfile(
            profileData: _formData.toJson(),
          ),
        );
  }

  void _navigateToSuccess(BuildContext context) {
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _formData.isMinor
              ? 'Profile created! Awaiting parental consent.'
              : 'Profile created successfully!',
        ),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate to dashboard
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.playerDashboard,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PlayerProfileBloc>(),
      child: BlocConsumer<PlayerProfileBloc, PlayerProfileState>(
        listener: (context, state) {
          if (state is PlayerProfileCreated) {
            // Upload profile photo if available, using the created userId
            if (_formData.profilePhoto != null) {
              context.read<PlayerProfileBloc>().add(
                    profile_events.UploadProfilePhoto(
                      playerId: state.profile.userId,
                      photoFile: _formData.profilePhoto!,
                    ),
                  );
            } else {
              // No photo to upload, navigate immediately
              _navigateToSuccess(context);
            }
          } else if (state is ProfilePhotoUploaded) {
            // Photo uploaded successfully, now navigate
            _navigateToSuccess(context);
          } else if (state is PlayerProfileError || state is ProfilePhotoUploadError) {
            // Show error message
            final message = state is PlayerProfileError
                ? state.message
                : (state as ProfilePhotoUploadError).message;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is ProfileUpdating || state is ProfilePhotoUploading;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Setup Your Profile'),
              leading: _currentStep > 0
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: isLoading ? null : _goToPreviousStep,
                    )
                  : null,
            ),
            body: Column(
              children: [
                // Progress Indicator
                _buildProgressIndicator(),

                // Form Steps
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() {
                        _currentStep = index;
                      });
                    },
                    children: [
                      // Step 1: Basic Information
                      BasicInfoStep(
                        formData: _formData,
                        onDataChanged: (data) {
                          setState(() {
                            _formData = data;
                          });
                        },
                      ),

                      // Step 2: Football Information
                      FootballInfoStep(
                        formData: _formData,
                        onDataChanged: (data) {
                          setState(() {
                            _formData = data;
                          });
                        },
                      ),

                      // Step 3: Contact & Social
                      ContactInfoStep(
                        formData: _formData,
                        onDataChanged: (data) {
                          setState(() {
                            _formData = data;
                          });
                        },
                      ),

                      // Step 4: Parent Information (only for minors)
                      if (_formData.isMinor)
                        ParentInfoStep(
                          formData: _formData,
                          onDataChanged: (data) {
                            setState(() {
                              _formData = data;
                            });
                          },
                        ),
                    ],
                  ),
                ),

                // Navigation Buttons
                _buildNavigationButtons(context, isLoading),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Step ${_currentStep + 1} of $_totalSteps',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const Spacer(),
              Text(
                '${_formData.completeness}% Complete',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (_currentStep + 1) / _totalSteps,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.playerPrimary),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(BuildContext context, bool isLoading) {
    final isLastStep = _currentStep == _totalSteps - 1;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: isLoading ? null : _goToPreviousStep,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Back'),
                ),
              ),
            if (_currentStep > 0) const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : _canProceed()
                        ? (isLastStep ? () => _submitProfile(context) : _goToNextStep)
                        : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.playerPrimary,
                  disabledBackgroundColor: Colors.grey[300],
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        isLastStep ? 'Create Profile' : 'Continue',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
