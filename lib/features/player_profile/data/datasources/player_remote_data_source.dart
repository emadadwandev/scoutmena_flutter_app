import 'dart:io';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../models/player_profile_model.dart';
import '../models/player_photo_model.dart';
import '../models/player_video_model.dart';
import '../models/player_stat_model.dart';

/// Remote data source for player profile operations
abstract class PlayerRemoteDataSource {
  /// Get player profile
  Future<PlayerProfileModel> getPlayerProfile(String playerId);

  /// Create player profile
  Future<PlayerProfileModel> createPlayerProfile(
      Map<String, dynamic> profileData);

  /// Update player profile
  Future<PlayerProfileModel> updatePlayerProfile(
    String playerId,
    Map<String, dynamic> profileData,
  );

  /// Upload profile photo
  Future<String> uploadProfilePhoto(String playerId, File photoFile);

  /// Get player photos
  Future<List<PlayerPhotoModel>> getPlayerPhotos(String playerId);

  /// Upload player photo
  Future<PlayerPhotoModel> uploadPlayerPhoto(
    String playerId,
    File photoFile, {
    String? caption,
    bool isPrimary = false,
  });

  /// Delete player photo
  Future<void> deletePlayerPhoto(String playerId, String photoId);

  /// Reorder player photos
  Future<void> reorderPlayerPhotos(
      String playerId, List<Map<String, dynamic>> photoOrder);

  /// Get player videos
  Future<List<PlayerVideoModel>> getPlayerVideos(String playerId);

  /// Upload player video
  Future<PlayerVideoModel> uploadPlayerVideo(
    String playerId,
    File videoFile, {
    required String title,
    String? description,
    String videoType = 'highlight',
    File? thumbnailFile,
  });

  /// Delete player video
  Future<void> deletePlayerVideo(String playerId, String videoId);

  /// Reorder player videos
  Future<void> reorderPlayerVideos(
      String playerId, List<Map<String, dynamic>> videoOrder);

  /// Get player statistics
  Future<List<PlayerStatModel>> getPlayerStats(String playerId);

  /// Create player statistics
  Future<PlayerStatModel> createPlayerStat(
    String playerId,
    Map<String, dynamic> statData,
  );

  /// Update player statistics
  Future<PlayerStatModel> updatePlayerStat(
    String playerId,
    String statId,
    Map<String, dynamic> statData,
  );

  /// Delete player statistics
  Future<void> deletePlayerStat(String playerId, String statId);
}

@LazySingleton(as: PlayerRemoteDataSource)
class PlayerRemoteDataSourceImpl implements PlayerRemoteDataSource {
  final Dio _dio;

  PlayerRemoteDataSourceImpl(this._dio);

