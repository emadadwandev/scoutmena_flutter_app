import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../authentication/domain/usecases/usecase.dart';
import '../repositories/player_repository.dart';

/// Use case for deleting a player video
@lazySingleton
class DeletePlayerVideo implements UseCase<void, DeletePlayerVideoParams> {
  final PlayerRepository _repository;

  DeletePlayerVideo(this._repository);

  @override
  Future<Either<Failure, void>> call(DeletePlayerVideoParams params) async {
    return await _repository.deletePlayerVideo(
      params.playerId,
      params.videoId,
    );
  }
}

class DeletePlayerVideoParams extends Equatable {
  final String playerId;
  final String videoId;

  const DeletePlayerVideoParams({
    required this.playerId,
    required this.videoId,
  });

  @override
  List<Object?> get props => [playerId, videoId];
}
