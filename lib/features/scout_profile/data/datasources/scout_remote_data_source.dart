import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../models/scout_profile_model.dart';
import '../models/saved_search_model.dart';
import '../models/search_results_model.dart';
import '../models/search_filters_model.dart';
import 'dart:io';

/// Remote data source for scout profile operations
abstract class ScoutRemoteDataSource {
  /// Get scout profile
  Future<ScoutProfileModel> getScoutProfile(String scoutId);

  /// Create scout profile
  Future<ScoutProfileModel> createScoutProfile(Map<String, dynamic> profileData);

  /// Update scout profile
  Future<ScoutProfileModel> updateScoutProfile(
    String scoutId,
    Map<String, dynamic> profileData,
  );

  /// Upload verification documents
  Future<String> uploadVerificationDocument(File document);

  /// Search players with filters
  Future<SearchResultsModel> searchPlayers(
    SearchFiltersModel filters,
    int page,
  );

  /// Get search suggestions based on query
  Future<List<String>> getSearchSuggestions(String query);

  /// Get all saved searches
  Future<List<SavedSearchModel>> getSavedSearches(String scoutId);

  /// Create saved search
  Future<SavedSearchModel> createSavedSearch(
    String scoutId,
    Map<String, dynamic> searchData,
  );

  /// Delete saved search
  Future<void> deleteSavedSearch(String searchId);

  /// Execute a saved search
  Future<SearchResultsModel> executeSavedSearch(
    String searchId,
    int page,
  );
}

@LazySingleton(as: ScoutRemoteDataSource)
class ScoutRemoteDataSourceImpl implements ScoutRemoteDataSource {
  final Dio _dio;

  ScoutRemoteDataSourceImpl(this._dio);

  @override
  Future<ScoutProfileModel> getScoutProfile(String scoutId) async {
    try {
      final response = await _dio.get('/scout/profile');
      return ScoutProfileModel.fromJson(response.data['data']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<ScoutProfileModel> createScoutProfile(
    Map<String, dynamic> profileData,
  ) async {
    try {
      final response = await _dio.post(
        '/scout/profile',
        data: profileData,
      );
      return ScoutProfileModel.fromJson(response.data['data']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<ScoutProfileModel> updateScoutProfile(
    String scoutId,
    Map<String, dynamic> profileData,
  ) async {
    try {
      final response = await _dio.put(
        '/scout/profile',
        data: profileData,
      );
      return ScoutProfileModel.fromJson(response.data['data']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<String> uploadVerificationDocument(File document) async {
    try {
      final formData = FormData.fromMap({
        'document': await MultipartFile.fromFile(
          document.path,
          filename: document.path.split('/').last,
        ),
      });

      final response = await _dio.post(
        '/scout/verification-document',
        data: formData,
      );

      return response.data['data']['url'];
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<SearchResultsModel> searchPlayers(
    SearchFiltersModel filters,
    int page,
  ) async {
    try {
      final queryParams = filters.toQueryParams();
      queryParams['page'] = page;

      final response = await _dio.get(
        '/scout/players/search',
        queryParameters: queryParams,
      );

      return SearchResultsModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<String>> getSearchSuggestions(String query) async {
    try {
      final response = await _dio.get(
        '/scout/search/suggestions',
        queryParameters: {'query': query},
      );

      return List<String>.from(response.data['data']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<SavedSearchModel>> getSavedSearches(String scoutId) async {
    try {
      final response = await _dio.get('/scout/saved-searches');

      return (response.data['data'] as List)
          .map((json) => SavedSearchModel.fromJson(json))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<SavedSearchModel> createSavedSearch(
    String scoutId,
    Map<String, dynamic> searchData,
  ) async {
    try {
      final response = await _dio.post(
        '/scout/saved-searches',
        data: searchData,
      );

      return SavedSearchModel.fromJson(response.data['data']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> deleteSavedSearch(String searchId) async {
    try {
      await _dio.delete('/scout/saved-searches/$searchId');
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<SearchResultsModel> executeSavedSearch(
    String searchId,
    int page,
  ) async {
    try {
      final response = await _dio.get(
        '/scout/saved-searches/$searchId/execute',
        queryParameters: {'page': page},
      );

      return SearchResultsModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(dynamic error) {
    if (error is DioException) {
      if (error.response != null) {
        final message = error.response?.data['message'] ?? 'An error occurred';
        return Exception(message);
      }
      return Exception('Network error: ${error.message}');
    }
    return Exception('An unexpected error occurred');
  }
}
