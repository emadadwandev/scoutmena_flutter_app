import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../authentication/domain/usecases/usecase.dart';
import '../entities/scout_profile.dart';
import '../repositories/scout_repository.dart';

@lazySingleton
class UpdateScoutProfile implements UseCase<ScoutProfile, UpdateScoutProfileParams> {
  final ScoutRepository _repository;

  UpdateScoutProfile(this._repository);

  @override
  Future<Either<Failure, ScoutProfile>> call(UpdateScoutProfileParams params) async {
    return await _repository.updateScoutProfile(params.scoutId, params.profileData);
  }
}

class UpdateScoutProfileParams extends Equatable {
  final String scoutId;
  final Map<String, dynamic> profileData;

  const UpdateScoutProfileParams({required this.scoutId, required this.profileData});

  @override
  List<Object?> get props => [scoutId, profileData];
}
