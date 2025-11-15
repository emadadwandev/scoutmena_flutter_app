import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/team.dart';
import '../bloc/coach_profile_bloc.dart';
import '../bloc/coach_profile_event.dart';
import '../bloc/coach_profile_state.dart';
import '../../../../core/theme/app_colors.dart';
import 'team_detail_page.dart';

/// Team management page for coaches
class TeamManagementPage extends StatefulWidget {
  final String coachId;

  const TeamManagementPage({
    super.key,
    required this.coachId,
  });

  @override
  State<TeamManagementPage> createState() => _TeamManagementPageState();
}

class _TeamManagementPageState extends State<TeamManagementPage> {
  @override
  void initState() {
    super.initState();
    context.read<CoachProfileBloc>().add(
          LoadCoachTeams(coachId: widget.coachId),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Teams'),
        backgroundColor: AppColors.coachPrimary,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<CoachProfileBloc, CoachProfileState>(
        listener: (context, state) {
          if (state is CoachProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is TeamCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Team created successfully')),
            );
          }
        },
        builder: (context, state) {
          if (state is CoachProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CoachTeamsLoaded ||
              state is TeamCreated ||
              state is TeamPlayerAdded ||
              state is TeamPlayerRemoved) {
            final teams = _getTeamsFromState(state);

            if (teams.isEmpty) {
              return _buildEmptyState();
            }

            return _buildTeamsList(teams);
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateTeamDialog,
        backgroundColor: AppColors.coachPrimary,
        icon: const Icon(Icons.add),
        label: const Text('Create Team'),
      ),
    );
  }

  List<Team> _getTeamsFromState(CoachProfileState state) {
    if (state is CoachTeamsLoaded) {
      return state.teams;
    } else if (state is TeamCreated) {
      return state.allTeams;
    }
    return [];
  }

  Widget _buildTeamsList(List<Team> teams) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<CoachProfileBloc>().add(
              LoadCoachTeams(coachId: widget.coachId),
            );
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: teams.length,
        itemBuilder: (context, index) {
          return _buildTeamCard(teams[index]);
        },
      ),
    );
  }

  Widget _buildTeamCard(Team team) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                        team.teamName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (team.clubName != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          team.clubName!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.coachPrimary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    team.ageGroup,
                    style: const TextStyle(
                      color: AppColors.coachPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.people, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${team.playerCount} players',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(width: 16),
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  'Season ${team.season}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TeamDetailPage(
                          team: team,
                          coachId: widget.coachId,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.visibility, size: 18),
                  label: const Text('View'),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TeamDetailPage(
                          team: team,
                          coachId: widget.coachId,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.person_add, size: 18),
                  label: const Text('Add Players'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.groups,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No Teams Yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first team to start managing players',
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

  void _showCreateTeamDialog() {
    final teamNameController = TextEditingController();
    final clubNameController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    String ageGroup = 'U15';
    String season = '2024/2025';

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Create New Team'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: teamNameController,
                  decoration: const InputDecoration(
                    labelText: 'Team Name *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: clubNameController,
                  decoration: const InputDecoration(
                    labelText: 'Club Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: ageGroup,
                  decoration: const InputDecoration(
                    labelText: 'Age Group',
                    border: OutlineInputBorder(),
                  ),
                  items: ['U12', 'U15', 'U18', 'U21', 'Senior']
                      .map((age) =>
                          DropdownMenuItem(value: age, child: Text(age)))
                      .toList(),
                  onChanged: (value) => ageGroup = value!,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: season,
                  decoration: const InputDecoration(
                    labelText: 'Season',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => season = value,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                final teamData = {
                  'team_name': teamNameController.text,
                  'club_name': clubNameController.text.isEmpty
                      ? null
                      : clubNameController.text,
                  'age_group': ageGroup,
                  'season': season,
                };

                context.read<CoachProfileBloc>().add(
                      CreateTeam(
                        coachId: widget.coachId,
                        teamData: teamData,
                      ),
                    );
                Navigator.pop(dialogContext);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.coachPrimary,
            ),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
