import 'package:flutter/material.dart';
import '../../domain/entities/player_profile.dart';
import '../../../../core/theme/app_colors.dart';

/// Profile information card displaying contact and additional details
class ProfileInfoCard extends StatelessWidget {
  final PlayerProfile profile;

  const ProfileInfoCard({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.playerPrimary),
                const SizedBox(width: 8),
                Text(
                  'Profile Information',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Contact Information
            if (profile.email != null || profile.phoneNumber != null) ...[
              _buildSectionTitle(context, 'Contact'),
              const SizedBox(height: 8),
              if (profile.email != null)
                _buildInfoRow(
                  Icons.email,
                  'Email',
                  profile.email!,
                ),
              if (profile.phoneNumber != null)
                _buildInfoRow(
                  Icons.phone,
                  'Phone',
                  profile.phoneNumber!,
                ),
              const SizedBox(height: 16),
            ],

            // Social Media
            if (profile.instagramHandle != null ||
                profile.twitterHandle != null) ...[
              _buildSectionTitle(context, 'Social Media'),
              const SizedBox(height: 8),
              if (profile.instagramHandle != null)
                _buildInfoRow(
                  Icons.camera_alt,
                  'Instagram',
                  profile.instagramHandle!,
                ),
              if (profile.twitterHandle != null)
                _buildInfoRow(
                  Icons.alternate_email,
                  'Twitter',
                  profile.twitterHandle!,
                ),
              const SizedBox(height: 16),
            ],

            // Football Info
            _buildSectionTitle(context, 'Football Details'),
            const SizedBox(height: 8),
            _buildInfoRow(
              Icons.sports_soccer,
              'Experience',
              '${profile.yearsPlaying} ${profile.yearsPlaying == 1 ? "year" : "years"}',
            ),
            if (profile.currentClub != null)
              _buildInfoRow(
                Icons.shield,
                'Current Club',
                profile.currentClub!,
              ),
            _buildInfoRow(
              Icons.sports,
              'Dominant Foot',
              _formatFoot(profile.dominantFoot),
            ),
            if (profile.jerseyNumber != null)
              _buildInfoRow(
                Icons.numbers,
                'Jersey Number',
                '#${profile.jerseyNumber}',
              ),

            // Profile Completeness
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Profile Completeness',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  '${profile.profileCompleteness}%',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _getCompletenessColor(profile.profileCompleteness),
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: profile.profileCompleteness / 100,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getCompletenessColor(profile.profileCompleteness),
                ),
                minHeight: 8,
              ),
            ),

            // Account Created
            const SizedBox(height: 16),
            _buildInfoRow(
              Icons.calendar_today,
              'Member Since',
              _formatDate(profile.createdAt),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.playerPrimary,
          ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatFoot(String foot) {
    switch (foot.toLowerCase()) {
      case 'left':
        return 'Left Footed';
      case 'right':
        return 'Right Footed';
      case 'both':
        return 'Both Feet';
      default:
        return foot;
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  Color _getCompletenessColor(int completeness) {
    if (completeness >= 80) {
      return Colors.green;
    } else if (completeness >= 50) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