  @override
  Future<PlayerProfileModel> getPlayerProfile(String playerId) async {
    try {
      final response = await _dio.get('/player/profile/$playerId');
      return PlayerProfileModel.fromJson(response.data['data']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<PlayerProfileModel> createPlayerProfile(
      Map<String, dynamic> profileData) async {
    try {
      final response = await _dio.post(
        '/player/profile',
        data: profileData,
      );
      return PlayerProfileModel.fromJson(response.data['data']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<PlayerProfileModel> updatePlayerProfile(
    String playerId,
    Map<String, dynamic> profileData,
  ) async {
    try {
      final response = await _dio.put(
        '/player/profile/$playerId',
        data: profileData,
      );
      return PlayerProfileModel.fromJson(response.data['data']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<String> uploadProfilePhoto(String playerId, File photoFile) async {
    try {
      final formData = FormData.fromMap({
        'photo': await MultipartFile.fromFile(
          photoFile.path,
          filename: photoFile.path.split('/').last,
        ),
      });

      final response = await _dio.post(
        '/player/profile/photo',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      return response.data['data']['photo_url'] as String;
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<PlayerPhotoModel>> getPlayerPhotos(String playerId) async {
    try {
      final response = await _dio.get('/player/profile/$playerId/photos');
      final List<dynamic> photosJson = response.data['data'];
      return photosJson.map((json) => PlayerPhotoModel.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<PlayerPhotoModel> uploadPlayerPhoto(
    String playerId,
    File photoFile, {
    String? caption,
    bool isPrimary = false,
  }) async {
    try {
      final formData = FormData.fromMap({
        'photo': await MultipartFile.fromFile(
          photoFile.path,
          filename: photoFile.path.split('/').last,
        ),
        if (caption != null) 'caption': caption,
        'is_primary': isPrimary,
      });

      final response = await _dio.post(
        '/player/profile/$playerId/photos',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      return PlayerPhotoModel.fromJson(response.data['data']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> deletePlayerPhoto(String playerId, String photoId) async {
    try {
      await _dio.delete('/player/profile/$playerId/photos/$photoId');
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> reorderPlayerPhotos(
      String playerId, List<Map<String, dynamic>> photoOrder) async {
    try {
      await _dio.put(
        '/player/profile/$playerId/photos/reorder',
        data: {'photos': photoOrder},
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<PlayerVideoModel>> getPlayerVideos(String playerId) async {
    try {
      final response = await _dio.get('/player/profile/$playerId/videos');
      final List<dynamic> videosJson = response.data['data'];
      return videosJson.map((json) => PlayerVideoModel.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<PlayerVideoModel> uploadPlayerVideo(
    String playerId,
    File videoFile, {
    required String title,
    String? description,
    String videoType = 'highlight',
    File? thumbnailFile,
  }) async {
    try {
      final formData = FormData.fromMap({
        'video': await MultipartFile.fromFile(
          videoFile.path,
          filename: videoFile.path.split('/').last,
        ),
        'title': title,
        if (description != null) 'description': description,
        'video_type': videoType,
        if (thumbnailFile != null)
          'thumbnail': await MultipartFile.fromFile(
            thumbnailFile.path,
            filename: thumbnailFile.path.split('/').last,
          ),
      });

      final response = await _dio.post(
        '/player/profile/$playerId/videos',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      return PlayerVideoModel.fromJson(response.data['data']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> deletePlayerVideo(String playerId, String videoId) async {
    try {
      await _dio.delete('/player/profile/$playerId/videos/$videoId');
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> reorderPlayerVideos(
      String playerId, List<Map<String, dynamic>> videoOrder) async {
    try {
      await _dio.put(
        '/player/profile/$playerId/videos/reorder',
        data: {'videos': videoOrder},
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<PlayerStatModel>> getPlayerStats(String playerId) async {
    try {
      final response = await _dio.get('/player/profile/$playerId/stats');
      final List<dynamic> statsJson = response.data['data'];
      return statsJson.map((json) => PlayerStatModel.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<PlayerStatModel> createPlayerStat(
    String playerId,
    Map<String, dynamic> statData,
  ) async {
    try {
      final response = await _dio.post(
        '/player/profile/$playerId/stats',
        data: statData,
      );
      return PlayerStatModel.fromJson(response.data['data']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<PlayerStatModel> updatePlayerStat(
    String playerId,
    String statId,
    Map<String, dynamic> statData,
  ) async {
    try {
      final response = await _dio.put(
        '/player/profile/$playerId/stats/$statId',
        data: statData,
      );
      return PlayerStatModel.fromJson(response.data['data']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> deletePlayerStat(String playerId, String statId) async {
    try {
      await _dio.delete('/player/profile/$playerId/stats/$statId');
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Handle errors and convert to appropriate exceptions
  Exception _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return Exception('Connection timeout. Please check your internet.');
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final message =
              error.response?.data['message'] ?? 'Unknown error occurred';
          if (statusCode == 401) {
            return Exception('Unauthorized. Please login again.');
          } else if (statusCode == 404) {
            return Exception('Profile not found.');
          } else if (statusCode == 422) {
            return Exception('Validation error: $message');
          }
          return Exception(message);
        case DioExceptionType.cancel:
          return Exception('Request cancelled');
        case DioExceptionType.unknown:
          return Exception('Network error. Please check your connection.');
        default:
          return Exception('An unexpected error occurred');
      }
    }
    return Exception('An unexpected error occurred: $error');
  }
}
