import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'dart:io';
import '../../../../core/error/failures.dart';
import '../../domain/entities/scout_profile.dart';
import '../../domain/entities/saved_search.dart';
import '../../domain/entities/search_results.dart';
import '../../domain/entities/search_filters.dart';
import '../../domain/repositories/scout_repository.dart';
import '../datasources/scout_remote_data_source.dart';
import '../models/search_filters_model.dart';

@LazySingleton(as: ScoutRepository)
class ScoutRepositoryImpl implements ScoutRepository {
  final ScoutRemoteDataSource _remoteDataSource;

  ScoutRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, ScoutProfile>> getScoutProfile(String scoutId) async {
    try {
      final profile = await _remoteDataSource.getScoutProfile(scoutId);
      return Right(profile);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, ScoutProfile>> createScoutProfile(
    Map<String, dynamic> profileData,
  ) async {
    try {
      final profile = await _remoteDataSource.createScoutProfile(profileData);
      return Right(profile);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, ScoutProfile>> updateScoutProfile(
    String scoutId,
    Map<String, dynamic> profileData,
  ) async {
    try {
      final profile = await _remoteDataSource.updateScoutProfile(
        scoutId,
        profileData,
      );
      return Right(profile);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, String>> uploadVerificationDocument(
    File document,
  ) async {
    try {
      final url = await _remoteDataSource.uploadVerificationDocument(document);
      return Right(url);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, SearchResults>> searchPlayers(
    SearchFilters filters,
    int page,
  ) async {
    try {
      final filtersModel = SearchFiltersModel.fromEntity(filters);
      final results = await _remoteDataSource.searchPlayers(filtersModel, page);
      return Right(results);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getSearchSuggestions(
    String query,
  ) async {
    try {
      final suggestions = await _remoteDataSource.getSearchSuggestions(query);
      return Right(suggestions);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<SavedSearch>>> getSavedSearches(
    String scoutId,
  ) async {
    try {
      final searches = await _remoteDataSource.getSavedSearches(scoutId);
      return Right(searches);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, SavedSearch>> createSavedSearch(
    String scoutId,
    Map<String, dynamic> searchData,
  ) async {
    try {
      final search = await _remoteDataSource.createSavedSearch(
        scoutId,
        searchData,
      );
      return Right(search);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSavedSearch(String searchId) async {
    try {
      await _remoteDataSource.deleteSavedSearch(searchId);
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, SearchResults>> executeSavedSearch(
    String searchId,
    int page,
  ) async {
    try {
      final results = await _remoteDataSource.executeSavedSearch(
        searchId,
        page,
      );
      return Right(results);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  Failure _handleException(dynamic exception) {
    if (exception is SocketException) {
      return const NetworkFailure(message: 'No internet connection');
    }
    return ServerFailure(message: exception.toString());
  }
}
