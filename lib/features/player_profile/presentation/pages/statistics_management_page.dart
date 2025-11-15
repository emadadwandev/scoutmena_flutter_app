import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/player_stat.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/player_profile_bloc.dart';
import '../bloc/player_profile_event.dart';
import '../bloc/player_profile_state.dart';

/// Statistics management page for adding and managing player statistics
class StatisticsManagementPage extends StatefulWidget {
  final String playerId;

  const StatisticsManagementPage({
    super.key,
    required this.playerId,
  });

  @override
  State<StatisticsManagementPage> createState() =>
      _StatisticsManagementPageState();
}

class _StatisticsManagementPageState extends State<StatisticsManagementPage> {
  void _showAddStatDialog() {
    final seasonController = TextEditingController();
    final competitionController = TextEditingController();
    final matchesController = TextEditingController(text: '0');
    final goalsController = TextEditingController(text: '0');
    final assistsController = TextEditingController(text: '0');
    final minutesController = TextEditingController(text: '0');
    final yellowCardsController = TextEditingController(text: '0');
    final redCardsController = TextEditingController(text: '0');
    final passAccuracyController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add Season Statistics'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: seasonController,
                decoration: const InputDecoration(
                  labelText: 'Season *',
                  hintText: 'e.g., 2023/24',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: competitionController,
                decoration: const InputDecoration(
                  labelText: 'Competition *',
                  hintText: 'e.g., Premier League',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                'Match Statistics',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.playerPrimary,
                    ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: matchesController,
                      decoration: const InputDecoration(
                        labelText: 'Matches',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: minutesController,
                      decoration: const InputDecoration(
                        labelText: 'Minutes',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: goalsController,
                      decoration: const InputDecoration(
                        labelText: 'Goals',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: assistsController,
                      decoration: const InputDecoration(
                        labelText: 'Assists',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: yellowCardsController,
                      decoration: const InputDecoration(
                        labelText: 'Yellow Cards',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: redCardsController,
                      decoration: const InputDecoration(
                        labelText: 'Red Cards',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passAccuracyController,
                decoration: const InputDecoration(
                  labelText: 'Pass Accuracy % (Optional)',
                  hintText: 'e.g., 85.5',
                  border: OutlineInputBorder(),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (seasonController.text.trim().isEmpty ||
                  competitionController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill in season and competition'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }

              final statData = {
                'season': seasonController.text.trim(),
                'competition': competitionController.text.trim(),
                'matches_played': int.parse(matchesController.text),
                'goals': int.parse(goalsController.text),
                'assists': int.parse(assistsController.text),
                'minutes_played': int.parse(minutesController.text),
                'yellow_cards': int.parse(yellowCardsController.text),
                'red_cards': int.parse(redCardsController.text),
                if (passAccuracyController.text.isNotEmpty)
                  'pass_accuracy': double.parse(passAccuracyController.text),
              };

              Navigator.pop(dialogContext);
              if (mounted) {
                context.read<PlayerProfileBloc>().add(
                      CreatePlayerStatEntry(
                        playerId: widget.playerId,
                        statData: statData,
                      ),
                    );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditStatDialog(PlayerStat stat) {
    final seasonController = TextEditingController(text: stat.season);
    final competitionController = TextEditingController(text: stat.competition);
    final matchesController =
        TextEditingController(text: stat.matchesPlayed.toString());
    final goalsController = TextEditingController(text: stat.goals.toString());
    final assistsController =
        TextEditingController(text: stat.assists.toString());
    final minutesController =
        TextEditingController(text: stat.minutesPlayed.toString());
    final yellowCardsController =
        TextEditingController(text: stat.yellowCards.toString());
    final redCardsController =
        TextEditingController(text: stat.redCards.toString());
    final passAccuracyController = TextEditingController(
      text: stat.passAccuracy?.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Statistics'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: seasonController,
                decoration: const InputDecoration(
                  labelText: 'Season *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: competitionController,
                decoration: const InputDecoration(
                  labelText: 'Competition *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                'Match Statistics',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.playerPrimary,
                    ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: matchesController,
                      decoration: const InputDecoration(
                        labelText: 'Matches',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: minutesController,
                      decoration: const InputDecoration(
                        labelText: 'Minutes',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: goalsController,
                      decoration: const InputDecoration(
                        labelText: 'Goals',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: assistsController,
                      decoration: const InputDecoration(
                        labelText: 'Assists',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: yellowCardsController,
                      decoration: const InputDecoration(
                        labelText: 'Yellow Cards',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: redCardsController,
                      decoration: const InputDecoration(
                        labelText: 'Red Cards',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passAccuracyController,
                decoration: const InputDecoration(
                  labelText: 'Pass Accuracy % (Optional)',
                  border: OutlineInputBorder(),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (seasonController.text.trim().isEmpty ||
                  competitionController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill in season and competition'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }

              final statData = {
                'season': seasonController.text.trim(),
                'competition': competitionController.text.trim(),
                'matches_played': int.parse(matchesController.text),
                'goals': int.parse(goalsController.text),
                'assists': int.parse(assistsController.text),
                'minutes_played': int.parse(minutesController.text),
                'yellow_cards': int.parse(yellowCardsController.text),
                'red_cards': int.parse(redCardsController.text),
                if (passAccuracyController.text.isNotEmpty)
                  'pass_accuracy': double.parse(passAccuracyController.text),
              };

              Navigator.pop(dialogContext);
              if (mounted) {
                context.read<PlayerProfileBloc>().add(
                      UpdatePlayerStatEntry(
                        playerId: widget.playerId,
                        statId: stat.id,
                        statData: statData,
                      ),
                    );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(PlayerStat stat) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Statistics'),
        content: Text(
          'Are you sure you want to delete statistics for ${stat.season} - ${stat.competition}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              if (mounted) {
                context.read<PlayerProfileBloc>().add(
                      DeletePlayerStatEntry(
                        playerId: widget.playerId,
                        statId: stat.id,
                      ),
                    );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PlayerProfileBloc>()
        ..add(LoadPlayerStats(playerId: widget.playerId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Career Statistics'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _showAddStatDialog,
              tooltip: 'Add Statistics',
            ),
          ],
        ),
        body: BlocConsumer<PlayerProfileBloc, PlayerProfileState>(
          listener: (context, state) {
            if (state is PlayerStatCreated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Statistics added successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is PlayerStatUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Statistics updated successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is PlayerStatDeleted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Statistics deleted'),
                  backgroundColor: Colors.orange,
                ),
              );
            } else if (state is StatsOperationError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is PlayerProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is PlayerStatsLoaded ||
                state is PlayerStatCreated ||
                state is PlayerStatUpdated ||
                state is PlayerStatDeleted) {
              final stats = state is PlayerStatsLoaded
                  ? state.stats
                  : state is PlayerStatCreated
                      ? state.allStats
                      : state is PlayerStatUpdated
                          ? state.allStats
                          : (state as PlayerStatDeleted).remainingStats;

              if (stats.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: stats.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return _buildStatCard(stats[index]);
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _showAddStatDialog,
          icon: const Icon(Icons.add),
          label: const Text('Add Statistics'),
          backgroundColor: AppColors.playerPrimary,
        ),
      ),
    );
  }

  Widget _buildStatCard(PlayerStat stat) {
    return Card(
      elevation: 2,
      child: Padding(
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
                        stat.season,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        stat.competition,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () => _showEditStatDialog(stat),
                  tooltip: 'Edit',
                  color: AppColors.playerPrimary,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20),
                  onPressed: () => _confirmDelete(stat),
                  tooltip: 'Delete',
                  color: Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                _buildStatItem('Matches', stat.matchesPlayed.toString()),
                _buildStatItem('Goals', stat.goals.toString()),
                _buildStatItem('Assists', stat.assists.toString()),
                _buildStatItem('Minutes', stat.minutesPlayed.toString()),
                if (stat.passAccuracy != null)
                  _buildStatItem(
                    'Pass %',
                    '${stat.passAccuracy!.toStringAsFixed(1)}%',
                  ),
                _buildStatItem('Yellow', stat.yellowCards.toString()),
                _buildStatItem('Red', stat.redCards.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.playerPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bar_chart,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Statistics Yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Start tracking your career by adding season statistics',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _showAddStatDialog,
            icon: const Icon(Icons.add),
            label: const Text('Add Your First Stats'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.playerPrimary,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
