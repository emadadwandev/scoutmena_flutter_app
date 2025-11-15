import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/saved_search.dart';
import '../bloc/saved_searches_bloc.dart';
import '../bloc/saved_searches_event.dart';
import '../bloc/saved_searches_state.dart';
import '../../../../core/theme/app_colors.dart';
import 'player_search_page.dart';
import 'package:intl/intl.dart';

/// Page to display and manage saved searches
class SavedSearchesPage extends StatefulWidget {
  final String scoutId;

  const SavedSearchesPage({
    super.key,
    required this.scoutId,
  });

  @override
  State<SavedSearchesPage> createState() => _SavedSearchesPageState();
}

class _SavedSearchesPageState extends State<SavedSearchesPage> {
  @override
  void initState() {
    super.initState();
    context.read<SavedSearchesBloc>().add(
          LoadSavedSearches(scoutId: widget.scoutId),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Searches'),
        backgroundColor: AppColors.scoutPrimary,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<SavedSearchesBloc, SavedSearchesState>(
        listener: (context, state) {
          if (state is SavedSearchesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is SavedSearchDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Search deleted successfully')),
            );
          } else if (state is SavedSearchExecuted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Found ${state.results.totalResults} players'),
                backgroundColor: Colors.green,
              ),
            );

            // Navigate to player search page
            // Note: The PlayerSearchPage creates its own PlayerSearchBloc
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PlayerSearchPage(),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is SavedSearchesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SavedSearchesError) {
            return _buildErrorState(state.message);
          }

          if (state is SavedSearchesLoaded ||
              state is SavedSearchCreated ||
              state is SavedSearchDeleted) {
            final searches = _getSearchesFromState(state);

            if (searches.isEmpty) {
              return _buildEmptyState();
            }

            return _buildSearchesList(searches);
          }

          if (state is SavedSearchExecuting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Executing search...'),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  List<SavedSearch> _getSearchesFromState(SavedSearchesState state) {
    if (state is SavedSearchesLoaded) {
      return state.searches;
    } else if (state is SavedSearchCreated) {
      return state.allSearches;
    } else if (state is SavedSearchDeleted) {
      return state.remainingSearches;
    }
    return [];
  }

  Widget _buildSearchesList(List<SavedSearch> searches) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<SavedSearchesBloc>().add(
              LoadSavedSearches(scoutId: widget.scoutId),
            );
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: searches.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return _buildSearchCard(searches[index]);
        },
      ),
    );
  }

  Widget _buildSearchCard(SavedSearch search) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _executeSearch(search),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      search.searchName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'delete') {
                        _confirmDelete(search);
                      } else if (value == 'execute') {
                        _executeSearch(search);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'execute',
                        child: Row(
                          children: [
                            Icon(Icons.play_arrow, size: 20),
                            SizedBox(width: 8),
                            Text('Execute Search'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                search.criteriaSummary,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildInfoChip(
                    icon: Icons.people,
                    label: '${search.resultCount} players',
                    color: AppColors.scoutPrimary,
                  ),
                  const SizedBox(width: 8),
                  _buildInfoChip(
                    icon: Icons.calendar_today,
                    label: 'Created ${_formatDate(search.createdAt)}',
                    color: Colors.grey,
                  ),
                ],
              ),
              if (search.lastExecutedAt != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Last executed ${_formatDate(search.lastExecutedAt!)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_border,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No Saved Searches',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Save your search criteria to quickly find players later',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.search),
              label: const Text('Start Searching'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.scoutPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Error Loading Searches',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<SavedSearchesBloc>().add(
                      LoadSavedSearches(scoutId: widget.scoutId),
                    );
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.scoutPrimary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      return DateFormat('MMM d, yyyy').format(date);
    }
  }

  void _executeSearch(SavedSearch search) {
    context.read<SavedSearchesBloc>().add(
          ExecuteSavedSearch(searchId: search.id),
        );
  }

  void _confirmDelete(SavedSearch search) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Search'),
        content: Text(
          'Are you sure you want to delete "${search.searchName}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<SavedSearchesBloc>().add(
                    DeleteSavedSearch(searchId: search.id),
                  );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
