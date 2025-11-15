import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/coach_profile.dart';
import '../repositories/coach_repository.dart';

@lazySingleton
class GetCoachProfile {
  final CoachRepository _repository;

  GetCoachProfile(this._repository);

  Future<Either<Failure, CoachProfile>> call(GetCoachProfileParams params) {
    return _repository.getCoachProfile(params.coachId);
  }
}

class GetCoachProfileParams extends Equatable {
  final String coachId;

  const GetCoachProfileParams({required this.coachId});

  @override
  List<Object?> get props => [coachId];
}
