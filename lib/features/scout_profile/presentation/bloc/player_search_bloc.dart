import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/search_players.dart' as search_usecase;
import '../../domain/entities/search_filters.dart';
import 'player_search_event.dart';
import 'player_search_state.dart';

@injectable
class PlayerSearchBloc extends Bloc<PlayerSearchEvent, PlayerSearchState> {
  final search_usecase.SearchPlayers _searchPlayers;

  PlayerSearchBloc(this._searchPlayers) : super(PlayerSearchInitial()) {
    on<SearchPlayers>(_onSearchPlayers);
    on<LoadMoreSearchResults>(_onLoadMoreSearchResults);
    on<UpdateSearchFilters>(_onUpdateSearchFilters);
    on<ClearSearchFilters>(_onClearSearchFilters);
    on<ClearSearchResults>(_onClearSearchResults);
  }

  Future<void> _onSearchPlayers(
    SearchPlayers event,
    Emitter<PlayerSearchState> emit,
  ) async {
    emit(PlayerSearching());

    final result = await _searchPlayers(
      search_usecase.SearchPlayersParams(filters: event.filters, page: event.page),
    );

    result.fold(
      (failure) => emit(PlayerSearchError(message: failure.message)),
      (searchResults) {
        if (searchResults.players.isEmpty) {
          emit(PlayerSearchEmpty(currentFilters: event.filters));
        } else {
          emit(PlayerSearchLoaded(
            results: searchResults,
            currentFilters: event.filters,
          ));
        }
      },
    );
  }

  Future<void> _onLoadMoreSearchResults(
    LoadMoreSearchResults event,
    Emitter<PlayerSearchState> emit,
  ) async {
    // Get current players from state
    final currentState = state;
    if (currentState is! PlayerSearchLoaded &&
        currentState is! PlayerSearchMoreLoaded) {
      return;
    }

    final currentPlayers = currentState is PlayerSearchLoaded
        ? currentState.results.players
        : (currentState as PlayerSearchMoreLoaded).results.players;

    emit(PlayerSearchLoadingMore(
      currentPlayers: currentPlayers,
      currentFilters: event.filters,
    ));

    final result = await _searchPlayers(
      search_usecase.SearchPlayersParams(filters: event.filters, page: event.page),
    );

    result.fold(
      (failure) => emit(PlayerSearchError(message: failure.message)),
      (searchResults) {
        emit(PlayerSearchMoreLoaded(
          results: searchResults,
          currentFilters: event.filters,
        ));
      },
    );
  }

  Future<void> _onUpdateSearchFilters(
    UpdateSearchFilters event,
    Emitter<PlayerSearchState> emit,
  ) async {
    emit(PlayerSearchFiltersUpdated(filters: event.filters));
  }

  Future<void> _onClearSearchFilters(
    ClearSearchFilters event,
    Emitter<PlayerSearchState> emit,
  ) async {
    emit(PlayerSearchFiltersUpdated(filters: const SearchFilters()));
  }

  Future<void> _onClearSearchResults(
    ClearSearchResults event,
    Emitter<PlayerSearchState> emit,
  ) async {
    emit(PlayerSearchInitial());
  }
}
