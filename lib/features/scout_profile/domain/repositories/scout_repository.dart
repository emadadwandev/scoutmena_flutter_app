import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/scout_profile.dart';
import '../entities/saved_search.dart';
import '../entities/search_results.dart';
import '../entities/search_filters.dart';
import 'dart:io';

/// Repository interface for scout profile operations
abstract class ScoutRepository {
  /// Get scout profile
  Future<Either<Failure, ScoutProfile>> getScoutProfile(String scoutId);

  /// Create scout profile
  Future<Either<Failure, ScoutProfile>> createScoutProfile(
    Map<String, dynamic> profileData,
  );

  /// Update scout profile
  Future<Either<Failure, ScoutProfile>> updateScoutProfile(
    String scoutId,
    Map<String, dynamic> profileData,
  );

  /// Upload verification documents
  Future<Either<Failure, String>> uploadVerificationDocument(File document);

  /// Search players with filters
  Future<Either<Failure, SearchResults>> searchPlayers(
    SearchFilters filters,
    int page,
  );

  /// Get search suggestions
  Future<Either<Failure, List<String>>> getSearchSuggestions(String query);

  /// Get all saved searches
  Future<Either<Failure, List<SavedSearch>>> getSavedSearches(String scoutId);

  /// Create saved search
  Future<Either<Failure, SavedSearch>> createSavedSearch(
    String scoutId,
    Map<String, dynamic> searchData,
  );

  /// Delete saved search
  Future<Either<Failure, void>> deleteSavedSearch(String searchId);

  /// Execute a saved search
  Future<Either<Failure, SearchResults>> executeSavedSearch(
    String searchId,
    int page,
  );
}
