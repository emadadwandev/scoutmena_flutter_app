import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/player_profile.dart';
import '../entities/player_photo.dart';
import '../entities/player_video.dart';
import '../entities/player_stat.dart';

/// Repository interface for player profile operations
/// Returns Either<Failure, Success> for error handling
abstract class PlayerRepository {
  /// Get player profile
  Future<Either<Failure, PlayerProfile>> getPlayerProfile(String playerId);

  /// Create player profile
  Future<Either<Failure, PlayerProfile>> createPlayerProfile(
      Map<String, dynamic> profileData);

  /// Update player profile
  Future<Either<Failure, PlayerProfile>> updatePlayerProfile(
    String playerId,
    Map<String, dynamic> profileData,
  );

  /// Upload profile photo
  Future<Either<Failure, String>> uploadProfilePhoto(
      String playerId, File photoFile);

  /// Get player photos
  Future<Either<Failure, List<PlayerPhoto>>> getPlayerPhotos(String playerId);

  /// Upload player photo
  Future<Either<Failure, PlayerPhoto>> uploadPlayerPhoto(
    String playerId,
    File photoFile, {
    String? caption,
    bool isPrimary = false,
  });

  /// Delete player photo
  Future<Either<Failure, void>> deletePlayerPhoto(
      String playerId, String photoId);

  /// Reorder player photos
  Future<Either<Failure, void>> reorderPlayerPhotos(
      String playerId, List<Map<String, dynamic>> photoOrder);

  /// Get player videos
  Future<Either<Failure, List<PlayerVideo>>> getPlayerVideos(String playerId);

  /// Upload player video
  Future<Either<Failure, PlayerVideo>> uploadPlayerVideo(
    String playerId,
    File videoFile, {
    required String title,
    String? description,
    String videoType = 'highlight',
    File? thumbnailFile,
  });

  /// Delete player video
  Future<Either<Failure, void>> deletePlayerVideo(
      String playerId, String videoId);

  /// Reorder player videos
  Future<Either<Failure, void>> reorderPlayerVideos(
      String playerId, List<Map<String, dynamic>> videoOrder);

  /// Get player statistics
  Future<Either<Failure, List<PlayerStat>>> getPlayerStats(String playerId);

  /// Create player statistics
  Future<Either<Failure, PlayerStat>> createPlayerStat(
    String playerId,
    Map<String, dynamic> statData,
  );

  /// Update player statistics
  Future<Either<Failure, PlayerStat>> updatePlayerStat(
    String playerId,
    String statId,
    Map<String, dynamic> statData,
  );

  /// Delete player statistics
  Future<Either<Failure, void>> deletePlayerStat(
      String playerId, String statId);
}
