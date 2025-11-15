import 'package:equatable/equatable.dart';
import '../../domain/entities/search_filters.dart';

/// Base class for player search events
abstract class PlayerSearchEvent extends Equatable {
  const PlayerSearchEvent();

  @override
  List<Object?> get props => [];
}

/// Search players with filters
class SearchPlayers extends PlayerSearchEvent {
  final SearchFilters filters;
  final int page;

  const SearchPlayers({
    required this.filters,
    this.page = 1,
  });

  @override
  List<Object?> get props => [filters, page];
}

/// Load more results (pagination)
class LoadMoreSearchResults extends PlayerSearchEvent {
  final SearchFilters filters;
  final int page;

  const LoadMoreSearchResults({
    required this.filters,
    required this.page,
  });

  @override
  List<Object?> get props => [filters, page];
}

/// Update search filters
class UpdateSearchFilters extends PlayerSearchEvent {
  final SearchFilters filters;

  const UpdateSearchFilters({required this.filters});

  @override
  List<Object?> get props => [filters];
}

/// Clear search filters
class ClearSearchFilters extends PlayerSearchEvent {}

/// Clear search results
class ClearSearchResults extends PlayerSearchEvent {}
