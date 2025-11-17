import 'package:flutter/material.dart';
import '../../domain/entities/player_profile.dart';

/// Skills & Attributes section with progress bars
class SkillsAttributesWidget extends StatelessWidget {
  final PlayerProfile profile;

  const SkillsAttributesWidget({
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
            'SKILLS & ATTRIBUTES',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 20),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Technical Skills
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.sports_soccer, color: Colors.blue, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Technical Skills',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSkillBar('Passing', 8, Colors.blue),
                    _buildSkillBar('Ball Control', 0, Colors.blue[300]!),
                    _buildSkillBar('Dribbling', 7, Colors.blue),
                    _buildSkillBar('Stamina', 0, Colors.blue[300]!),
                    _buildSkillBar('Tactical Awareness', 8, Colors.blue),
                  ],
                ),
              ),

              const SizedBox(width: 24),

              // Physical Attributes
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.fitness_center, color: Colors.blue, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Physical Attributes',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSkillBar('Speed', 8, Colors.blue),
                    _buildSkillBar('Strength', 0, Colors.blue[300]!),
                    _buildSkillBar('Agility', 9, Colors.blue),
                    _buildSkillBar('Game Reading', 0, Colors.blue[300]!),
                    _buildSkillBar('Off-ball Movement', 7, Colors.blue),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkillBar(String label, int rating, Color color) {
    final hasRating = rating > 0;
    final displayRating = hasRating ? rating : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            hasRating ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                    if (displayRating != null)
                      Text(
                        displayRating.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: displayRating != null ? displayRating / 10 : 0,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
