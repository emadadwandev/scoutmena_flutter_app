import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/coach_profile_bloc.dart';
import '../bloc/coach_profile_event.dart';
import '../bloc/coach_profile_state.dart';
import '../../../../core/theme/app_colors.dart';

/// Coach profile setup page
class CoachProfileSetupPage extends StatefulWidget {
  const CoachProfileSetupPage({super.key});

  @override
  State<CoachProfileSetupPage> createState() => _CoachProfileSetupPageState();
}

class _CoachProfileSetupPageState extends State<CoachProfileSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _clubController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bioController = TextEditingController();
  final _experienceController = TextEditingController();

  String _roleTitle = 'Head Coach';
  List<String> _selectedSpecializations = [];
  List<String> _selectedAgeGroups = [];
  String? _licenseLevel;

  static const List<String> _roleTitles = [
    'Head Coach',
    'Assistant Coach',
    'Youth Coach',
    'Goalkeeping Coach',
    'Fitness Coach',
  ];

  static const List<String> _specializations = [
    'Offensive Tactics',
    'Defensive Tactics',
    'Goalkeeping',
    'Fitness & Conditioning',
    'Youth Development',
  ];

  static const List<String> _ageGroups = [
    'U12',
    'U15',
    'U18',
    'U21',
    'Senior',
  ];

  static const List<String> _licenses = [
    'UEFA Pro',
    'UEFA A',
    'UEFA B',
    'CAF A',
    'CAF B',
    'Other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _clubController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coach Profile Setup'),
        backgroundColor: AppColors.coachPrimary,
        foregroundColor: Colors.white,
      ),
      body: BlocListener<CoachProfileBloc, CoachProfileState>(
        listener: (context, state) {
          if (state is CoachProfileCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile created successfully')),
            );
            Navigator.pushReplacementNamed(context, '/coach-dashboard');
          } else if (state is CoachProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBasicInfo(),
                const SizedBox(height: 24),
                _buildRoleAndExperience(),
                const SizedBox(height: 24),
                _buildSpecializations(),
                const SizedBox(height: 24),
                _buildAgeGroups(),
                const SizedBox(height: 24),
                _buildLicense(),
                const SizedBox(height: 24),
                _buildContactInfo(),
                const SizedBox(height: 32),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Basic Information',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Full Name *',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person),
          ),
          validator: (value) =>
              value?.isEmpty ?? true ? 'Name is required' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _clubController,
          decoration: const InputDecoration(
            labelText: 'Club Name',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.shield),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _bioController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Bio',
            border: OutlineInputBorder(),
            hintText: 'Brief description about your coaching philosophy',
          ),
        ),
      ],
    );
  }

  Widget _buildRoleAndExperience() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Role & Experience',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _roleTitle,
          decoration: const InputDecoration(
            labelText: 'Role Title *',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.work),
          ),
          items: _roleTitles
              .map((role) => DropdownMenuItem(value: role, child: Text(role)))
              .toList(),
          onChanged: (value) => setState(() => _roleTitle = value!),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _experienceController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Years of Experience *',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.calendar_today),
          ),
          validator: (value) =>
              value?.isEmpty ?? true ? 'Experience is required' : null,
        ),
      ],
    );
  }

  Widget _buildSpecializations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Specializations',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _specializations.map((spec) {
            final isSelected = _selectedSpecializations.contains(spec);
            return FilterChip(
              label: Text(spec),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedSpecializations.add(spec);
                  } else {
                    _selectedSpecializations.remove(spec);
                  }
                });
              },
              selectedColor: AppColors.coachPrimary.withValues(alpha: 0.2),
              checkmarkColor: AppColors.coachPrimary,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAgeGroups() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Age Groups You Coach',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _ageGroups.map((age) {
            final isSelected = _selectedAgeGroups.contains(age);
            return FilterChip(
              label: Text(age),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedAgeGroups.add(age);
                  } else {
                    _selectedAgeGroups.remove(age);
                  }
                });
              },
              selectedColor: AppColors.coachPrimary.withValues(alpha: 0.2),
              checkmarkColor: AppColors.coachPrimary,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLicense() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Coaching License',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _licenseLevel,
          decoration: const InputDecoration(
            labelText: 'License Level',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.card_membership),
          ),
          items: _licenses
              .map((license) =>
                  DropdownMenuItem(value: license, child: Text(license)))
              .toList(),
          onChanged: (value) => setState(() => _licenseLevel = value),
        ),
      ],
    );
  }

  Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contact Information',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.email),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.phone),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.coachPrimary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text('Create Profile', style: TextStyle(fontSize: 16)),
      ),
    );
  }

  void _submitProfile() {
    if (_formKey.currentState?.validate() ?? false) {
      final profileData = {
        'full_name': _nameController.text,
        'club_name': _clubController.text.isEmpty ? null : _clubController.text,
        'role_title': _roleTitle,
        'years_of_experience': int.parse(_experienceController.text),
        'specializations': _selectedSpecializations,
        'age_groups': _selectedAgeGroups,
        'license_level': _licenseLevel,
        'email': _emailController.text.isEmpty ? null : _emailController.text,
        'phone_number':
            _phoneController.text.isEmpty ? null : _phoneController.text,
        'bio': _bioController.text.isEmpty ? null : _bioController.text,
      };

      context.read<CoachProfileBloc>().add(
            CreateCoachProfile(profileData: profileData),
          );
    }
  }
}
