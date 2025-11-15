import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../authentication/domain/usecases/usecase.dart';
import '../entities/player_stat.dart';
import '../repositories/player_repository.dart';

/// Use case for getting all player statistics
@lazySingleton
class GetPlayerStats implements UseCase<List<PlayerStat>, GetPlayerStatsParams> {
  final PlayerRepository _repository;

  GetPlayerStats(this._repository);

  @override
  Future<Either<Failure, List<PlayerStat>>> call(GetPlayerStatsParams params) async {
    return await _repository.getPlayerStats(params.playerId);
  }
}

class GetPlayerStatsParams extends Equatable {
  final String playerId;

  const GetPlayerStatsParams({required this.playerId});

  @override
  List<Object?> get props => [playerId];
}
