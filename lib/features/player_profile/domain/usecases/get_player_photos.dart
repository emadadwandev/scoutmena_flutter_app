import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../authentication/domain/usecases/usecase.dart';
import '../entities/player_photo.dart';
import '../repositories/player_repository.dart';

/// Use case for getting all player photos
@lazySingleton
class GetPlayerPhotos implements UseCase<List<PlayerPhoto>, GetPlayerPhotosParams> {
  final PlayerRepository _repository;

  GetPlayerPhotos(this._repository);

  @override
  Future<Either<Failure, List<PlayerPhoto>>> call(GetPlayerPhotosParams params) async {
    return await _repository.getPlayerPhotos(params.playerId);
  }
}

class GetPlayerPhotosParams extends Equatable {
  final String playerId;

  const GetPlayerPhotosParams({required this.playerId});

  @override
  List<Object?> get props => [playerId];
}
