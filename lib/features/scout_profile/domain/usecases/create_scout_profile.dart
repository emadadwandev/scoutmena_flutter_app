import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../authentication/domain/usecases/usecase.dart';
import '../entities/scout_profile.dart';
import '../repositories/scout_repository.dart';

@lazySingleton
class CreateScoutProfile implements UseCase<ScoutProfile, CreateScoutProfileParams> {
  final ScoutRepository _repository;

  CreateScoutProfile(this._repository);

  @override
  Future<Either<Failure, ScoutProfile>> call(CreateScoutProfileParams params) async {
    return await _repository.createScoutProfile(params.profileData);
  }
}

class CreateScoutProfileParams extends Equatable {
  final Map<String, dynamic> profileData;

  const CreateScoutProfileParams({required this.profileData});

  @override
  List<Object?> get props => [profileData];
}
