import 'package:flutter/material.dart';
import '../../models/profile_setup_form_data.dart';

/// Step 4: Parent Information (for minors only)
class ParentInfoStep extends StatefulWidget {
  final ProfileSetupFormData formData;
  final ValueChanged<ProfileSetupFormData> onDataChanged;

  const ParentInfoStep({
    super.key,
    required this.formData,
    required this.onDataChanged,
  });

  @override
  State<ParentInfoStep> createState() => _ParentInfoStepState();
}

class _ParentInfoStepState extends State<ParentInfoStep> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _parentNameController;
  late TextEditingController _parentEmailController;
  late TextEditingController _parentPhoneController;
  late TextEditingController _emergencyContactController;

  @override
  void initState() {
    super.initState();
    _parentNameController = TextEditingController(text: widget.formData.parentName ?? '');
    _parentEmailController = TextEditingController(text: widget.formData.parentEmail ?? '');
    _parentPhoneController = TextEditingController(text: widget.formData.parentPhone ?? '');
    _emergencyContactController = TextEditingController(text: widget.formData.emergencyContact ?? '');
  }

  @override
  void dispose() {
    _parentNameController.dispose();
    _parentEmailController.dispose();
    _parentPhoneController.dispose();
    _emergencyContactController.dispose();
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
            'Parent/Guardian Information',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Required for users under 18 years old',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 24),

          // COPPA Compliance Notice
          Card(
            color: Colors.orange[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.verified_user, color: Colors.orange[700]),
                      const SizedBox(width: 8),
                      Text(
                        'Parental Consent Required',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[900],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'As you are under 18, we need your parent or guardian\'s consent before you can use ScoutMena. We\'ll send a consent request to the email address you provide below.',
                    style: TextStyle(
                      color: Colors.orange[900],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Parent/Guardian Name
          TextFormField(
            controller: _parentNameController,
            decoration: const InputDecoration(
              labelText: 'Parent/Guardian Name *',
              hintText: 'Full name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter parent/guardian name';
              }
              return null;
            },
            onChanged: (value) {
              widget.onDataChanged(
                widget.formData.copyWith(parentName: value),
              );
            },
          ),
          const SizedBox(height: 16),

          // Parent/Guardian Email
          TextFormField(
            controller: _parentEmailController,
            decoration: const InputDecoration(
              labelText: 'Parent/Guardian Email *',
              hintText: 'parent@example.com',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter parent/guardian email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
            onChanged: (value) {
              widget.onDataChanged(
                widget.formData.copyWith(parentEmail: value),
              );
            },
          ),
          const SizedBox(height: 16),

          // Parent/Guardian Phone
          TextFormField(
            controller: _parentPhoneController,
            decoration: const InputDecoration(
              labelText: 'Parent/Guardian Phone *',
              hintText: '+1234567890',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.phone),
            ),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter parent/guardian phone';
              }
              return null;
            },
            onChanged: (value) {
              widget.onDataChanged(
                widget.formData.copyWith(parentPhone: value),
              );
            },
          ),
          const SizedBox(height: 16),

          // Emergency Contact
          TextFormField(
            controller: _emergencyContactController,
            decoration: const InputDecoration(
              labelText: 'Emergency Contact',
              hintText: 'Name and phone number',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.emergency),
            ),
            maxLines: 2,
            onChanged: (value) {
              widget.onDataChanged(
                widget.formData.copyWith(
                  emergencyContact: value.isEmpty ? null : value,
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Next Steps Info
          Card(
            color: Colors.blue[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue[700]),
                      const SizedBox(width: 8),
                      Text(
                        'What happens next?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildNextStep('1', 'We\'ll send a consent email to your parent/guardian'),
                  _buildNextStep('2', 'They\'ll review and approve your profile'),
                  _buildNextStep('3', 'Once approved, your profile will be active'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.blue[700],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.blue[900],
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
