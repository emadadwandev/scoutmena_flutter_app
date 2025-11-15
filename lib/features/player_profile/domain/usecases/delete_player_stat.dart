import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../authentication/domain/usecases/usecase.dart';
import '../repositories/player_repository.dart';

/// Use case for deleting player statistics
@lazySingleton
class DeletePlayerStat implements UseCase<void, DeletePlayerStatParams> {
  final PlayerRepository _repository;

  DeletePlayerStat(this._repository);

  @override
  Future<Either<Failure, void>> call(DeletePlayerStatParams params) async {
    return await _repository.deletePlayerStat(
      params.playerId,
      params.statId,
    );
  }
}

class DeletePlayerStatParams extends Equatable {
  final String playerId;
  final String statId;

  const DeletePlayerStatParams({
    required this.playerId,
    required this.statId,
  });

  @override
  List<Object?> get props => [playerId, statId];
}
