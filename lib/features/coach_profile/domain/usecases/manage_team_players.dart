import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/coach_team.dart';
import '../repositories/coach_repository.dart';

@lazySingleton
class AddPlayerToTeam {
  final CoachRepository _repository;

  AddPlayerToTeam(this._repository);

  Future<Either<Failure, Team>> call(ManageTeamPlayerParams params) {
    return _repository.addPlayerToTeam(
        params.coachId, params.teamId, params.playerId);
  }
}

@lazySingleton
class RemovePlayerFromTeam {
  final CoachRepository _repository;

  RemovePlayerFromTeam(this._repository);

  Future<Either<Failure, Team>> call(ManageTeamPlayerParams params) {
    return _repository.removePlayerFromTeam(
        params.coachId, params.teamId, params.playerId);
  }
}

class ManageTeamPlayerParams extends Equatable {
  final String coachId;
  final String teamId;
  final String playerId;

  const ManageTeamPlayerParams({
    required this.coachId,
    required this.teamId,
    required this.playerId,
  });

  @override
  List<Object?> get props => [coachId, teamId, playerId];
}
