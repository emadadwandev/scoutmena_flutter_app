import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/coach_team.dart';
import '../repositories/coach_repository.dart';

@lazySingleton
class GetCoachTeams {
  final CoachRepository _repository;

  GetCoachTeams(this._repository);

  Future<Either<Failure, List<Team>>> call(GetCoachTeamsParams params) {
    return _repository.getCoachTeams(params.coachId);
  }
}

class GetCoachTeamsParams extends Equatable {
  final String coachId;

  const GetCoachTeamsParams({required this.coachId});

  @override
  List<Object?> get props => [coachId];
}
