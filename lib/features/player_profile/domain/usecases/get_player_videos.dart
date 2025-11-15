import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../authentication/domain/usecases/usecase.dart';
import '../entities/player_video.dart';
import '../repositories/player_repository.dart';

/// Use case for getting all player videos
@lazySingleton
class GetPlayerVideos implements UseCase<List<PlayerVideo>, GetPlayerVideosParams> {
  final PlayerRepository _repository;

  GetPlayerVideos(this._repository);

  @override
  Future<Either<Failure, List<PlayerVideo>>> call(GetPlayerVideosParams params) async {
    return await _repository.getPlayerVideos(params.playerId);
  }
}

class GetPlayerVideosParams extends Equatable {
  final String playerId;

  const GetPlayerVideosParams({required this.playerId});

  @override
  List<Object?> get props => [playerId];
}
