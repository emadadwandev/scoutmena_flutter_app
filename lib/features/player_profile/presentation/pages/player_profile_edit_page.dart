import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/player_profile.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/player_profile_bloc.dart';
import '../bloc/player_profile_event.dart' as profile_events;
import '../bloc/player_profile_state.dart';
import '../widgets/photo_upload_widget.dart';
import '../widgets/position_selector.dart';

/// Player profile edit page for updating profile information
class PlayerProfileEditPage extends StatefulWidget {
  final PlayerProfile profile;

  const PlayerProfileEditPage({
    super.key,
    required this.profile,
  });

  @override
  State<PlayerProfileEditPage> createState() => _PlayerProfileEditPageState();
}

class _PlayerProfileEditPageState extends State<PlayerProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _clubController;
  late TextEditingController _jerseyController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _instagramController;
  late TextEditingController _twitterController;

  String? _dominantFoot;
  List<String> _selectedPositions = [];
  int? _yearsPlaying;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.profile.fullName);
    _clubController = TextEditingController(text: widget.profile.currentClub);
    _jerseyController = TextEditingController(
      text: widget.profile.jerseyNumber?.toString(),
    );
    _heightController = TextEditingController(
      text: widget.profile.height.toString(),
    );
    _weightController = TextEditingController(
      text: widget.profile.weight.toString(),
    );
    _emailController = TextEditingController(text: widget.profile.email);
    _phoneController = TextEditingController(text: widget.profile.phoneNumber);
    _instagramController = TextEditingController(
      text: widget.profile.instagramHandle,
    );
    _twitterController = TextEditingController(
      text: widget.profile.twitterHandle,
    );

    _dominantFoot = widget.profile.dominantFoot;
    _selectedPositions = List.from(widget.profile.positions);
    _yearsPlaying = widget.profile.yearsPlaying;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _clubController.dispose();
    _jerseyController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _instagramController.dispose();
    _twitterController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final updatedData = {
        'full_name': _fullNameController.text,
        'height': double.parse(_heightController.text),
        'weight': double.parse(_weightController.text),
        'dominant_foot': _dominantFoot,
        'current_club': _clubController.text.isEmpty ? null : _clubController.text,
        'positions': _selectedPositions,
        'jersey_number': _jerseyController.text.isEmpty
            ? null
            : int.parse(_jerseyController.text),
        'years_playing': _yearsPlaying,
        'email': _emailController.text,
        'phone_number': _phoneController.text.isEmpty ? null : _phoneController.text,
        'instagram_handle':
            _instagramController.text.isEmpty ? null : _instagramController.text,
        'twitter_handle':
            _twitterController.text.isEmpty ? null : _twitterController.text,
      };

      context.read<PlayerProfileBloc>().add(
            profile_events.UpdatePlayerProfile(
              playerId: widget.profile.id,
              profileData: updatedData,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PlayerProfileBloc>(),
      child: BlocConsumer<PlayerProfileBloc, PlayerProfileState>(
        listener: (context, state) {
          if (state is PlayerProfileUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true); // Return true to indicate success
          } else if (state is PlayerProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is ProfileUpdating;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Edit Profile'),
              actions: [
                TextButton(
                  onPressed: isLoading ? null : _saveProfile,
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            ),
            body: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Profile Photo
                  Center(
                    child: PhotoUploadWidget(
                      photo: null,
                      existingPhotoUrl: widget.profile.profilePhotoUrl,
                      onPhotoSelected: (photo) {
                        if (photo != null) {
                          context.read<PlayerProfileBloc>().add(
                                profile_events.UploadProfilePhoto(
                                  playerId: widget.profile.id,
                                  photoFile: photo,
                                ),
                              );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Basic Information Section
                  _buildSectionTitle('Basic Information'),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _fullNameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _heightController,
                          decoration: const InputDecoration(
                            labelText: 'Height (cm) *',
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
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _weightController,
                          decoration: const InputDecoration(
                            labelText: 'Weight (kg) *',
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
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    value: _dominantFoot,
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
                      if (value == null) {
                        return 'Please select dominant foot';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _dominantFoot = value;
                      });
                    },
                  ),
                  const SizedBox(height: 32),

                  // Football Information Section
                  _buildSectionTitle('Football Information'),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _clubController,
                    decoration: const InputDecoration(
                      labelText: 'Current Club',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  PositionSelector(
                    selectedPositions: _selectedPositions,
                    onChanged: (positions) {
                      setState(() {
                        _selectedPositions = positions;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _jerseyController,
                          decoration: const InputDecoration(
                            labelText: 'Jersey Number',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              final number = int.tryParse(value);
                              if (number == null || number < 1 || number > 99) {
                                return 'Invalid';
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          value: _yearsPlaying,
                          decoration: const InputDecoration(
                            labelText: 'Years Playing *',
                            border: OutlineInputBorder(),
                          ),
                          items: List.generate(30, (index) => index + 1)
                              .map((year) => DropdownMenuItem(
                                    value: year,
                                    child: Text('$year ${year == 1 ? "year" : "years"}'),
                                  ))
                              .toList(),
                          validator: (value) {
                            if (value == null) {
                              return 'Required';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _yearsPlaying = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Contact & Social Section
                  _buildSectionTitle('Contact & Social'),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _instagramController,
                    decoration: const InputDecoration(
                      labelText: 'Instagram',
                      hintText: '@username',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.camera_alt),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _twitterController,
                    decoration: const InputDecoration(
                      labelText: 'Twitter / X',
                      hintText: '@username',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.alternate_email),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.playerPrimary,
      ),
    );
  }
}
