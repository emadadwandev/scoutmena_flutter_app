import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../authentication/domain/usecases/usecase.dart';
import '../entities/player_photo.dart';
import '../repositories/player_repository.dart';

/// Use case for uploading a player photo to gallery
@lazySingleton
class UploadPlayerPhoto implements UseCase<PlayerPhoto, UploadPlayerPhotoParams> {
  final PlayerRepository _repository;

  UploadPlayerPhoto(this._repository);

  @override
  Future<Either<Failure, PlayerPhoto>> call(UploadPlayerPhotoParams params) async {
    return await _repository.uploadPlayerPhoto(
      params.playerId,
      params.photoFile,
      caption: params.caption,
      isPrimary: params.isPrimary,
    );
  }
}

class UploadPlayerPhotoParams extends Equatable {
  final String playerId;
  final File photoFile;
  final String? caption;
  final bool isPrimary;

  const UploadPlayerPhotoParams({
    required this.playerId,
    required this.photoFile,
    this.caption,
    this.isPrimary = false,
  });

  @override
  List<Object?> get props => [playerId, photoFile, caption, isPrimary];
}
