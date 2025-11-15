import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';

/// About & Help screen with app information
class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String _appVersion = '';
  String _buildNumber = '';

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  Future<void> _loadAppInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
      _buildNumber = packageInfo.buildNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About ScoutMena'),
        backgroundColor: AppColors.scoutPrimary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAppInfo(),
          const SizedBox(height: 24),
          _buildDescription(),
          const SizedBox(height: 24),
          _buildFeatures(),
          const SizedBox(height: 24),
          _buildLinks(),
          const SizedBox(height: 24),
          _buildContactSupport(),
          const SizedBox(height: 24),
          _buildCredits(),
        ],
      ),
    );
  }

  Widget _buildAppInfo() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.scoutPrimary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.sports_soccer,
                size: 60,
                color: AppColors.scoutPrimary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'ScoutMena',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Version $_appVersion ($_buildNumber)',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Football Talent Discovery Platform',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About Us',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'ScoutMena is a comprehensive platform connecting football talents with scouts, coaches, and clubs across the MENA region. We aim to democratize talent discovery and provide opportunities for aspiring football players.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatures() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Key Features',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildFeatureItem(
              Icons.person_search,
              'Player Profiles',
              'Comprehensive player profiles with videos, stats, and achievements',
            ),
            const SizedBox(height: 12),
            _buildFeatureItem(
              Icons.search,
              'Scout Network',
              'Connect with verified scouts and coaches worldwide',
            ),
            const SizedBox(height: 12),
            _buildFeatureItem(
              Icons.groups,
              'Team Management',
              'Manage teams, track player development, and analyze performance',
            ),
            const SizedBox(height: 12),
            _buildFeatureItem(
              Icons.verified_user,
              'Verification System',
              'Trust and credibility through verified profiles',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.scoutPrimary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.scoutPrimary, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLinks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Legal & Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildLinkTile(
          icon: Icons.description,
          title: 'Terms of Service',
          onTap: () => _launchURL('https://scoutmena.com/terms'),
        ),
        _buildLinkTile(
          icon: Icons.privacy_tip,
          title: 'Privacy Policy',
          onTap: () => _launchURL('https://scoutmena.com/privacy'),
        ),
        _buildLinkTile(
          icon: Icons.gavel,
          title: 'Community Guidelines',
          onTap: () => _launchURL('https://scoutmena.com/community-guidelines'),
        ),
        _buildLinkTile(
          icon: Icons.shield,
          title: 'Child Protection Policy',
          onTap: () => _launchURL('https://scoutmena.com/child-protection'),
        ),
      ],
    );
  }

  Widget _buildLinkTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: AppColors.scoutPrimary),
        title: Text(title),
        trailing: const Icon(Icons.open_in_new, size: 18),
        onTap: onTap,
      ),
    );
  }

  Widget _buildContactSupport() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Need Help?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Our support team is here to help you with any questions or issues.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/contact-support');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.scoutPrimary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.support_agent),
                label: const Text('Contact Support'),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialButton(
                  Icons.language,
                  'Website',
                  () => _launchURL('https://scoutmena.com'),
                ),
                const SizedBox(width: 12),
                _buildSocialButton(
                  Icons.mail,
                  'Email',
                  () => _launchURL('mailto:support@scoutmena.com'),
                ),
                const SizedBox(width: 12),
                _buildSocialButton(
                  Icons.phone,
                  'Call',
                  () => _launchURL('tel:+1234567890'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.scoutPrimary,
          side: const BorderSide(color: AppColors.scoutPrimary),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        icon: Icon(icon, size: 18),
        label: Text(label, style: const TextStyle(fontSize: 12)),
      ),
    );
  }

  Widget _buildCredits() {
    return Column(
      children: [
        const Divider(),
        const SizedBox(height: 8),
        Text(
          '© ${DateTime.now().year} ScoutMena. All rights reserved.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Made with passion for football',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open $url')),
        );
      }
    }
  }
}
