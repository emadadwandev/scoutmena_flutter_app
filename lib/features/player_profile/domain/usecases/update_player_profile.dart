import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../authentication/domain/usecases/usecase.dart';
import '../entities/player_profile.dart';
import '../repositories/player_repository.dart';

/// Use case for updating a player profile
@lazySingleton
class UpdatePlayerProfile implements UseCase<PlayerProfile, UpdatePlayerProfileParams> {
  final PlayerRepository _repository;

  UpdatePlayerProfile(this._repository);

  @override
  Future<Either<Failure, PlayerProfile>> call(UpdatePlayerProfileParams params) async {
    return await _repository.updatePlayerProfile(
      params.playerId,
      params.profileData,
    );
  }
}

class UpdatePlayerProfileParams extends Equatable {
  final String playerId;
  final Map<String, dynamic> profileData;

  const UpdatePlayerProfileParams({
    required this.playerId,
    required this.profileData,
  });

  @override
  List<Object?> get props => [playerId, profileData];
}
