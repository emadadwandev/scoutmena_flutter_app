import 'package:equatable/equatable.dart';
import '../../domain/entities/saved_search.dart';
import '../../domain/entities/search_results.dart';

abstract class SavedSearchesState extends Equatable {
  const SavedSearchesState();

  @override
  List<Object?> get props => [];
}

class SavedSearchesInitial extends SavedSearchesState {}

class SavedSearchesLoading extends SavedSearchesState {}

class SavedSearchesLoaded extends SavedSearchesState {
  final List<SavedSearch> searches;

  const SavedSearchesLoaded({required this.searches});

  @override
  List<Object?> get props => [searches];
}

class SavedSearchCreated extends SavedSearchesState {
  final SavedSearch search;
  final List<SavedSearch> allSearches;

  const SavedSearchCreated({required this.search, required this.allSearches});

  @override
  List<Object?> get props => [search, allSearches];
}

class SavedSearchDeleted extends SavedSearchesState {
  final List<SavedSearch> remainingSearches;

  const SavedSearchDeleted({required this.remainingSearches});

  @override
  List<Object?> get props => [remainingSearches];
}

class SavedSearchExecuting extends SavedSearchesState {}

class SavedSearchExecuted extends SavedSearchesState {
  final SearchResults results;

  const SavedSearchExecuted({required this.results});

  @override
  List<Object?> get props => [results];
}

class SavedSearchesError extends SavedSearchesState {
  final String message;

  const SavedSearchesError({required this.message});

  @override
  List<Object?> get props => [message];
}
