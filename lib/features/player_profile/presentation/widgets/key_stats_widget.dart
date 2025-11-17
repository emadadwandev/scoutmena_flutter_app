import 'package:flutter/material.dart';
import '../../domain/entities/player_profile.dart';
import '../../domain/entities/player_stat.dart';
import 'dart:math';

/// Key Stats section with Physical and Career Summary
class KeyStatsWidget extends StatelessWidget {
  final PlayerProfile profile;
  final List<PlayerStat> stats;

  const KeyStatsWidget({
    super.key,
    required this.profile,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    final totalStats = _calculateTotalStats();

    return Container(
      margin: const EdgeInsets.all(16),
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
            'KEY STATS',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 20),

          // Three Column Layout
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Physical Column
              Expanded(
                child: _buildPhysicalStats(context),
              ),

              // Technical Pie Chart
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: _buildTechnicalChart(),
              ),

              // Career Summary Column
              Expanded(
                child: _buildCareerSummary(totalStats),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPhysicalStats(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Physical',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 12),
        _buildStatRow('Height:', '${profile.height.toInt()}cm'),
        const SizedBox(height: 8),
        _buildStatRow('Weight:', '${profile.weight.toInt()}kg'),
        const SizedBox(height: 8),
        _buildStatRow('Foot', _formatFoot(profile.dominantFoot)),
      ],
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildTechnicalChart() {
    // Calculate technical percentage based on stats if available
    double technicalPercent = 0.75; // Default
    if (stats.isNotEmpty) {
      // Calculate based on goals + assists relative to matches played
      final totalStats = _calculateTotalStats();
      if (totalStats['matches']! > 0) {
        final performance = (totalStats['goals']! + totalStats['assists']!) / totalStats['matches']!;
        technicalPercent = (performance * 0.5).clamp(0.0, 1.0); // Normalize to 0-1
        if (technicalPercent < 0.3) technicalPercent = 0.5; // Minimum 50%
      }
    }
    final percentDisplay = (technicalPercent * 100).toInt();
    
    return Column(
      children: [
        Text(
          'Technical',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 85,
          height: 85,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background Circle
              Container(
                width: 85,
                height: 85,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                ),
              ),
              // Progress Arc
              CustomPaint(
                size: const Size(85, 85),
                painter: _CircularProgressPainter(
                  progress: technicalPercent,
                  progressColor: Colors.blue,
                  backgroundColor: Colors.grey[200]!,
                ),
              ),
              // Center Text
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$percentDisplay%',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '${profile.weight.toInt()}kg',
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
      ],
    );
  }

  Widget _buildCareerSummary(Map<String, int> totalStats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Career',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 12),
        _buildCareerStatBox('Goals', totalStats['goals'] ?? 0, 'Tactical'),
        const SizedBox(height: 8),
        _buildCareerStatBox('Assists', totalStats['assists'] ?? 0, 'Mental'),
      ],
    );
  }

  Widget _buildCareerStatBox(String label, int value, String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  value.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Map<String, int> _calculateTotalStats() {
    int totalGoals = 0;
    int totalAssists = 0;
    int totalMatches = 0;

    for (final stat in stats) {
      totalGoals += stat.goals;
      totalAssists += stat.assists;
      totalMatches += stat.matchesPlayed;
    }

    return {
      'goals': totalGoals,
      'assists': totalAssists,
      'matches': totalMatches,
    };
  }

  String _formatFoot(String foot) {
    if (foot.isEmpty) return 'N/A';
    return foot[0].toUpperCase() + foot.substring(1).toLowerCase();
  }
}

/// Custom painter for circular progress indicator
class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color progressColor;
  final Color backgroundColor;

  _CircularProgressPainter({
    required this.progress,
    required this.progressColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw progress arc
    final paint = Paint()
      ..color = progressColor
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 4),
      -pi / 2,
      2 * pi * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
