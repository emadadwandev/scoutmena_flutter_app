import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/coach_profile.dart';
import '../repositories/coach_repository.dart';

@lazySingleton
class CreateCoachProfile {
  final CoachRepository _repository;

  CreateCoachProfile(this._repository);

  Future<Either<Failure, CoachProfile>> call(
      CreateCoachProfileParams params) {
    return _repository.createCoachProfile(params.profileData);
  }
}

class CreateCoachProfileParams extends Equatable {
  final Map<String, dynamic> profileData;

  const CreateCoachProfileParams({required this.profileData});

  @override
  List<Object?> get props => [profileData];
}
