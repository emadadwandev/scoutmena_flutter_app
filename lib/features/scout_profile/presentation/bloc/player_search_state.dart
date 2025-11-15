import 'package:equatable/equatable.dart';
import '../../domain/entities/search_results.dart';
import '../../domain/entities/search_filters.dart';
import '../../../player_profile/domain/entities/player_profile.dart';

/// Base class for player search states
abstract class PlayerSearchState extends Equatable {
  const PlayerSearchState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class PlayerSearchInitial extends PlayerSearchState {}

/// Searching state
class PlayerSearching extends PlayerSearchState {}

/// Search results loaded
class PlayerSearchLoaded extends PlayerSearchState {
  final SearchResults results;
  final SearchFilters currentFilters;

  const PlayerSearchLoaded({
    required this.results,
    required this.currentFilters,
  });

  @override
  List<Object?> get props => [results, currentFilters];
}

/// Loading more results (pagination)
class PlayerSearchLoadingMore extends PlayerSearchState {
  final List<PlayerProfile> currentPlayers;
  final SearchFilters currentFilters;

  const PlayerSearchLoadingMore({
    required this.currentPlayers,
    required this.currentFilters,
  });

  @override
  List<Object?> get props => [currentPlayers, currentFilters];
}

/// More results loaded (pagination)
class PlayerSearchMoreLoaded extends PlayerSearchState {
  final SearchResults results;
  final SearchFilters currentFilters;

  const PlayerSearchMoreLoaded({
    required this.results,
    required this.currentFilters,
  });

  @override
  List<Object?> get props => [results, currentFilters];
}

/// Filters updated
class PlayerSearchFiltersUpdated extends PlayerSearchState {
  final SearchFilters filters;

  const PlayerSearchFiltersUpdated({required this.filters});

  @override
  List<Object?> get props => [filters];
}

/// Search error
class PlayerSearchError extends PlayerSearchState {
  final String message;

  const PlayerSearchError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Empty search results
class PlayerSearchEmpty extends PlayerSearchState {
  final SearchFilters currentFilters;

  const PlayerSearchEmpty({required this.currentFilters});

  @override
  List<Object?> get props => [currentFilters];
}
