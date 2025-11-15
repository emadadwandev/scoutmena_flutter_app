import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/search_filters.dart';
import '../../../player_profile/domain/entities/player_profile.dart';
import '../bloc/player_search_bloc.dart';
import '../bloc/player_search_event.dart';
import '../bloc/player_search_state.dart';
import '../widgets/search_filter_sheet.dart';
import '../widgets/player_search_card.dart';

/// Player search page with advanced filters
class PlayerSearchPage extends StatefulWidget {
  const PlayerSearchPage({super.key});

  @override
  State<PlayerSearchPage> createState() => _PlayerSearchPageState();
}

class _PlayerSearchPageState extends State<PlayerSearchPage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  SearchFilters _currentFilters = const SearchFilters();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      final state = context.read<PlayerSearchBloc>().state;
      if (state is PlayerSearchLoaded && state.results.hasMorePages) {
        context.read<PlayerSearchBloc>().add(
              LoadMoreSearchResults(
                filters: _currentFilters,
                page: state.results.currentPage + 1,
              ),
            );
      }
    }
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    final updatedFilters = _currentFilters.copyWith(searchQuery: query);

    setState(() {
      _currentFilters = updatedFilters;
    });

    context.read<PlayerSearchBloc>().add(
          SearchPlayers(filters: updatedFilters),
        );
  }

  void _showFilterSheet() async {
    final result = await showModalBottomSheet<SearchFilters>(
      context: context,
      isScrollControlled: true,
      builder: (context) => SearchFilterSheet(currentFilters: _currentFilters),
    );

    if (result != null) {
      setState(() {
        _currentFilters = result;
      });
      context.read<PlayerSearchBloc>().add(SearchPlayers(filters: result));
    }
  }

  void _clearFilters() {
    setState(() {
      _currentFilters = const SearchFilters();
      _searchController.clear();
    });
    context.read<PlayerSearchBloc>().add(ClearSearchResults());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PlayerSearchBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Search Players'),
          backgroundColor: AppColors.scoutPrimary,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search by name...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {});
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _performSearch(),
                      onChanged: (value) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: 8),
                  BlocBuilder<PlayerSearchBloc, PlayerSearchState>(
                    builder: (context, state) {
                      final filterCount = _currentFilters.activeFilterCount;
                      return Badge(
                        label: Text('$filterCount'),
                        isLabelVisible: filterCount > 0,
                        child: IconButton(
                          icon: const Icon(Icons.filter_list, color: Colors.white),
                          onPressed: _showFilterSheet,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        body: BlocBuilder<PlayerSearchBloc, PlayerSearchState>(
          builder: (context, state) {
            if (state is PlayerSearchInitial) {
              return _buildInitialState();
            } else if (state is PlayerSearching) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PlayerSearchLoaded ||
                state is PlayerSearchMoreLoaded ||
                state is PlayerSearchLoadingMore) {
              final players = state is PlayerSearchLoaded
                  ? state.results.players
                  : state is PlayerSearchMoreLoaded
                      ? state.results.players
                      : (state as PlayerSearchLoadingMore).currentPlayers;

              return Column(
                children: [
                  if (_currentFilters.hasActiveFilters)
                    _buildFilterChips(),
                  Expanded(
                    child: GridView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: players.length +
                          (state is PlayerSearchLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == players.length) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return PlayerSearchCard(player: players[index]);
                      },
                    ),
                  ),
                ],
              );
            } else if (state is PlayerSearchEmpty) {
              return _buildEmptyState();
            } else if (state is PlayerSearchError) {
              return _buildErrorState(state.message);
            }

            return _buildInitialState();
          },
        ),
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Search for Players',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Use filters to find players matching your criteria',
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _showFilterSheet,
            icon: const Icon(Icons.filter_list),
            label: const Text('Apply Filters'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.scoutPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No Players Found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Try adjusting your filters or search criteria',
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _clearFilters,
            child: const Text('Clear Filters'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 80, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Error',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              message,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _performSearch,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.grey[100],
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${_currentFilters.activeFilterCount} filter(s) applied',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          TextButton(
            onPressed: _clearFilters,
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
