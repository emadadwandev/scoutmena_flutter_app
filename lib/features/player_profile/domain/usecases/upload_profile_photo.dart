import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../authentication/domain/usecases/usecase.dart';
import '../repositories/player_repository.dart';

/// Use case for uploading a profile photo (main profile picture)
@lazySingleton
class UploadProfilePhoto implements UseCase<String, UploadProfilePhotoParams> {
  final PlayerRepository _repository;

  UploadProfilePhoto(this._repository);

  @override
  Future<Either<Failure, String>> call(UploadProfilePhotoParams params) async {
    return await _repository.uploadProfilePhoto(
      params.playerId,
      params.photoFile,
    );
  }
}

class UploadProfilePhotoParams extends Equatable {
  final String playerId;
  final File photoFile;

  const UploadProfilePhotoParams({
    required this.playerId,
    required this.photoFile,
  });

  @override
  List<Object?> get props => [playerId, photoFile];
}
