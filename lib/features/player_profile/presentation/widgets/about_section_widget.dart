import 'package:flutter/material.dart';
import '../../domain/entities/player_profile.dart';

/// About section widget displaying player bio
class AboutSectionWidget extends StatelessWidget {
  final PlayerProfile profile;

  const AboutSectionWidget({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ABOUT',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _generateAboutText(),
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  String _generateAboutText() {
    final position = profile.positions.isNotEmpty ? profile.positions.first : 'Player';
    final club = profile.currentClub ?? 'Youth Academy';
    
    return '${profile.fullName} is a ${profile.age}-year-old $position with ${profile.yearsPlaying} years of experience. '
        'Currently playing for $club, ${profile.fullName.split(' ').first} is known for dedication and skill development. '
        'Standing at ${profile.height.toInt()}cm and weighing ${profile.weight.toInt()}kg, '
        'this ${profile.dominantFoot}-footed player brings energy and determination to the field.';
  }
}
