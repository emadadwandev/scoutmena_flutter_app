import 'package:equatable/equatable.dart';
import '../../domain/entities/coach_profile.dart';
import '../../domain/entities/team.dart';

abstract class CoachProfileState extends Equatable {
  const CoachProfileState();

  @override
  List<Object?> get props => [];
}

class CoachProfileInitial extends CoachProfileState {}

class CoachProfileLoading extends CoachProfileState {}

class CoachProfileLoaded extends CoachProfileState {
  final CoachProfile profile;

  const CoachProfileLoaded({required this.profile});

  @override
  List<Object?> get props => [profile];
}

class CoachProfileCreated extends CoachProfileState {
  final CoachProfile profile;

  const CoachProfileCreated({required this.profile});

  @override
  List<Object?> get props => [profile];
}

class CoachProfileUpdated extends CoachProfileState {
  final CoachProfile profile;

  const CoachProfileUpdated({required this.profile});

  @override
  List<Object?> get props => [profile];
}

class CoachTeamsLoaded extends CoachProfileState {
  final List<Team> teams;

  const CoachTeamsLoaded({required this.teams});

  @override
  List<Object?> get props => [teams];
}

class TeamCreated extends CoachProfileState {
  final Team team;
  final List<Team> allTeams;

  const TeamCreated({required this.team, required this.allTeams});

  @override
  List<Object?> get props => [team, allTeams];
}

class TeamPlayerAdded extends CoachProfileState {
  final Team updatedTeam;

  const TeamPlayerAdded({required this.updatedTeam});

  @override
  List<Object?> get props => [updatedTeam];
}

class TeamPlayerRemoved extends CoachProfileState {
  final Team updatedTeam;

  const TeamPlayerRemoved({required this.updatedTeam});

  @override
  List<Object?> get props => [updatedTeam];
}

class CoachProfileError extends CoachProfileState {
  final String message;

  const CoachProfileError({required this.message});

  @override
  List<Object?> get props => [message];
}
