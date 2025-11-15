import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../authentication/domain/usecases/usecase.dart';
import '../entities/player_stat.dart';
import '../repositories/player_repository.dart';

/// Use case for creating player statistics
@lazySingleton
class CreatePlayerStat implements UseCase<PlayerStat, CreatePlayerStatParams> {
  final PlayerRepository _repository;

  CreatePlayerStat(this._repository);

  @override
  Future<Either<Failure, PlayerStat>> call(CreatePlayerStatParams params) async {
    return await _repository.createPlayerStat(
      params.playerId,
      params.statData,
    );
  }
}

class CreatePlayerStatParams extends Equatable {
  final String playerId;
  final Map<String, dynamic> statData;

  const CreatePlayerStatParams({
    required this.playerId,
    required this.statData,
  });

  @override
  List<Object?> get props => [playerId, statData];
}
