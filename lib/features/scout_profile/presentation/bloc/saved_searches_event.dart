import 'package:equatable/equatable.dart';
import '../../domain/entities/search_filters.dart';

abstract class SavedSearchesEvent extends Equatable {
  const SavedSearchesEvent();

  @override
  List<Object?> get props => [];
}

class LoadSavedSearches extends SavedSearchesEvent {
  final String scoutId;

  const LoadSavedSearches({required this.scoutId});

  @override
  List<Object?> get props => [scoutId];
}

class CreateSavedSearch extends SavedSearchesEvent {
  final String scoutId;
  final String searchName;
  final SearchFilters filters;

  const CreateSavedSearch({
    required this.scoutId,
    required this.searchName,
    required this.filters,
  });

  @override
  List<Object?> get props => [scoutId, searchName, filters];
}

class DeleteSavedSearch extends SavedSearchesEvent {
  final String searchId;

  const DeleteSavedSearch({required this.searchId});

  @override
  List<Object?> get props => [searchId];
}

class ExecuteSavedSearch extends SavedSearchesEvent {
  final String searchId;
  final int page;

  const ExecuteSavedSearch({required this.searchId, this.page = 1});

  @override
  List<Object?> get props => [searchId, page];
}
