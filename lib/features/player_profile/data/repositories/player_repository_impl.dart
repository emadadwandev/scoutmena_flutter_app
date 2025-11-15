import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/player_profile.dart';
import '../../domain/entities/player_photo.dart';
import '../../domain/entities/player_video.dart';
import '../../domain/entities/player_stat.dart';
import '../../domain/repositories/player_repository.dart';
import '../datasources/player_remote_data_source.dart';

@LazySingleton(as: PlayerRepository)
class PlayerRepositoryImpl implements PlayerRepository {
  final PlayerRemoteDataSource _remoteDataSource;

  PlayerRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, PlayerProfile>> getPlayerProfile(
      String playerId) async {
    try {
      final profile = await _remoteDataSource.getPlayerProfile(playerId);
      return Right(profile);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, PlayerProfile>> createPlayerProfile(
      Map<String, dynamic> profileData) async {
    try {
      final profile = await _remoteDataSource.createPlayerProfile(profileData);
      return Right(profile);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, PlayerProfile>> updatePlayerProfile(
    String playerId,
    Map<String, dynamic> profileData,
  ) async {
    try {
      final profile = await _remoteDataSource.updatePlayerProfile(
        playerId,
        profileData,
      );
      return Right(profile);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePhoto(
    String playerId,
    File photoFile,
  ) async {
    try {
      final photoUrl = await _remoteDataSource.uploadProfilePhoto(
        playerId,
        photoFile,
      );
      return Right(photoUrl);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<PlayerPhoto>>> getPlayerPhotos(
      String playerId) async {
    try {
      final photos = await _remoteDataSource.getPlayerPhotos(playerId);
      return Right(photos);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, PlayerPhoto>> uploadPlayerPhoto(
    String playerId,
    File photoFile, {
    String? caption,
    bool isPrimary = false,
  }) async {
    try {
      final photo = await _remoteDataSource.uploadPlayerPhoto(
        playerId,
        photoFile,
        caption: caption,
        isPrimary: isPrimary,
      );
      return Right(photo);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> deletePlayerPhoto(
    String playerId,
    String photoId,
  ) async {
    try {
      await _remoteDataSource.deletePlayerPhoto(playerId, photoId);
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> reorderPlayerPhotos(
    String playerId,
    List<Map<String, dynamic>> photoOrder,
  ) async {
    try {
      await _remoteDataSource.reorderPlayerPhotos(playerId, photoOrder);
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<PlayerVideo>>> getPlayerVideos(
      String playerId) async {
    try {
      final videos = await _remoteDataSource.getPlayerVideos(playerId);
      return Right(videos);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, PlayerVideo>> uploadPlayerVideo(
    String playerId,
    File videoFile, {
    required String title,
    String? description,
    String videoType = 'highlight',
    File? thumbnailFile,
  }) async {
    try {
      final video = await _remoteDataSource.uploadPlayerVideo(
        playerId,
        videoFile,
        title: title,
        description: description,
        videoType: videoType,
        thumbnailFile: thumbnailFile,
      );
      return Right(video);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> deletePlayerVideo(
    String playerId,
    String videoId,
  ) async {
    try {
      await _remoteDataSource.deletePlayerVideo(playerId, videoId);
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> reorderPlayerVideos(
    String playerId,
    List<Map<String, dynamic>> videoOrder,
  ) async {
    try {
      await _remoteDataSource.reorderPlayerVideos(playerId, videoOrder);
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<PlayerStat>>> getPlayerStats(
      String playerId) async {
    try {
      final stats = await _remoteDataSource.getPlayerStats(playerId);
      return Right(stats);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, PlayerStat>> createPlayerStat(
    String playerId,
    Map<String, dynamic> statData,
  ) async {
    try {
      final stat = await _remoteDataSource.createPlayerStat(
        playerId,
        statData,
      );
      return Right(stat);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, PlayerStat>> updatePlayerStat(
    String playerId,
    String statId,
    Map<String, dynamic> statData,
  ) async {
    try {
      final stat = await _remoteDataSource.updatePlayerStat(
        playerId,
        statId,
        statData,
      );
      return Right(stat);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> deletePlayerStat(
    String playerId,
    String statId,
  ) async {
    try {
      await _remoteDataSource.deletePlayerStat(playerId, statId);
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  /// Convert exceptions to appropriate Failures
  Failure _handleException(dynamic exception) {
    final exceptionString = exception.toString();

    if (exceptionString.contains('Unauthorized')) {
      return const ServerFailure(message: 'Unauthorized. Please login again.');
    } else if (exceptionString.contains('not found')) {
      return const ServerFailure(message: 'Profile not found.');
    } else if (exceptionString.contains('Validation error')) {
      return ServerFailure(
          message: exceptionString.replaceAll('Exception: ', ''));
    } else if (exceptionString.contains('Connection timeout') ||
        exceptionString.contains('Network error')) {
      return NetworkFailure(
          message: exceptionString.replaceAll('Exception: ', ''));
    }

    return const ServerFailure(
        message: 'An unexpected error occurred. Please try again.');
  }
}
