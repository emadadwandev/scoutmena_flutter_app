import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/get_saved_searches.dart';
import '../../domain/usecases/save_search.dart';
import '../../domain/usecases/delete_saved_search.dart' as delete_usecase;
import '../../domain/usecases/execute_saved_search.dart' as execute_usecase;
import '../../domain/entities/saved_search.dart';
import 'saved_searches_event.dart';
import 'saved_searches_state.dart';

@injectable
class SavedSearchesBloc extends Bloc<SavedSearchesEvent, SavedSearchesState> {
  final GetSavedSearches _getSavedSearches;
  final SaveSearch _saveSearch;
  final delete_usecase.DeleteSavedSearch _deleteSavedSearch;
  final execute_usecase.ExecuteSavedSearch _executeSavedSearch;

  List<SavedSearch> _cachedSearches = [];

  SavedSearchesBloc(
    this._getSavedSearches,
    this._saveSearch,
    this._deleteSavedSearch,
    this._executeSavedSearch,
  ) : super(SavedSearchesInitial()) {
    on<LoadSavedSearches>(_onLoadSavedSearches);
    on<CreateSavedSearch>(_onCreateSavedSearch);
    on<DeleteSavedSearch>(_onDeleteSavedSearch);
    on<ExecuteSavedSearch>(_onExecuteSavedSearch);
  }

  Future<void> _onLoadSavedSearches(
    LoadSavedSearches event,
    Emitter<SavedSearchesState> emit,
  ) async {
    emit(SavedSearchesLoading());

    final result = await _getSavedSearches(
      GetSavedSearchesParams(scoutId: event.scoutId),
    );

    result.fold(
      (failure) => emit(SavedSearchesError(message: failure.message)),
      (searches) {
        _cachedSearches = searches;
        emit(SavedSearchesLoaded(searches: searches));
      },
    );
  }

  Future<void> _onCreateSavedSearch(
    CreateSavedSearch event,
    Emitter<SavedSearchesState> emit,
  ) async {
    emit(SavedSearchesLoading());

    final searchData = {
      'search_name': event.searchName,
      'filters': event.filters.toQueryParams(),
    };

    final result = await _saveSearch(
      SaveSearchParams(scoutId: event.scoutId, searchData: searchData),
    );

    result.fold(
      (failure) => emit(SavedSearchesError(message: failure.message)),
      (search) {
        _cachedSearches = [..._cachedSearches, search];
        emit(SavedSearchCreated(search: search, allSearches: _cachedSearches));
      },
    );
  }

  Future<void> _onDeleteSavedSearch(
    DeleteSavedSearch event,
    Emitter<SavedSearchesState> emit,
  ) async {
    emit(SavedSearchesLoading());

    final result = await _deleteSavedSearch(
      delete_usecase.DeleteSavedSearchParams(searchId: event.searchId),
    );

    result.fold(
      (failure) => emit(SavedSearchesError(message: failure.message)),
      (_) {
        _cachedSearches = _cachedSearches
            .where((search) => search.id != event.searchId)
            .toList();
        emit(SavedSearchDeleted(remainingSearches: _cachedSearches));
      },
    );
  }

  Future<void> _onExecuteSavedSearch(
    ExecuteSavedSearch event,
    Emitter<SavedSearchesState> emit,
  ) async {
    emit(SavedSearchExecuting());

    final result = await _executeSavedSearch(
      execute_usecase.ExecuteSavedSearchParams(searchId: event.searchId, page: event.page),
    );

    result.fold(
      (failure) => emit(SavedSearchesError(message: failure.message)),
      (results) => emit(SavedSearchExecuted(results: results)),
    );
  }
}
