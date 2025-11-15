import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_colors.dart';

/// Notification settings screen
class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _profileViews = true;
  bool _newMessages = true;
  bool _savedSearchMatches = true;
  bool _moderationUpdates = true;
  bool _systemAnnouncements = true;
  bool _emailNotifications = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _profileViews = prefs.getBool('notif_profile_views') ?? true;
        _newMessages = prefs.getBool('notif_new_messages') ?? true;
        _savedSearchMatches = prefs.getBool('notif_saved_search_matches') ?? true;
        _moderationUpdates = prefs.getBool('notif_moderation_updates') ?? true;
        _systemAnnouncements = prefs.getBool('notif_system_announcements') ?? true;
        _emailNotifications = prefs.getBool('notif_email_notifications') ?? false;
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
          title: const Text('Notification Settings'),
          backgroundColor: AppColors.scoutPrimary,
          foregroundColor: Colors.white,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
        backgroundColor: AppColors.scoutPrimary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          _buildSectionHeader('Push Notifications'),
          SwitchListTile(
            title: const Text('Profile Views'),
            subtitle: const Text('When someone views your profile'),
            value: _profileViews,
            onChanged: (value) {
              setState(() => _profileViews = value);
            },
          ),
          SwitchListTile(
            title: const Text('New Messages'),
            subtitle: const Text('When you receive a new message'),
            value: _newMessages,
            onChanged: (value) {
              setState(() => _newMessages = value);
            },
          ),
          SwitchListTile(
            title: const Text('Saved Search Matches'),
            subtitle: const Text('When new players match your saved searches'),
            value: _savedSearchMatches,
            onChanged: (value) {
              setState(() => _savedSearchMatches = value);
            },
          ),
          SwitchListTile(
            title: const Text('Moderation Updates'),
            subtitle: const Text('Status updates on your content'),
            value: _moderationUpdates,
            onChanged: (value) {
              setState(() => _moderationUpdates = value);
            },
          ),
          SwitchListTile(
            title: const Text('System Announcements'),
            subtitle: const Text('Important updates from ScoutMena'),
            value: _systemAnnouncements,
            onChanged: (value) {
              setState(() => _systemAnnouncements = value);
            },
          ),
          const Divider(),
          _buildSectionHeader('Email Notifications'),
          SwitchListTile(
            title: const Text('Email Notifications'),
            subtitle: const Text('Receive notifications via email'),
            value: _emailNotifications,
            onChanged: (value) {
              setState(() => _emailNotifications = value);
            },
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _saveNotificationSettings,
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

  Future<void> _saveNotificationSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setBool('notif_profile_views', _profileViews);
      await prefs.setBool('notif_new_messages', _newMessages);
      await prefs.setBool('notif_saved_search_matches', _savedSearchMatches);
      await prefs.setBool('notif_moderation_updates', _moderationUpdates);
      await prefs.setBool('notif_system_announcements', _systemAnnouncements);
      await prefs.setBool('notif_email_notifications', _emailNotifications);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notification settings saved successfully'),
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
