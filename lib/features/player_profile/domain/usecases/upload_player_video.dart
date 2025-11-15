import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../authentication/domain/usecases/usecase.dart';
import '../entities/player_video.dart';
import '../repositories/player_repository.dart';

/// Use case for uploading a player video
@lazySingleton
class UploadPlayerVideo implements UseCase<PlayerVideo, UploadPlayerVideoParams> {
  final PlayerRepository _repository;

  UploadPlayerVideo(this._repository);

  @override
  Future<Either<Failure, PlayerVideo>> call(UploadPlayerVideoParams params) async {
    return await _repository.uploadPlayerVideo(
      params.playerId,
      params.videoFile,
      title: params.title,
      description: params.description,
      videoType: params.videoType,
      thumbnailFile: params.thumbnailFile,
    );
  }
}

class UploadPlayerVideoParams extends Equatable {
  final String playerId;
  final File videoFile;
  final String title;
  final String? description;
  final String videoType;
  final File? thumbnailFile;

  const UploadPlayerVideoParams({
    required this.playerId,
    required this.videoFile,
    required this.title,
    this.description,
    this.videoType = 'highlight',
    this.thumbnailFile,
  });

  @override
  List<Object?> get props => [
        playerId,
        videoFile,
        title,
        description,
        videoType,
        thumbnailFile,
      ];
}
