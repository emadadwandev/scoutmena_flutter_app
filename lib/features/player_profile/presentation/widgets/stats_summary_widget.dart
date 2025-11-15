import 'package:flutter/material.dart';
import '../../domain/entities/player_stat.dart';
import '../../../../core/theme/app_colors.dart';

/// Statistics summary widget displaying aggregated player stats
class StatsSummaryWidget extends StatelessWidget {
  final List<PlayerStat> stats;

  const StatsSummaryWidget({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    if (stats.isEmpty) {
      return _buildEmptyState(context);
    }

    final totalStats = _calculateTotalStats();

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
                Icon(Icons.bar_chart, color: AppColors.playerPrimary),
                const SizedBox(width: 8),
                Text(
                  'Career Statistics',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Stats Grid
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                _buildStatCard(
                  context,
                  'Matches',
                  totalStats['matches'].toString(),
                  Icons.calendar_today,
                ),
                _buildStatCard(
                  context,
                  'Goals',
                  totalStats['goals'].toString(),
                  Icons.sports_soccer,
                ),
                _buildStatCard(
                  context,
                  'Assists',
                  totalStats['assists'].toString(),
                  Icons.person_add,
                ),
                _buildStatCard(
                  context,
                  'Minutes',
                  totalStats['minutes'].toString(),
                  Icons.timer,
                ),
                if (totalStats['passAccuracy'] != null)
                  _buildStatCard(
                    context,
                    'Pass %',
                    '${totalStats['passAccuracy']!.toStringAsFixed(1)}%',
                    Icons.show_chart,
                  ),
                _buildStatCard(
                  context,
                  'Yellow Cards',
                  totalStats['yellowCards'].toString(),
                  Icons.square,
                  iconColor: Colors.yellow[700],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Latest Season
            if (stats.isNotEmpty) ...[
              const Divider(),
              const SizedBox(height: 8),
              Text(
                'Latest: ${stats.first.season} - ${stats.first.competition}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    Color? iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.playerPrimary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.playerPrimary.withOpacity(0.1),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
            color: iconColor ?? AppColors.playerPrimary,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.bar_chart,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No Statistics Yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your match statistics to showcase your performance',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _calculateTotalStats() {
    int totalMatches = 0;
    int totalGoals = 0;
    int totalAssists = 0;
    int totalMinutes = 0;
    int totalYellowCards = 0;
    int totalRedCards = 0;
    double totalPassAccuracy = 0;
    int passAccuracyCount = 0;

    for (final stat in stats) {
      totalMatches += stat.matchesPlayed;
      totalGoals += stat.goals;
      totalAssists += stat.assists;
      totalMinutes += stat.minutesPlayed;
      totalYellowCards += stat.yellowCards;
      totalRedCards += stat.redCards;

      if (stat.passAccuracy != null) {
        totalPassAccuracy += stat.passAccuracy!;
        passAccuracyCount++;
      }
    }

    return {
      'matches': totalMatches,
      'goals': totalGoals,
      'assists': totalAssists,
      'minutes': totalMinutes,
      'yellowCards': totalYellowCards,
      'redCards': totalRedCards,
      'passAccuracy':
          passAccuracyCount > 0 ? totalPassAccuracy / passAccuracyCount : null,
    };
  }
}
