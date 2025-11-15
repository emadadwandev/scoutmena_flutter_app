import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/team.dart';
import '../../domain/usecases/get_coach_profile.dart';
import '../../domain/usecases/create_coach_profile.dart' as create_usecase;
import '../../domain/usecases/update_coach_profile.dart' as update_usecase;
import '../../domain/usecases/get_coach_teams.dart';
import '../../domain/usecases/create_team.dart' as create_team_usecase;
import '../../domain/usecases/manage_team_players.dart' as manage_usecase;
import '../../domain/usecases/manage_team_players.dart' show ManageTeamPlayerParams;
import 'coach_profile_event.dart';
import 'coach_profile_state.dart';

@injectable
class CoachProfileBloc extends Bloc<CoachProfileEvent, CoachProfileState> {
  final GetCoachProfile _getCoachProfile;
  final create_usecase.CreateCoachProfile _createCoachProfile;
  final update_usecase.UpdateCoachProfile _updateCoachProfile;
  final GetCoachTeams _getCoachTeams;
  final create_team_usecase.CreateTeam _createTeam;
  final manage_usecase.AddPlayerToTeam _addPlayerToTeam;
  final manage_usecase.RemovePlayerFromTeam _removePlayerFromTeam;

  List<Team> _cachedTeams = [];

  CoachProfileBloc(
    this._getCoachProfile,
    this._createCoachProfile,
    this._updateCoachProfile,
    this._getCoachTeams,
    this._createTeam,
    this._addPlayerToTeam,
    this._removePlayerFromTeam,
  ) : super(CoachProfileInitial()) {
    on<LoadCoachProfile>(_onLoadCoachProfile);
    on<CreateCoachProfile>(_onCreateCoachProfile);
    on<UpdateCoachProfile>(_onUpdateCoachProfile);
    on<LoadCoachTeams>(_onLoadCoachTeams);
    on<CreateTeam>(_onCreateTeam);
    on<AddPlayerToTeam>(_onAddPlayerToTeam);
    on<RemovePlayerFromTeam>(_onRemovePlayerFromTeam);
  }

  Future<void> _onLoadCoachProfile(
    LoadCoachProfile event,
    Emitter<CoachProfileState> emit,
  ) async {
    emit(CoachProfileLoading());

    final result = await _getCoachProfile(
      GetCoachProfileParams(coachId: event.coachId),
    );

    result.fold(
      (failure) => emit(CoachProfileError(message: failure.message)),
      (profile) => emit(CoachProfileLoaded(profile: profile)),
    );
  }

  Future<void> _onCreateCoachProfile(
    CreateCoachProfile event,
    Emitter<CoachProfileState> emit,
  ) async {
    emit(CoachProfileLoading());

    final result = await _createCoachProfile(
      create_usecase.CreateCoachProfileParams(profileData: event.profileData),
    );

    result.fold(
      (failure) => emit(CoachProfileError(message: failure.message)),
      (profile) => emit(CoachProfileCreated(profile: profile)),
    );
  }

  Future<void> _onUpdateCoachProfile(
    UpdateCoachProfile event,
    Emitter<CoachProfileState> emit,
  ) async {
    emit(CoachProfileLoading());

    final result = await _updateCoachProfile(
      update_usecase.UpdateCoachProfileParams(
        coachId: event.coachId,
        profileData: event.profileData,
      ),
    );

    result.fold(
      (failure) => emit(CoachProfileError(message: failure.message)),
      (profile) => emit(CoachProfileUpdated(profile: profile)),
    );
  }

  Future<void> _onLoadCoachTeams(
    LoadCoachTeams event,
    Emitter<CoachProfileState> emit,
  ) async {
    emit(CoachProfileLoading());

    final result = await _getCoachTeams(
      GetCoachTeamsParams(coachId: event.coachId),
    );

    result.fold(
      (failure) => emit(CoachProfileError(message: failure.message)),
      (teams) {
        _cachedTeams = teams;
        emit(CoachTeamsLoaded(teams: teams));
      },
    );
  }

  Future<void> _onCreateTeam(
    CreateTeam event,
    Emitter<CoachProfileState> emit,
  ) async {
    emit(CoachProfileLoading());

    final result = await _createTeam(
      create_team_usecase.CreateTeamParams(
        coachId: event.coachId,
        teamData: event.teamData,
      ),
    );

    result.fold(
      (failure) => emit(CoachProfileError(message: failure.message)),
      (team) {
        _cachedTeams = [..._cachedTeams, team];
        emit(TeamCreated(team: team, allTeams: _cachedTeams));
      },
    );
  }

  Future<void> _onAddPlayerToTeam(
    AddPlayerToTeam event,
    Emitter<CoachProfileState> emit,
  ) async {
    emit(CoachProfileLoading());

    final result = await _addPlayerToTeam(
      manage_usecase.ManageTeamPlayerParams(
        coachId: event.coachId,
        teamId: event.teamId,
        playerId: event.playerId,
      ),
    );

    result.fold(
      (failure) => emit(CoachProfileError(message: failure.message)),
      (updatedTeam) {
        _cachedTeams = List<Team>.from(_cachedTeams)
            .map((t) => t.id == updatedTeam.id ? updatedTeam : t)
            .toList();
        emit(TeamPlayerAdded(updatedTeam: updatedTeam));
      },
    );
  }

  Future<void> _onRemovePlayerFromTeam(
    RemovePlayerFromTeam event,
    Emitter<CoachProfileState> emit,
  ) async {
    emit(CoachProfileLoading());

    final result = await _removePlayerFromTeam(
      manage_usecase.ManageTeamPlayerParams(
        coachId: event.coachId,
        teamId: event.teamId,
        playerId: event.playerId,
      ),
    );

    result.fold(
      (failure) => emit(CoachProfileError(message: failure.message)),
      (updatedTeam) {
        _cachedTeams = List<Team>.from(_cachedTeams)
            .map((t) => t.id == updatedTeam.id ? updatedTeam : t)
            .toList();
        emit(TeamPlayerRemoved(updatedTeam: updatedTeam));
      },
    );
  }
}
