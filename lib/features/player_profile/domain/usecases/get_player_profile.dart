import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../authentication/domain/usecases/usecase.dart';
import '../entities/player_profile.dart';
import '../repositories/player_repository.dart';

/// Use case for getting a player profile
@lazySingleton
class GetPlayerProfile implements UseCase<PlayerProfile, GetPlayerProfileParams> {
  final PlayerRepository _repository;

  GetPlayerProfile(this._repository);

  @override
  Future<Either<Failure, PlayerProfile>> call(GetPlayerProfileParams params) async {
    return await _repository.getPlayerProfile(params.playerId);
  }
}

class GetPlayerProfileParams extends Equatable {
  final String playerId;

  const GetPlayerProfileParams({required this.playerId});

  @override
  List<Object?> get props => [playerId];
}
