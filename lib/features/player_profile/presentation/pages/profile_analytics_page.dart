import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/player_profile.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/player_profile_bloc.dart';
import '../bloc/player_profile_event.dart';
import '../bloc/player_profile_state.dart';

/// Profile analytics page showing insights and progress metrics
class ProfileAnalyticsPage extends StatefulWidget {
  final String playerId;

  const ProfileAnalyticsPage({
    super.key,
    required this.playerId,
  });

  @override
  State<ProfileAnalyticsPage> createState() => _ProfileAnalyticsPageState();
}

class _ProfileAnalyticsPageState extends State<ProfileAnalyticsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PlayerProfileBloc>()
        ..add(LoadPlayerProfile(playerId: widget.playerId))
        ..add(LoadPlayerStats(playerId: widget.playerId))
        ..add(LoadPlayerPhotos(playerId: widget.playerId))
        ..add(LoadPlayerVideos(playerId: widget.playerId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile Analytics'),
          backgroundColor: AppColors.playerPrimary,
        ),
        body: BlocBuilder<PlayerProfileBloc, PlayerProfileState>(
          builder: (context, state) {
            if (state is PlayerProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is PlayerProfileLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<PlayerProfileBloc>()
                    ..add(LoadPlayerProfile(playerId: widget.playerId))
                    ..add(LoadPlayerStats(playerId: widget.playerId))
                    ..add(LoadPlayerPhotos(playerId: widget.playerId))
                    ..add(LoadPlayerVideos(playerId: widget.playerId));
                },
                child: _buildAnalytics(state.profile),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildAnalytics(PlayerProfile profile) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Profile Completeness Card
        _buildCompletenessCard(profile),
        const SizedBox(height: 16),

        // Profile Engagement Overview
        _buildEngagementCard(),
        const SizedBox(height: 16),

        // Content Summary
        _buildContentSummaryCard(),
        const SizedBox(height: 16),

        // Performance Insights
        _buildPerformanceInsightsCard(),
        const SizedBox(height: 16),

        // Profile Tips
        _buildProfileTipsCard(profile),
      ],
    );
  }

  Widget _buildCompletenessCard(PlayerProfile profile) {
    final completeness = profile.profileCompleteness;
    final missingFields = _getMissingFields(profile);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics, color: AppColors.playerPrimary),
                const SizedBox(width: 8),
                Text(
                  'Profile Completeness',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: completeness / 100,
                        strokeWidth: 12,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getCompletenessColor(completeness),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$completeness%',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: _getCompletenessColor(completeness),
                                  ),
                            ),
                            Text(
                              'Complete',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (missingFields.isNotEmpty) ...[
              const Divider(),
              const SizedBox(height: 12),
              Text(
                'Missing Information',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              ...missingFields.map((field) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Icon(
                          Icons.circle,
                          size: 8,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            field,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEngagementCard() {
    return BlocBuilder<PlayerProfileBloc, PlayerProfileState>(
      builder: (context, state) {
        int profileViews = 0;
        int photoViews = 0;
        int videoViews = 0;

        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.visibility, color: AppColors.playerPrimary),
                    const SizedBox(width: 8),
                    Text(
                      'Engagement Overview',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildEngagementStat(
                      'Profile Views',
                      profileViews.toString(),
                      Icons.person,
                      Colors.blue,
                    ),
                    _buildEngagementStat(
                      'Photo Views',
                      photoViews.toString(),
                      Icons.photo,
                      Colors.green,
                    ),
                    _buildEngagementStat(
                      'Video Views',
                      videoViews.toString(),
                      Icons.videocam,
                      Colors.orange,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEngagementStat(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
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
    );
  }

  Widget _buildContentSummaryCard() {
    return BlocBuilder<PlayerProfileBloc, PlayerProfileState>(
      builder: (context, state) {
        // Access cached data from BLoC
        int photoCount = 0;
        int videoCount = 0;
        int statsSeasons = 0;

        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.inventory_2, color: AppColors.playerPrimary),
                    const SizedBox(width: 8),
                    Text(
                      'Content Summary',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildContentRow(
                  'Photos',
                  photoCount.toString(),
                  Icons.photo_library,
                  Colors.purple,
                ),
                const SizedBox(height: 12),
                _buildContentRow(
                  'Videos',
                  videoCount.toString(),
                  Icons.videocam,
                  Colors.red,
                ),
                const SizedBox(height: 12),
                _buildContentRow(
                  'Seasons Tracked',
                  statsSeasons.toString(),
                  Icons.bar_chart,
                  Colors.teal,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContentRow(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceInsightsCard() {
    return BlocBuilder<PlayerProfileBloc, PlayerProfileState>(
      builder: (context, state) {
        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.insights, color: AppColors.playerPrimary),
                    const SizedBox(width: 8),
                    Text(
                      'Performance Insights',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildInsightItem(
                  'Goals per Match',
                  '0.0',
                  Icons.sports_soccer,
                  Colors.green,
                  'Average goals scored per match',
                ),
                const SizedBox(height: 12),
                _buildInsightItem(
                  'Assists per Match',
                  '0.0',
                  Icons.person_add,
                  Colors.blue,
                  'Average assists per match',
                ),
                const SizedBox(height: 12),
                _buildInsightItem(
                  'Minutes Played',
                  '0',
                  Icons.timer,
                  Colors.orange,
                  'Total minutes across all seasons',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInsightItem(
    String label,
    String value,
    IconData icon,
    Color color,
    String description,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        label,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTipsCard(PlayerProfile profile) {
    final tips = _getProfileTips(profile);

    if (tips.isEmpty) {
      return Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                Icons.check_circle,
                size: 64,
                color: Colors.green[400],
              ),
              const SizedBox(height: 12),
              Text(
                'Great Job!',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your profile is looking fantastic. Keep it updated with fresh content!',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb, color: Colors.amber[700]),
                const SizedBox(width: 8),
                Text(
                  'Profile Tips',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...tips.map((tip) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.arrow_right,
                        color: AppColors.playerPrimary,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          tip,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  List<String> _getMissingFields(PlayerProfile profile) {
    final missing = <String>[];

    if (profile.email == null) missing.add('Email address');
    if (profile.phoneNumber == null) missing.add('Phone number');
    if (profile.currentClub == null) missing.add('Current club');
    if (profile.jerseyNumber == null) missing.add('Jersey number');
    if (profile.instagramHandle == null) missing.add('Instagram handle');
    if (profile.twitterHandle == null) missing.add('Twitter handle');

    return missing;
  }

  List<String> _getProfileTips(PlayerProfile profile) {
    final tips = <String>[];

    if (profile.profileCompleteness < 100) {
      tips.add('Complete your profile to increase visibility to scouts.');
    }

    // Add tips based on missing content (would check BLoC cached data)
    tips.add('Add more photos to showcase your playing style.');
    tips.add('Upload video highlights to attract scout attention.');
    tips.add('Keep your statistics up to date for accurate representation.');

    if (profile.isMinor && !profile.parentalConsentGiven) {
      tips.add('Request parental consent to unlock all features.');
    }

    return tips.take(3).toList(); // Show max 3 tips
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
