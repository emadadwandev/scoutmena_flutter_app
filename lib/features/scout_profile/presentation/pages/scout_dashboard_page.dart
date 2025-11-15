import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/scout_profile_bloc.dart';
import '../bloc/scout_profile_event.dart';
import '../bloc/scout_profile_state.dart';
import '../bloc/saved_searches_bloc.dart';
import '../bloc/saved_searches_event.dart';
import '../bloc/saved_searches_state.dart';
import '../../domain/entities/scout_profile.dart';
import '../../../../core/theme/app_colors.dart';
import 'saved_searches_page.dart';
import 'player_search_page.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import '../../../settings/presentation/pages/notification_settings_page.dart';

/// Scout dashboard - main hub for scout activities
class ScoutDashboardPage extends StatefulWidget {
  final String scoutId;

  const ScoutDashboardPage({
    super.key,
    required this.scoutId,
  });

  @override
  State<ScoutDashboardPage> createState() => _ScoutDashboardPageState();
}

class _ScoutDashboardPageState extends State<ScoutDashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<ScoutProfileBloc>().add(
          LoadScoutProfile(scoutId: widget.scoutId),
        );
    context.read<SavedSearchesBloc>().add(
          LoadSavedSearches(scoutId: widget.scoutId),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scout Dashboard'),
        backgroundColor: AppColors.scoutPrimary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationSettingsPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshDashboard,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 24),
              _buildQuickActions(),
              const SizedBox(height: 24),
              _buildStatistics(),
              const SizedBox(height: 24),
              _buildSavedSearchesSection(),
              const SizedBox(height: 24),
              _buildRecentActivitySection(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToSearch,
        backgroundColor: AppColors.scoutPrimary,
        icon: const Icon(Icons.search),
        label: const Text('Search Players'),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return BlocBuilder<ScoutProfileBloc, ScoutProfileState>(
      builder: (context, state) {
        if (state is ScoutProfileLoaded) {
          return _buildProfileCard(state.profile);
        }

        if (state is ScoutProfileError) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Error loading profile: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        return const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }

  Widget _buildProfileCard(ScoutProfile profile) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.scoutPrimary.withValues(alpha: 0.2),
              child: Text(
                profile.organizationName[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.scoutPrimary,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.organizationName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profile.roleTitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.verified,
                        size: 16,
                        color: profile.verificationStatus == 'verified'
                            ? Colors.green
                            : Colors.orange,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        profile.verificationStatus == 'verified'
                            ? 'Verified'
                            : 'Pending Verification',
                        style: TextStyle(
                          fontSize: 12,
                          color: profile.verificationStatus == 'verified'
                              ? Colors.green
                              : Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                icon: Icons.search,
                label: 'Search Players',
                color: AppColors.scoutPrimary,
                onTap: _navigateToSearch,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                icon: Icons.bookmark,
                label: 'Saved Searches',
                color: Colors.blue,
                onTap: _navigateToSavedSearches,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                icon: Icons.people,
                label: 'Saved Players',
                color: Colors.green,
                onTap: () {
                  // TODO: Navigate to saved players
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Coming soon')),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                icon: Icons.bar_chart,
                label: 'Analytics',
                color: Colors.orange,
                onTap: () {
                  // TODO: Navigate to analytics
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Coming soon')),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatistics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Activity',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.visibility,
                label: 'Profiles Viewed',
                value: '24',
                sublabel: 'This month',
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.bookmark,
                label: 'Saved Players',
                value: '12',
                sublabel: 'Total',
                color: Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.search,
                label: 'Searches',
                value: '8',
                sublabel: 'Saved',
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.message,
                label: 'Messages',
                value: '5',
                sublabel: 'Pending',
                color: Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required String sublabel,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              sublabel,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedSearchesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Saved Searches',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: _navigateToSavedSearches,
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        BlocBuilder<SavedSearchesBloc, SavedSearchesState>(
          builder: (context, state) {
            if (state is SavedSearchesLoaded ||
                state is SavedSearchCreated ||
                state is SavedSearchDeleted) {
              final searches = state is SavedSearchesLoaded
                  ? state.searches
                  : state is SavedSearchCreated
                      ? state.allSearches
                      : (state as SavedSearchDeleted).remainingSearches;

              if (searches.isEmpty) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.bookmark_border,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No saved searches yet',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Column(
                children: searches
                    .take(3)
                    .map((search) => Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: AppColors.scoutPrimary,
                              child: Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            title: Text(search.searchName),
                            subtitle: Text(
                              '${search.resultCount} players',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            trailing:
                                const Icon(Icons.chevron_right, size: 20),
                            onTap: () => _navigateToSavedSearches(),
                          ),
                        ))
                    .toList(),
              );
            }

            if (state is SavedSearchesError) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Error loading searches',
                    style: TextStyle(color: Colors.red[700]),
                  ),
                ),
              );
            }

            return const Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecentActivitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Activity',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Icon(
                  Icons.history,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 8),
                Text(
                  'No recent activity',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your profile views and actions will appear here',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _refreshDashboard() async {
    context.read<ScoutProfileBloc>().add(
          LoadScoutProfile(scoutId: widget.scoutId),
        );
    context.read<SavedSearchesBloc>().add(
          LoadSavedSearches(scoutId: widget.scoutId),
        );
    await Future.delayed(const Duration(milliseconds: 500));
  }

  void _navigateToSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PlayerSearchPage(),
      ),
    );
  }

  void _navigateToSavedSearches() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SavedSearchesPage(scoutId: widget.scoutId),
      ),
    );
  }
}
