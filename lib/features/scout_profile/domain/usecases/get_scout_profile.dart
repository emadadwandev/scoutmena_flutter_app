import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../authentication/domain/usecases/usecase.dart';
import '../entities/scout_profile.dart';
import '../repositories/scout_repository.dart';

/// Use case for getting a scout profile
@lazySingleton
class GetScoutProfile implements UseCase<ScoutProfile, GetScoutProfileParams> {
  final ScoutRepository _repository;

  GetScoutProfile(this._repository);

  @override
  Future<Either<Failure, ScoutProfile>> call(GetScoutProfileParams params) async {
    return await _repository.getScoutProfile(params.scoutId);
  }
}

class GetScoutProfileParams extends Equatable {
  final String scoutId;

  const GetScoutProfileParams({required this.scoutId});

  @override
  List<Object?> get props => [scoutId];
}
