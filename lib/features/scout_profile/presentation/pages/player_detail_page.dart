import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../player_profile/domain/entities/player_profile.dart';
import '../../../../core/theme/app_colors.dart';

/// Player detail view for scouts
/// Shows comprehensive player information with privacy considerations
class PlayerDetailPage extends StatefulWidget {
  final PlayerProfile player;

  const PlayerDetailPage({
    super.key,
    required this.player,
  });

  @override
  State<PlayerDetailPage> createState() => _PlayerDetailPageState();
}

class _PlayerDetailPageState extends State<PlayerDetailPage> {
  @override
  void initState() {
    super.initState();
    // TODO: Record profile view for analytics
    // context.read<ScoutProfileBloc>().add(RecordProfileView(playerId: widget.player.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPlayerHeader(),
                const Divider(height: 1),
                _buildBasicInfo(),
                const Divider(height: 1),
                _buildPhysicalAttributes(),
                const Divider(height: 1),
                if (!widget.player.isMinor || widget.player.parentalConsentGiven)
                  _buildContactInfo(),
                if (!widget.player.isMinor || widget.player.parentalConsentGiven)
                  const Divider(height: 1),
                _buildCareerInfo(),
                const SizedBox(height: 100), // Space for FAB
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildActionButtons(),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: AppColors.scoutPrimary,
      flexibleSpace: FlexibleSpaceBar(
        background: widget.player.profilePhotoUrl != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.player.profilePhotoUrl!,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Container(
                color: Colors.grey[300],
                child: const Icon(
                  Icons.person,
                  size: 100,
                  color: Colors.grey,
                ),
              ),
      ),
    );
  }

  Widget _buildPlayerHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.player.fullName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.player.age} years old',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.player.isMinor)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.shield, size: 16, color: Colors.orange),
                      SizedBox(width: 4),
                      Text(
                        'Minor',
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.player.positions.map((position) {
              return Chip(
                label: Text(position),
                backgroundColor: AppColors.scoutPrimary.withOpacity(0.1),
                labelStyle: const TextStyle(
                  color: AppColors.scoutPrimary,
                  fontWeight: FontWeight.bold,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Basic Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.flag,
            label: 'Nationality',
            value: widget.player.nationality,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.shield,
            label: 'Current Club',
            value: widget.player.currentClub ?? 'Free Agent',
          ),
          const SizedBox(height: 12),
          if (widget.player.jerseyNumber != null)
            _buildInfoRow(
              icon: Icons.tag,
              label: 'Jersey Number',
              value: '#${widget.player.jerseyNumber}',
            ),
          if (widget.player.jerseyNumber != null) const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.sports_soccer,
            label: 'Dominant Foot',
            value: widget.player.dominantFoot.toUpperCase(),
          ),
        ],
      ),
    );
  }

  Widget _buildPhysicalAttributes() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Physical Attributes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.height,
                  label: 'Height',
                  value: '${widget.player.height.toInt()} cm',
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.monitor_weight,
                  label: 'Weight',
                  value: '${widget.player.weight.toInt()} kg',
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo() {
    final hasContactInfo = widget.player.email != null ||
        widget.player.phoneNumber != null ||
        widget.player.instagramHandle != null ||
        widget.player.twitterHandle != null;

    if (!hasContactInfo) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contact Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (widget.player.email != null) ...[
            _buildInfoRow(
              icon: Icons.email,
              label: 'Email',
              value: widget.player.email!,
            ),
            const SizedBox(height: 12),
          ],
          if (widget.player.phoneNumber != null) ...[
            _buildInfoRow(
              icon: Icons.phone,
              label: 'Phone',
              value: widget.player.phoneNumber!,
            ),
            const SizedBox(height: 12),
          ],
          if (widget.player.instagramHandle != null) ...[
            _buildInfoRow(
              icon: Icons.camera_alt,
              label: 'Instagram',
              value: '@${widget.player.instagramHandle}',
            ),
            const SizedBox(height: 12),
          ],
          if (widget.player.twitterHandle != null)
            _buildInfoRow(
              icon: Icons.alternate_email,
              label: 'Twitter',
              value: '@${widget.player.twitterHandle}',
            ),
        ],
      ),
    );
  }

  Widget _buildCareerInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Career Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.calendar_today,
            label: 'Years Playing',
            value: '${widget.player.yearsPlaying} years',
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.verified,
            label: 'Profile Status',
            value: _formatProfileStatus(widget.player.profileStatus),
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.checklist,
            label: 'Profile Completeness',
            value: '${widget.player.profileCompleteness}%',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: AppColors.scoutPrimary),
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
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    final canContact = !widget.player.isMinor || widget.player.parentalConsentGiven;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FloatingActionButton.extended(
          onPressed: _savePlayer,
          backgroundColor: AppColors.scoutPrimary,
          icon: const Icon(Icons.bookmark_add),
          label: const Text('Save Player'),
          heroTag: 'save',
        ),
        const SizedBox(height: 12),
        FloatingActionButton(
          onPressed: _shareProfile,
          backgroundColor: Colors.white,
          foregroundColor: AppColors.scoutPrimary,
          heroTag: 'share',
          child: const Icon(Icons.share),
        ),
        if (canContact) ...[
          const SizedBox(height: 12),
          FloatingActionButton(
            onPressed: _contactPlayer,
            backgroundColor: Colors.white,
            foregroundColor: AppColors.scoutPrimary,
            heroTag: 'contact',
            child: const Icon(Icons.message),
          ),
        ],
      ],
    );
  }

  String _formatProfileStatus(String status) {
    switch (status) {
      case 'incomplete':
        return 'Incomplete';
      case 'pending_consent':
        return 'Pending Consent';
      case 'active':
        return 'Active';
      default:
        return status;
    }
  }

  void _savePlayer() {
    // Show saved confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.bookmark_added, color: Colors.green, size: 48),
        title: const Text('Player Saved'),
        content: Text(
          '${widget.player.fullName} has been added to your saved players list.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Navigate to saved players list
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('View saved players coming soon')),
              );
            },
            child: const Text('View Saved'),
          ),
        ],
      ),
    );
  }

  Future<void> _shareProfile() async {
    final player = widget.player;
    final shareText = '''
Check out ${player.fullName} on ScoutMena!

Age: ${player.age} years
Position: ${player.positions.join(', ')}
Nationality: ${player.nationality}
${player.currentClub != null ? 'Club: ${player.currentClub}' : ''}

Profile: https://scoutmena.com/players/${player.id}
''';

    try {
      await Share.share(
        shareText,
        subject: 'Football Player Profile - ${player.fullName}',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not share profile: $e')),
        );
      }
    }
  }

  void _contactPlayer() {
    final player = widget.player;
    final canContact = !player.isMinor || player.parentalConsentGiven;

    if (!canContact) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot contact minor without parental consent'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contact Player',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (player.email != null)
              ListTile(
                leading: const Icon(Icons.email, color: AppColors.scoutPrimary),
                title: const Text('Send Email'),
                subtitle: Text(player.email!),
                onTap: () async {
                  Navigator.pop(context);
                  final uri = Uri.parse('mailto:${player.email}');
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  }
                },
              ),
            if (player.phoneNumber != null)
              ListTile(
                leading: const Icon(Icons.phone, color: AppColors.scoutPrimary),
                title: const Text('Call/Message'),
                subtitle: Text(player.phoneNumber!),
                onTap: () async {
                  Navigator.pop(context);
                  final uri = Uri.parse('tel:${player.phoneNumber}');
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  }
                },
              ),
            if (player.instagramHandle != null)
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColors.scoutPrimary),
                title: const Text('Instagram'),
                subtitle: Text('@${player.instagramHandle}'),
                onTap: () async {
                  Navigator.pop(context);
                  final uri = Uri.parse('https://instagram.com/${player.instagramHandle}');
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
              ),
            ListTile(
              leading: const Icon(Icons.message, color: AppColors.scoutPrimary),
              title: const Text('Send Message'),
              subtitle: const Text('Contact via ScoutMena messaging'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to messaging screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Messaging feature coming soon')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
