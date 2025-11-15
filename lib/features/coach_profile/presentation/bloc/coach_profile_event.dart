import 'package:equatable/equatable.dart';

abstract class CoachProfileEvent extends Equatable {
  const CoachProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadCoachProfile extends CoachProfileEvent {
  final String coachId;

  const LoadCoachProfile({required this.coachId});

  @override
  List<Object?> get props => [coachId];
}

class CreateCoachProfile extends CoachProfileEvent {
  final Map<String, dynamic> profileData;

  const CreateCoachProfile({required this.profileData});

  @override
  List<Object?> get props => [profileData];
}

class UpdateCoachProfile extends CoachProfileEvent {
  final String coachId;
  final Map<String, dynamic> profileData;

  const UpdateCoachProfile({
    required this.coachId,
    required this.profileData,
  });

  @override
  List<Object?> get props => [coachId, profileData];
}

class LoadCoachTeams extends CoachProfileEvent {
  final String coachId;

  const LoadCoachTeams({required this.coachId});

  @override
  List<Object?> get props => [coachId];
}

class CreateTeam extends CoachProfileEvent {
  final String coachId;
  final Map<String, dynamic> teamData;

  const CreateTeam({
    required this.coachId,
    required this.teamData,
  });

  @override
  List<Object?> get props => [coachId, teamData];
}

class AddPlayerToTeam extends CoachProfileEvent {
  final String coachId;
  final String teamId;
  final String playerId;

  const AddPlayerToTeam({
    required this.coachId,
    required this.teamId,
    required this.playerId,
  });

  @override
  List<Object?> get props => [coachId, teamId, playerId];
}

class RemovePlayerFromTeam extends CoachProfileEvent {
  final String coachId;
  final String teamId;
  final String playerId;

  const RemovePlayerFromTeam({
    required this.coachId,
    required this.teamId,
    required this.playerId,
  });

  @override
  List<Object?> get props => [coachId, teamId, playerId];
}
