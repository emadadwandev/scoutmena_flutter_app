import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_colors.dart';

/// Privacy settings screen
class PrivacySettingsPage extends StatefulWidget {
  const PrivacySettingsPage({super.key});

  @override
  State<PrivacySettingsPage> createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
  String _profileVisibility = 'public';
  bool _showEmail = true;
  bool _showPhone = false;
  bool _showSocialMedia = true;
  bool _allowScoutMessages = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPrivacySettings();
  }

  Future<void> _loadPrivacySettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _profileVisibility = prefs.getString('privacy_profile_visibility') ?? 'public';
        _showEmail = prefs.getBool('privacy_show_email') ?? true;
        _showPhone = prefs.getBool('privacy_show_phone') ?? false;
        _showSocialMedia = prefs.getBool('privacy_show_social_media') ?? true;
        _allowScoutMessages = prefs.getBool('privacy_allow_scout_messages') ?? true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading settings: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Privacy Settings'),
          backgroundColor: AppColors.scoutPrimary,
          foregroundColor: Colors.white,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Settings'),
        backgroundColor: AppColors.scoutPrimary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          _buildSectionHeader('Profile Visibility'),
          _buildVisibilitySection(),
          const Divider(),
          _buildSectionHeader('Contact Information'),
          _buildContactVisibilitySection(),
          const Divider(),
          _buildSectionHeader('Messaging'),
          _buildMessagingSection(),
          const Divider(),
          _buildSectionHeader('Blocked Users'),
          _buildBlockedUsersSection(),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _savePrivacySettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.scoutPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Save Changes'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildVisibilitySection() {
    return Column(
      children: [
        RadioListTile<String>(
          title: const Text('Public'),
          subtitle: const Text('Anyone can view your profile'),
          value: 'public',
          groupValue: _profileVisibility,
          onChanged: (value) {
            setState(() => _profileVisibility = value!);
          },
        ),
        RadioListTile<String>(
          title: const Text('Scouts Only'),
          subtitle: const Text('Only verified scouts can view'),
          value: 'scouts_only',
          groupValue: _profileVisibility,
          onChanged: (value) {
            setState(() => _profileVisibility = value!);
          },
        ),
        RadioListTile<String>(
          title: const Text('Private'),
          subtitle: const Text('Hidden from search'),
          value: 'private',
          groupValue: _profileVisibility,
          onChanged: (value) {
            setState(() => _profileVisibility = value!);
          },
        ),
      ],
    );
  }

  Widget _buildContactVisibilitySection() {
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Show Email'),
          subtitle: const Text('Allow others to see your email address'),
          value: _showEmail,
          onChanged: (value) {
            setState(() => _showEmail = value);
          },
        ),
        SwitchListTile(
          title: const Text('Show Phone Number'),
          subtitle: const Text('Allow others to see your phone number'),
          value: _showPhone,
          onChanged: (value) {
            setState(() => _showPhone = value);
          },
        ),
        SwitchListTile(
          title: const Text('Show Social Media'),
          subtitle: const Text('Display your social media handles'),
          value: _showSocialMedia,
          onChanged: (value) {
            setState(() => _showSocialMedia = value);
          },
        ),
      ],
    );
  }

  Widget _buildMessagingSection() {
    return SwitchListTile(
      title: const Text('Allow Scout Messages'),
      subtitle: const Text('Let scouts send you messages'),
      value: _allowScoutMessages,
      onChanged: (value) {
        setState(() => _allowScoutMessages = value);
      },
    );
  }

  Widget _buildBlockedUsersSection() {
    return ListTile(
      leading: const Icon(Icons.block),
      title: const Text('Blocked Users'),
      subtitle: const Text('0 users blocked'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // TODO: Navigate to blocked users list
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Blocked users list coming soon')),
        );
      },
    );
  }

  Future<void> _savePrivacySettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('privacy_profile_visibility', _profileVisibility);
      await prefs.setBool('privacy_show_email', _showEmail);
      await prefs.setBool('privacy_show_phone', _showPhone);
      await prefs.setBool('privacy_show_social_media', _showSocialMedia);
      await prefs.setBool('privacy_allow_scout_messages', _allowScoutMessages);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Privacy settings saved successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving settings: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
