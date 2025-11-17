import 'package:flutter/material.dart';

/// Tutorial and help videos page
class TutorialsPage extends StatelessWidget {
  const TutorialsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutorials & Help'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            context,
            title: 'Getting Started',
            tutorials: [
              TutorialItem(
                title: 'Create Your Profile',
                description: 'Learn how to set up your player profile',
                duration: '3:45',
                thumbnail: Icons.person_add,
              ),
              TutorialItem(
                title: 'Upload Photos & Videos',
                description: 'Best practices for showcasing your skills',
                duration: '5:20',
                thumbnail: Icons.upload_file,
              ),
              TutorialItem(
                title: 'Privacy Settings',
                description: 'Control who can see your profile',
                duration: '2:30',
                thumbnail: Icons.privacy_tip,
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            context,
            title: 'For Players',
            tutorials: [
              TutorialItem(
                title: 'Updating Statistics',
                description: 'Keep your stats current and accurate',
                duration: '4:15',
                thumbnail: Icons.query_stats,
              ),
              TutorialItem(
                title: 'Profile Analytics',
                description: 'Understanding your profile performance',
                duration: '6:00',
                thumbnail: Icons.analytics,
              ),
              TutorialItem(
                title: 'Getting Discovered',
                description: 'Tips to attract scouts and coaches',
                duration: '8:30',
                thumbnail: Icons.trending_up,
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            context,
            title: 'For Scouts',
            tutorials: [
              TutorialItem(
                title: 'Advanced Search',
                description: 'Find the right players for your team',
                duration: '5:45',
                thumbnail: Icons.search,
              ),
              TutorialItem(
                title: 'Saving Searches',
                description: 'Track players that match your criteria',
                duration: '3:20',
                thumbnail: Icons.bookmark,
              ),
              TutorialItem(
                title: 'Contact Players',
                description: 'Best practices for reaching out',
                duration: '4:00',
                thumbnail: Icons.message,
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            context,
            title: 'For Parents',
            tutorials: [
              TutorialItem(
                title: 'Parental Consent',
                description: 'How to approve and manage child accounts',
                duration: '3:10',
                thumbnail: Icons.family_restroom,
              ),
              TutorialItem(
                title: 'Safety Features',
                description: 'Keeping your child safe on ScoutMena',
                duration: '5:00',
                thumbnail: Icons.shield,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<TutorialItem> tutorials,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        ...tutorials.map((tutorial) => _buildTutorialCard(context, tutorial)),
      ],
    );
  }

  Widget _buildTutorialCard(BuildContext context, TutorialItem tutorial) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            tutorial.thumbnail,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(tutorial.title),
        subtitle: Text(tutorial.description),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.play_circle_outline, size: 28),
            const SizedBox(height: 4),
            Text(
              tutorial.duration,
              style: const TextStyle(fontSize: 11),
            ),
          ],
        ),
        onTap: () {
          // TODO: Open video tutorial when implemented
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Tutorial: ${tutorial.title} - Coming soon'),
            ),
          );
        },
      ),
    );
  }
}

class TutorialItem {
  final String title;
  final String description;
  final String duration;
  final IconData thumbnail;

  TutorialItem({
    required this.title,
    required this.description,
    required this.duration,
    required this.thumbnail,
  });
}
