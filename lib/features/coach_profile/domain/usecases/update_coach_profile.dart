import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/coach_profile.dart';
import '../repositories/coach_repository.dart';

@lazySingleton
class UpdateCoachProfile {
  final CoachRepository _repository;

  UpdateCoachProfile(this._repository);

  Future<Either<Failure, CoachProfile>> call(
      UpdateCoachProfileParams params) {
    return _repository.updateCoachProfile(params.coachId, params.profileData);
  }
}

class UpdateCoachProfileParams extends Equatable {
  final String coachId;
  final Map<String, dynamic> profileData;

  const UpdateCoachProfileParams({
    required this.coachId,
    required this.profileData,
  });

  @override
  List<Object?> get props => [coachId, profileData];
}
