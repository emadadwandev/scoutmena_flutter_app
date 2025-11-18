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
      // Transform current API response to match Flutter model structure
      final adapted = _adaptApiResponseToModel(response.data['data']);
      print('DEBUG: Adapted profile data: $adapted');
      final model = PlayerProfileModel.fromJson(adapted);
      print('DEBUG: Profile model created successfully');
      return model;
    } catch (e, stackTrace) {
      print('ERROR in getPlayerProfile: $e');
      print('Stack trace: $stackTrace');
      throw _handleError(e);
    }
  }

  /// Adapt current API response structure to Flutter model structure
  Map<String, dynamic> _adaptApiResponseToModel(Map<String, dynamic> apiData) {
    // Extract nested data
    final location = apiData['location'] as Map<String, dynamic>?;
    final physical = apiData['physical'] as Map<String, dynamic>?;
    final football = apiData['football'] as Map<String, dynamic>?;
    
    // Parse positions - convert primary_position to array format with abbreviations
    final primaryPos = football?['primary_position'] as String?;
    final secondaryPosData = football?['secondary_positions'];
    List<String> positions = [];
    
    if (primaryPos != null && primaryPos.isNotEmpty) {
      positions.add(_convertBackendPositionToFlutter(primaryPos));
    }
    
    // Handle secondary positions - could be string, array, or null
    if (secondaryPosData != null) {
      if (secondaryPosData is String && secondaryPosData.isNotEmpty) {
        final secondary = secondaryPosData.split(',')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .map((s) => _convertBackendPositionToFlutter(s));
        positions.addAll(secondary);
      } else if (secondaryPosData is List) {
        final secondary = secondaryPosData
            .map((s) => _convertBackendPositionToFlutter(s.toString()))
            .where((s) => s.isNotEmpty);
        positions.addAll(secondary);
      }
    }
    
    if (positions.isEmpty) {
      positions.add('ST'); // Default fallback
    }
    
    // Calculate approximate dateOfBirth from age or use career start date
    final age = apiData['age'] as int?;
    final careerStartDateStr = football?['career_start_date'] as String?;
    
    String dateOfBirth;
    if (age != null) {
      dateOfBirth = DateTime(DateTime.now().year - age, 6, 15).toIso8601String();
    } else if (careerStartDateStr != null && careerStartDateStr.isNotEmpty) {
      final careerStart = DateTime.parse(careerStartDateStr);
      // Assume started playing at age 10
      dateOfBirth = DateTime(careerStart.year - 10, 6, 15).toIso8601String();
    } else {
      dateOfBirth = DateTime(2005, 6, 15).toIso8601String();
    }
    
    // Map preferred_foot to dominantFoot
    String dominantFoot = physical?['preferred_foot'] as String? ?? 'right';
    
    // Extract social links - handle both empty strings and null
    final socialLinksRaw = apiData['social_links'];
    final socialLinks = (socialLinksRaw is Map<String, dynamic>) 
        ? socialLinksRaw 
        : <String, dynamic>{};
    
    // Extract contact info - handle both empty strings and null
    final contactRaw = apiData['contact'];
    final contact = (contactRaw is Map<String, dynamic>) 
        ? contactRaw 
        : <String, dynamic>{};
    
    // Calculate years playing from career start date or age
    int yearsPlaying = 5;
    if (careerStartDateStr != null && careerStartDateStr.isNotEmpty) {
      final careerStart = DateTime.parse(careerStartDateStr);
      yearsPlaying = DateTime.now().difference(careerStart).inDays ~/ 365;
    } else if (age != null && age > 10) {
      yearsPlaying = age - 10;
    }
    
    return {
      'id': apiData['id'],
      'userId': apiData['id'], // Using profile ID as userId for now
      'fullName': apiData['full_name'] ?? apiData['name'] ?? '',
      'dateOfBirth': dateOfBirth,
      'nationality': location?['nationality'] ?? location?['country'] ?? 'Unknown',
      'height': (physical?['height_cm'] as num?)?.toDouble() ?? 175.0,
      'weight': (physical?['weight_kg'] as num?)?.toDouble() ?? 70.0,
      'dominantFoot': dominantFoot,
      'currentClub': football?['current_club'] ?? '',
      'positions': positions,
      'jerseyNumber': football?['jersey_number'],
      'yearsPlaying': yearsPlaying,
      'email': contact['email'],
      'phoneNumber': contact['phone'],
      'instagramHandle': socialLinks['instagram'],
      'twitterHandle': socialLinks['twitter'],
      'profilePhotoUrl': null, // Will be populated from photos
      'isMinor': apiData['is_minor'] ?? false,
      'parentName': null,
      'parentEmail': null,
      'parentPhone': null,
      'emergencyContact': null,
      'parentalConsentGiven': !(apiData['is_minor'] ?? false),
      'profileStatus': apiData['is_active'] == true ? 'active' : 'inactive',
      'profileCompleteness': (apiData['metrics'] as Map?)?['completion_score'] ?? 50,
      'createdAt': apiData['created_at'] ?? DateTime.now().toIso8601String(),
      'updatedAt': apiData['updated_at'] ?? DateTime.now().toIso8601String(),
    };
  }

  /// Convert backend position format to Flutter abbreviation
  String _convertBackendPositionToFlutter(String position) {
    final positionMap = {
      'goalkeeper': 'GK',
      'center_back': 'CB',
      'right_back': 'RB',
      'left_back': 'LB',
      'defensive_midfielder': 'CDM',
      'central_midfielder': 'CM',
      'attacking_midfielder': 'CAM',
      'right_winger': 'RW',
      'left_winger': 'LW',
      'striker': 'ST',
      'second_striker': 'CF',
    };
    
    return positionMap[position.toLowerCase()] ?? 'ST';
  }

  @override
  Future<PlayerProfileModel> createPlayerProfile(
      Map<String, dynamic> profileData) async {
    try {
      final response = await _dio.post(
        '/player/profile',
        data: profileData,
      );
      final adaptedData = _adaptApiResponseToModel(response.data['data']);
      return PlayerProfileModel.fromJson(adaptedData);
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
      final adaptedData = _adaptApiResponseToModel(response.data['data']);
      return PlayerProfileModel.fromJson(adaptedData);
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
      print('DEBUG: Parsing ${photosJson.length} photos');
      final photos = photosJson.map((json) => PlayerPhotoModel.fromJson(_adaptPhotoResponse(json))).toList();
      print('DEBUG: Photos parsed successfully');
      return photos;
    } catch (e, stackTrace) {
      // Return empty list if photos don't exist (404) - this is not an error
      if (e is DioException && e.response?.statusCode == 404) {
        print('DEBUG: No photos found for player $playerId, returning empty list');
        return [];
      }
      print('ERROR in getPlayerPhotos: $e');
      print('Stack trace: $stackTrace');
      throw _handleError(e);
    }
  }

  /// Adapt current API photo response to Flutter model structure
  Map<String, dynamic> _adaptPhotoResponse(Map<String, dynamic> apiData) {
    final urls = apiData['urls'] as Map<String, dynamic>?;
    return {
      'id': apiData['id'],
      'playerId': apiData['player_profile_id'] ?? apiData['player_id'] ?? 'current',
      'photoUrl': urls?['original'] ?? '',
      'thumbnailUrl': urls?['thumb'] ?? '',
      'caption': apiData['caption'] ?? '',
      'isPrimary': apiData['is_primary'] ?? false,
      'order': apiData['display_order'] ?? 0,
      'uploadedAt': apiData['created_at'] ?? DateTime.now().toIso8601String(),
    };
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
      print('DEBUG: Parsing ${videosJson.length} videos');
      final videos = videosJson.map((json) => PlayerVideoModel.fromJson(_adaptVideoResponse(json))).toList();
      print('DEBUG: Videos parsed successfully');
      return videos;
    } catch (e, stackTrace) {
      // Return empty list if videos don't exist (404) - this is not an error
      if (e is DioException && e.response?.statusCode == 404) {
        print('DEBUG: No videos found for player $playerId, returning empty list');
        return [];
      }
      print('ERROR in getPlayerVideos: $e');
      print('Stack trace: $stackTrace');
      throw _handleError(e);
    }
  }

  /// Adapt current API video response to Flutter model structure
  Map<String, dynamic> _adaptVideoResponse(Map<String, dynamic> apiData) {
    final urls = apiData['urls'] as Map<String, dynamic>?;
    // Handle potentially empty or malformed URLs
    final playbackUrl = urls?['playback_url']?.toString() ?? urls?['original']?.toString() ?? '';
    final thumbnail = urls?['thumbnail']?.toString() ?? '';
    
    return {
      'id': apiData['id'],
      'playerId': apiData['player_profile_id'] ?? apiData['player_id'] ?? 'current',
      'videoUrl': playbackUrl.isNotEmpty ? playbackUrl : '',
      'thumbnailUrl': thumbnail.isNotEmpty ? thumbnail : '',
      'title': apiData['title'] ?? '',
      'description': apiData['description'] ?? '',
      'durationSeconds': apiData['duration'] ?? 0,
      'videoType': apiData['video_type'] ?? 'match_highlight',
      'order': 0,
      'views': apiData['view_count'] ?? 0,
      'uploadedAt': apiData['created_at'] ?? DateTime.now().toIso8601String(),
    };
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
      print('DEBUG: Parsing ${statsJson.length} stats');
      final stats = statsJson.map((json) => PlayerStatModel.fromJson(_adaptStatsResponse(json))).toList();
      print('DEBUG: Stats parsed successfully');
      return stats;
    } catch (e, stackTrace) {
      // Return empty list if stats don't exist (404) - this is not an error
      if (e is DioException && e.response?.statusCode == 404) {
        print('DEBUG: No stats found for player $playerId, returning empty list');
        return [];
      }
      print('ERROR in getPlayerStats: $e');
      print('Stack trace: $stackTrace');
      throw _handleError(e);
    }
  }

  /// Adapt current API stats response to Flutter model structure
  Map<String, dynamic> _adaptStatsResponse(Map<String, dynamic> apiData) {
    return {
      'id': apiData['id'],
      'playerId': apiData['player_profile_id'] ?? apiData['player_id'] ?? 'current',
      'season': apiData['season'] ?? 'career',
      'competition': apiData['competition'] ?? '',
      'matchesPlayed': apiData['appearances'] ?? 0,
      'minutesPlayed': apiData['minutes_played'] ?? 0,
      'goals': apiData['goals'] ?? 0,
      'assists': apiData['assists'] ?? 0,
      'yellowCards': apiData['yellow_cards'] ?? 0,
      'redCards': apiData['red_cards'] ?? 0,
      'passAccuracy': null,
      'shotsOnTarget': null,
      'totalShots': null,
      'tackles': null,
      'interceptions': null,
      'cleanSheets': null,
      'saves': null,
      'createdAt': apiData['created_at'] ?? DateTime.now().toIso8601String(),
      'updatedAt': apiData['updated_at'] ?? DateTime.now().toIso8601String(),
    };
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
