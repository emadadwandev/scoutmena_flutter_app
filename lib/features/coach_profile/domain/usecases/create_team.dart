import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/team.dart';
import '../repositories/coach_repository.dart';

@lazySingleton
class CreateTeam {
  final CoachRepository _repository;

  CreateTeam(this._repository);

  Future<Either<Failure, Team>> call(CreateTeamParams params) {
    return _repository.createTeam(params.coachId, params.teamData);
  }
}

class CreateTeamParams extends Equatable {
  final String coachId;
  final Map<String, dynamic> teamData;

  const CreateTeamParams({
    required this.coachId,
    required this.teamData,
  });

  @override
  List<Object?> get props => [coachId, teamData];
}
