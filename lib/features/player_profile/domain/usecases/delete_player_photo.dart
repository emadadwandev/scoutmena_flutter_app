import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../authentication/domain/usecases/usecase.dart';
import '../repositories/player_repository.dart';

/// Use case for deleting a player photo
@lazySingleton
class DeletePlayerPhoto implements UseCase<void, DeletePlayerPhotoParams> {
  final PlayerRepository _repository;

  DeletePlayerPhoto(this._repository);

  @override
  Future<Either<Failure, void>> call(DeletePlayerPhotoParams params) async {
    return await _repository.deletePlayerPhoto(
      params.playerId,
      params.photoId,
    );
  }
}

class DeletePlayerPhotoParams extends Equatable {
  final String playerId;
  final String photoId;

  const DeletePlayerPhotoParams({
    required this.playerId,
    required this.photoId,
  });

  @override
  List<Object?> get props => [playerId, photoId];
}
