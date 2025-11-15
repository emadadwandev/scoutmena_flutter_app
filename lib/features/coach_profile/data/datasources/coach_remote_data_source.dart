import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../models/coach_profile_model.dart';
import '../models/team_model.dart';

/// Remote data source for coach profile API calls
@lazySingleton
class CoachRemoteDataSource {
  final Dio _dio;
  static const String _baseUrl = 'https://scoutmena.com/api/v1/coach';

  CoachRemoteDataSource(this._dio);

  /// Get coach profile
  Future<CoachProfileModel> getCoachProfile(String coachId) async {
    try {
      final response = await _dio.get('$_baseUrl/profile/$coachId');
      return CoachProfileModel.fromJson(response.data['data']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Create coach profile
  Future<CoachProfileModel> createCoachProfile(
      Map<String, dynamic> profileData) async {
    try {
      final response = await _dio.post('$_baseUrl/profile', data: profileData);
      return CoachProfileModel.fromJson(response.data['data']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Update coach profile
  Future<CoachProfileModel> updateCoachProfile(
      String coachId, Map<String, dynamic> profileData) async {
    try {
      final response =
          await _dio.put('$_baseUrl/profile/$coachId', data: profileData);
      return CoachProfileModel.fromJson(response.data['data']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Get coach teams
  Future<List<TeamModel>> getCoachTeams(String coachId) async {
    try {
      final response = await _dio.get('$_baseUrl/$coachId/teams');
      final List<dynamic> teamsJson = response.data['data'];
      return teamsJson.map((json) => TeamModel.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Create team
  Future<TeamModel> createTeam(
      String coachId, Map<String, dynamic> teamData) async {
    try {
      final response = await _dio.post('$_baseUrl/$coachId/teams', data: teamData);
      return TeamModel.fromJson(response.data['data']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Update team
  Future<TeamModel> updateTeam(
      String coachId, String teamId, Map<String, dynamic> teamData) async {
    try {
      final response =
          await _dio.put('$_baseUrl/$coachId/teams/$teamId', data: teamData);
      return TeamModel.fromJson(response.data['data']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Delete team
  Future<void> deleteTeam(String coachId, String teamId) async {
    try {
      await _dio.delete('$_baseUrl/$coachId/teams/$teamId');
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Add player to team
  Future<TeamModel> addPlayerToTeam(
      String coachId, String teamId, String playerId) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/$coachId/teams/$teamId/players',
        data: {'player_id': playerId},
      );
      return TeamModel.fromJson(response.data['data']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Remove player from team
  Future<TeamModel> removePlayerFromTeam(
      String coachId, String teamId, String playerId) async {
    try {
      final response = await _dio.delete(
          '$_baseUrl/$coachId/teams/$teamId/players/$playerId');
      return TeamModel.fromJson(response.data['data']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return Exception('Connection timeout');
        case DioExceptionType.badResponse:
          return Exception(
              error.response?.data['message'] ?? 'Server error occurred');
        case DioExceptionType.cancel:
          return Exception('Request cancelled');
        default:
          return Exception('Network error occurred');
      }
    }
    return Exception('Unexpected error: $error');
  }
}
