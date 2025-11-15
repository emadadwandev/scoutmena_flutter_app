import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/profile_setup_form_data.dart';
import '../photo_upload_widget.dart';

/// Step 1: Basic Information
class BasicInfoStep extends StatefulWidget {
  final ProfileSetupFormData formData;
  final ValueChanged<ProfileSetupFormData> onDataChanged;

  const BasicInfoStep({
    super.key,
    required this.formData,
    required this.onDataChanged,
  });

  @override
  State<BasicInfoStep> createState() => _BasicInfoStepState();
}

class _BasicInfoStepState extends State<BasicInfoStep> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _dobController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.formData.fullName);
    _dobController = TextEditingController(
      text: widget.formData.dateOfBirth != null
          ? DateFormat('yyyy-MM-dd').format(widget.formData.dateOfBirth!)
          : '',
    );
    _heightController = TextEditingController(
      text: widget.formData.height?.toString() ?? '',
    );
    _weightController = TextEditingController(
      text: widget.formData.weight?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _dobController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.formData.dateOfBirth ?? DateTime(2010, 1, 1),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
        final age = _calculateAge(picked);
        widget.onDataChanged(
          widget.formData.copyWith(
            dateOfBirth: picked,
            isMinor: age < 18,
          ),
        );
      });
    }
  }

  int _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Basic Information',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tell us about yourself',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 32),

          // Profile Photo
          Center(
            child: PhotoUploadWidget(
              photo: widget.formData.profilePhoto,
              onPhotoSelected: (photo) {
                widget.onDataChanged(
                  widget.formData.copyWith(profilePhoto: photo),
                );
              },
            ),
          ),
          const SizedBox(height: 32),

          // Full Name
          TextFormField(
            controller: _fullNameController,
            decoration: const InputDecoration(
              labelText: 'Full Name *',
              hintText: 'Enter your full name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your full name';
              }
              return null;
            },
            onChanged: (value) {
              widget.onDataChanged(
                widget.formData.copyWith(fullName: value),
              );
            },
          ),
          const SizedBox(height: 16),

          // Date of Birth
          TextFormField(
            controller: _dobController,
            decoration: const InputDecoration(
              labelText: 'Date of Birth *',
              hintText: 'Select your date of birth',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.calendar_today),
            ),
            readOnly: true,
            onTap: () => _selectDate(context),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select your date of birth';
              }
              return null;
            },
          ),
          if (widget.formData.age != null) ...[
            const SizedBox(height: 8),
            Text(
              'Age: ${widget.formData.age} years${widget.formData.isMinor ? " (Minor - Parental consent required)" : ""}',
              style: TextStyle(
                color: widget.formData.isMinor ? Colors.orange[700] : Colors.grey[600],
                fontSize: 12,
                fontWeight: widget.formData.isMinor ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
          const SizedBox(height: 16),

          // Nationality
          DropdownButtonFormField<String>(
            value: widget.formData.nationality,
            decoration: const InputDecoration(
              labelText: 'Nationality *',
              border: OutlineInputBorder(),
            ),
            items: _getNationalities()
                .map((nationality) => DropdownMenuItem(
                      value: nationality,
                      child: Text(nationality),
                    ))
                .toList(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select your nationality';
              }
              return null;
            },
            onChanged: (value) {
              widget.onDataChanged(
                widget.formData.copyWith(nationality: value),
              );
            },
          ),
          const SizedBox(height: 16),

          // Height and Weight Row
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _heightController,
                  decoration: const InputDecoration(
                    labelText: 'Height (cm) *',
                    hintText: '180',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    final height = double.tryParse(value);
                    if (height == null || height < 100 || height > 250) {
                      return 'Invalid';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    final height = double.tryParse(value);
                    if (height != null) {
                      widget.onDataChanged(
                        widget.formData.copyWith(height: height),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _weightController,
                  decoration: const InputDecoration(
                    labelText: 'Weight (kg) *',
                    hintText: '75',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    final weight = double.tryParse(value);
                    if (weight == null || weight < 30 || weight > 200) {
                      return 'Invalid';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    final weight = double.tryParse(value);
                    if (weight != null) {
                      widget.onDataChanged(
                        widget.formData.copyWith(weight: weight),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Dominant Foot
          DropdownButtonFormField<String>(
            value: widget.formData.dominantFoot,
            decoration: const InputDecoration(
              labelText: 'Dominant Foot *',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'left', child: Text('Left')),
              DropdownMenuItem(value: 'right', child: Text('Right')),
              DropdownMenuItem(value: 'both', child: Text('Both')),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select your dominant foot';
              }
              return null;
            },
            onChanged: (value) {
              widget.onDataChanged(
                widget.formData.copyWith(dominantFoot: value),
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  List<String> _getNationalities() {
    return [
      'Egypt',
      'Saudi Arabia',
      'United Arab Emirates',
      'Qatar',
      'Kuwait',
      'Bahrain',
      'Oman',
      'Jordan',
      'Lebanon',
      'Morocco',
      'Tunisia',
      'Algeria',
      'Iraq',
      'Syria',
      'Palestine',
      'Yemen',
      'Libya',
      'Sudan',
      // Add more as needed
      'Other',
    ];
  }
}
