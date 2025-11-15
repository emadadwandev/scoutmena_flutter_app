import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../authentication/domain/usecases/usecase.dart';
import '../entities/player_profile.dart';
import '../repositories/player_repository.dart';

/// Use case for creating a player profile
@lazySingleton
class CreatePlayerProfile implements UseCase<PlayerProfile, CreatePlayerProfileParams> {
  final PlayerRepository _repository;

  CreatePlayerProfile(this._repository);

  @override
  Future<Either<Failure, PlayerProfile>> call(CreatePlayerProfileParams params) async {
    return await _repository.createPlayerProfile(params.profileData);
  }
}

class CreatePlayerProfileParams extends Equatable {
  final Map<String, dynamic> profileData;

  const CreatePlayerProfileParams({required this.profileData});

  @override
  List<Object?> get props => [profileData];
}
