import 'package:equatable/equatable.dart';
import '../../../player_profile/domain/entities/player_profile.dart';

/// Search results entity containing players and pagination info
class SearchResults extends Equatable {
  final List<PlayerProfile> players;
  final int totalResults;
  final int currentPage;
  final int totalPages;
  final int perPage;
  final bool hasMorePages;

  const SearchResults({
    required this.players,
    required this.totalResults,
    required this.currentPage,
    required this.totalPages,
    required this.perPage,
    required this.hasMorePages,
  });

  /// Create empty search results
  factory SearchResults.empty() {
    return const SearchResults(
      players: [],
      totalResults: 0,
      currentPage: 1,
      totalPages: 0,
      perPage: 20,
      hasMorePages: false,
    );
  }

  @override
  List<Object?> get props => [
        players,
        totalResults,
        currentPage,
        totalPages,
        perPage,
        hasMorePages,
      ];
}
