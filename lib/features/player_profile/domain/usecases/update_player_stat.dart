import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../authentication/domain/usecases/usecase.dart';
import '../entities/player_stat.dart';
import '../repositories/player_repository.dart';

/// Use case for updating player statistics
@lazySingleton
class UpdatePlayerStat implements UseCase<PlayerStat, UpdatePlayerStatParams> {
  final PlayerRepository _repository;

  UpdatePlayerStat(this._repository);

  @override
  Future<Either<Failure, PlayerStat>> call(UpdatePlayerStatParams params) async {
    return await _repository.updatePlayerStat(
      params.playerId,
      params.statId,
      params.statData,
    );
  }
}

class UpdatePlayerStatParams extends Equatable {
  final String playerId;
  final String statId;
  final Map<String, dynamic> statData;

  const UpdatePlayerStatParams({
    required this.playerId,
    required this.statId,
    required this.statData,
  });

  @override
  List<Object?> get props => [playerId, statId, statData];
}
