import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/scout_profile_bloc.dart';
import '../bloc/scout_profile_event.dart';
import '../bloc/scout_profile_state.dart';

/// Scout profile setup page with verification
class ScoutProfileSetupPage extends StatefulWidget {
  const ScoutProfileSetupPage({super.key});

  @override
  State<ScoutProfileSetupPage> createState() => _ScoutProfileSetupPageState();
}

class _ScoutProfileSetupPageState extends State<ScoutProfileSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final _organizationController = TextEditingController();
  final _roleTitleController = TextEditingController();
  final _yearsExperienceController = TextEditingController();
  final _licenseNumberController = TextEditingController();
  final _contactEmailController = TextEditingController();
  final _contactPhoneController = TextEditingController();
  final _websiteController = TextEditingController();

  final List<String> _selectedCountries = [];
  final List<String> _selectedPositions = [];
  File? _verificationDocument;
  final ImagePicker _picker = ImagePicker();

  static const List<String> _countries = [
    'Egypt', 'Saudi Arabia', 'UAE', 'Qatar', 'Morocco', 'Tunisia',
    'Algeria', 'Jordan', 'Lebanon', 'Iraq', 'Palestine', 'Syria',
  ];

  static const List<String> _positions = [
    'GK', 'RB', 'CB', 'LB', 'CDM', 'CM', 'CAM', 'RM', 'LM', 'RW', 'LW', 'ST'
  ];

  @override
  void dispose() {
    _organizationController.dispose();
    _roleTitleController.dispose();
    _yearsExperienceController.dispose();
    _licenseNumberController.dispose();
    _contactEmailController.dispose();
    _contactPhoneController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  Future<void> _pickVerificationDocument() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        _verificationDocument = File(file.path);
      });
    }
  }

  void _submitProfile() {
    if (_formKey.currentState!.validate()) {
      if (_selectedCountries.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one country')),
        );
        return;
      }
      if (_selectedPositions.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one position')),
        );
        return;
      }

      final profileData = {
        'organization_name': _organizationController.text,
        'role_title': _roleTitleController.text,
        'years_of_experience': int.parse(_yearsExperienceController.text),
        'countries_of_interest': _selectedCountries,
        'positions_of_interest': _selectedPositions,
        'license_number': _licenseNumberController.text,
        'contact_email': _contactEmailController.text,
        'contact_phone': _contactPhoneController.text,
        'website': _websiteController.text,
      };

      context.read<ScoutProfileBloc>().add(
            CreateScoutProfile(profileData: profileData),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ScoutProfileBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Scout Profile Setup'),
          backgroundColor: AppColors.scoutPrimary,
        ),
        body: BlocConsumer<ScoutProfileBloc, ScoutProfileState>(
          listener: (context, state) {
            if (state is ScoutProfileCreated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile submitted for verification!'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
            } else if (state is ScoutProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ScoutProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoCard(),
                    const SizedBox(height: 24),
                    _buildOrganizationSection(),
                    const SizedBox(height: 24),
                    _buildInterestsSection(),
                    const SizedBox(height: 24),
                    _buildContactSection(),
                    const SizedBox(height: 24),
                    _buildVerificationSection(),
                    const SizedBox(height: 32),
                    _buildSubmitButton(context),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: AppColors.scoutPrimary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Your profile will be reviewed by our team. You\'ll receive a notification once verified.',
                style: TextStyle(fontSize: 13, color: Colors.blue[900]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrganizationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Organization Details',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _organizationController,
          decoration: const InputDecoration(
            labelText: 'Organization/Club Name *',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.business),
          ),
          validator: (value) =>
              value?.isEmpty ?? true ? 'Required field' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _roleTitleController,
          decoration: const InputDecoration(
            labelText: 'Role/Title *',
            hintText: 'e.g., Head Scout, Talent Manager',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.badge),
          ),
          validator: (value) =>
              value?.isEmpty ?? true ? 'Required field' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _yearsExperienceController,
          decoration: const InputDecoration(
            labelText: 'Years of Experience *',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.timeline),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Required field';
            final years = int.tryParse(value!);
            if (years == null || years < 0) return 'Invalid number';
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _licenseNumberController,
          decoration: const InputDecoration(
            labelText: 'License Number (Optional)',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.credit_card),
          ),
        ),
      ],
    );
  }

  Widget _buildInterestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Scouting Interests',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Text(
          'Countries of Interest *',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: _countries.map((country) {
            final isSelected = _selectedCountries.contains(country);
            return FilterChip(
              label: Text(country),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedCountries.add(country);
                  } else {
                    _selectedCountries.remove(country);
                  }
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        Text(
          'Positions of Interest *',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: _positions.map((position) {
            final isSelected = _selectedPositions.contains(position);
            return FilterChip(
              label: Text(position),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedPositions.add(position);
                  } else {
                    _selectedPositions.remove(position);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Information',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _contactEmailController,
          decoration: const InputDecoration(
            labelText: 'Contact Email',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.email),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _contactPhoneController,
          decoration: const InputDecoration(
            labelText: 'Contact Phone',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.phone),
          ),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _websiteController,
          decoration: const InputDecoration(
            labelText: 'Website (Optional)',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.language),
          ),
          keyboardType: TextInputType.url,
        ),
      ],
    );
  }

  Widget _buildVerificationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Verification Documents',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Upload your ID or club license for verification',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: _pickVerificationDocument,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  _verificationDocument != null
                      ? Icons.check_circle
                      : Icons.upload_file,
                  color: _verificationDocument != null
                      ? Colors.green
                      : Colors.grey,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _verificationDocument != null
                        ? 'Document uploaded: ${_verificationDocument!.path.split('/').last}'
                        : 'Tap to upload document',
                    style: TextStyle(
                      color: _verificationDocument != null
                          ? Colors.black87
                          : Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _submitProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.scoutPrimary,
        ),
        child: const Text(
          'Submit for Verification',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
