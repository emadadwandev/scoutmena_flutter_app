import 'package:flutter/material.dart';
import '../../models/profile_setup_form_data.dart';

/// Step 3: Contact & Social Information
class ContactInfoStep extends StatefulWidget {
  final ProfileSetupFormData formData;
  final ValueChanged<ProfileSetupFormData> onDataChanged;

  const ContactInfoStep({
    super.key,
    required this.formData,
    required this.onDataChanged,
  });

  @override
  State<ContactInfoStep> createState() => _ContactInfoStepState();
}

class _ContactInfoStepState extends State<ContactInfoStep> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _instagramController;
  late TextEditingController _twitterController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.formData.email ?? '');
    _phoneController = TextEditingController(text: widget.formData.phoneNumber ?? '');
    _instagramController = TextEditingController(text: widget.formData.instagramHandle ?? '');
    _twitterController = TextEditingController(text: widget.formData.twitterHandle ?? '');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _instagramController.dispose();
    _twitterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Contact & Social',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'How can scouts reach you?',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 32),

          // Email
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email *',
              hintText: 'your.email@example.com',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
            onChanged: (value) {
              widget.onDataChanged(
                widget.formData.copyWith(email: value),
              );
            },
          ),
          const SizedBox(height: 16),

          // Phone Number
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              hintText: '+1234567890',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.phone),
            ),
            keyboardType: TextInputType.phone,
            onChanged: (value) {
              widget.onDataChanged(
                widget.formData.copyWith(
                  phoneNumber: value.isEmpty ? null : value,
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Social Media Section
          Text(
            'Social Media (Optional)',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Help scouts discover your highlights and content',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 16),

          // Instagram
          TextFormField(
            controller: _instagramController,
            decoration: const InputDecoration(
              labelText: 'Instagram',
              hintText: '@username',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.camera_alt),
            ),
            onChanged: (value) {
              widget.onDataChanged(
                widget.formData.copyWith(
                  instagramHandle: value.isEmpty ? null : value,
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Twitter/X
          TextFormField(
            controller: _twitterController,
            decoration: const InputDecoration(
              labelText: 'Twitter / X',
              hintText: '@username',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.alternate_email),
            ),
            onChanged: (value) {
              widget.onDataChanged(
                widget.formData.copyWith(
                  twitterHandle: value.isEmpty ? null : value,
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Info Card
          Card(
            color: Colors.green[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.green[700]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Your contact information is only visible to verified scouts and coaches.',
                      style: TextStyle(
                        color: Colors.green[900],
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
