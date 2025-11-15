import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/coach_profile_bloc.dart';
import '../bloc/coach_profile_event.dart';
import '../bloc/coach_profile_state.dart';
import '../../domain/entities/coach_profile.dart';
import '../../../../core/theme/app_colors.dart';
import 'team_management_page.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import '../../../settings/presentation/pages/notification_settings_page.dart';

/// Coach dashboard - main hub for coach activities
class CoachDashboardPage extends StatefulWidget {
  final String coachId;

  const CoachDashboardPage({
    super.key,
    required this.coachId,
  });

  @override
  State<CoachDashboardPage> createState() => _CoachDashboardPageState();
}

class _CoachDashboardPageState extends State<CoachDashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<CoachProfileBloc>().add(
          LoadCoachProfile(coachId: widget.coachId),
        );
    context.read<CoachProfileBloc>().add(
          LoadCoachTeams(coachId: widget.coachId),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coach Dashboard'),
        backgroundColor: AppColors.coachPrimary,
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
              _buildRecentTeams(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToTeamManagement,
        backgroundColor: AppColors.coachPrimary,
        icon: const Icon(Icons.groups),
        label: const Text('Manage Teams'),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return BlocBuilder<CoachProfileBloc, CoachProfileState>(
      builder: (context, state) {
        if (state is CoachProfileLoaded) {
          return _buildProfileCard(state.profile);
        }

        if (state is CoachProfileError) {
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

  Widget _buildProfileCard(CoachProfile profile) {
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
              backgroundColor: AppColors.coachPrimary.withValues(alpha: 0.2),
              child: Text(
                profile.fullName[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.coachPrimary,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.fullName,
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
                  if (profile.clubName != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      profile.clubName!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        profile.isVerified
                            ? Icons.verified
                            : Icons.pending,
                        size: 16,
                        color: profile.isVerified
                            ? Colors.green
                            : Colors.orange,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        profile.isVerified
                            ? 'Verified'
                            : 'Pending Verification',
                        style: TextStyle(
                          fontSize: 12,
                          color: profile.isVerified
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
                icon: Icons.groups,
                label: 'Manage Teams',
                color: AppColors.coachPrimary,
                onTap: _navigateToTeamManagement,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                icon: Icons.search,
                label: 'Find Players',
                color: Colors.blue,
                onTap: () {
                  // TODO: Navigate to player search
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Coming soon')),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                icon: Icons.event_note,
                label: 'Training Plans',
                color: Colors.green,
                onTap: () {
                  // TODO: Navigate to training plans
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
          'Overview',
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
                icon: Icons.groups,
                label: 'Total Teams',
                value: '3',
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.people,
                label: 'Total Players',
                value: '45',
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
                icon: Icons.event,
                label: 'Sessions',
                value: '12',
                sublabel: 'This month',
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.emoji_events,
                label: 'Achievements',
                value: '8',
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
    String? sublabel,
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
            if (sublabel != null)
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

  Widget _buildRecentTeams() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'My Teams',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: _navigateToTeamManagement,
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        BlocBuilder<CoachProfileBloc, CoachProfileState>(
          builder: (context, state) {
            if (state is CoachTeamsLoaded || state is TeamCreated) {
              final teams = state is CoachTeamsLoaded
                  ? state.teams
                  : (state as TeamCreated).allTeams;

              if (teams.isEmpty) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.groups_outlined,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No teams yet',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Column(
                children: teams
                    .take(3)
                    .map((team) => Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppColors.coachPrimary,
                              child: Text(
                                team.teamName[0],
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(team.teamName),
                            subtitle: Text('${team.playerCount} players • ${team.ageGroup}'),
                            trailing: const Icon(Icons.chevron_right, size: 20),
                            onTap: () => _navigateToTeamManagement(),
                          ),
                        ))
                    .toList(),
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

  Future<void> _refreshDashboard() async {
    context.read<CoachProfileBloc>().add(
          LoadCoachProfile(coachId: widget.coachId),
        );
    context.read<CoachProfileBloc>().add(
          LoadCoachTeams(coachId: widget.coachId),
        );
    await Future.delayed(const Duration(milliseconds: 500));
  }

  void _navigateToTeamManagement() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeamManagementPage(coachId: widget.coachId),
      ),
    );
  }
}
