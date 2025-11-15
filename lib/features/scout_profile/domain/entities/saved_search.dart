import 'package:equatable/equatable.dart';
import 'search_filters.dart';

/// Saved search entity for scouts
class SavedSearch extends Equatable {
  final String id;
  final String scoutId;
  final String searchName;
  final SearchFilters filters;
  final int resultCount;
  final DateTime createdAt;
  final DateTime? lastExecutedAt;

  const SavedSearch({
    required this.id,
    required this.scoutId,
    required this.searchName,
    required this.filters,
    required this.resultCount,
    required this.createdAt,
    this.lastExecutedAt,
  });

  /// Get a summary of the search criteria
  String get criteriaSummary {
    final criteria = <String>[];

    if (filters.positions != null && filters.positions!.isNotEmpty) {
      criteria.add('${filters.positions!.length} position(s)');
    }
    if (filters.minAge != null || filters.maxAge != null) {
      if (filters.minAge != null && filters.maxAge != null) {
        criteria.add('Age ${filters.minAge}-${filters.maxAge}');
      } else if (filters.minAge != null) {
        criteria.add('Age ${filters.minAge}+');
      } else {
        criteria.add('Age under ${filters.maxAge}');
      }
    }
    if (filters.countries != null && filters.countries!.isNotEmpty) {
      criteria.add('${filters.countries!.length} country(ies)');
    }
    if (filters.minHeight != null || filters.maxHeight != null) {
      if (filters.minHeight != null && filters.maxHeight != null) {
        criteria.add('${filters.minHeight}-${filters.maxHeight}cm');
      } else if (filters.minHeight != null) {
        criteria.add('${filters.minHeight}cm+');
      } else {
        criteria.add('Under ${filters.maxHeight}cm');
      }
    }
    if (filters.dominantFoot != null) {
      criteria.add('${filters.dominantFoot} foot');
    }
    if (filters.currentClub != null && filters.currentClub!.isNotEmpty) {
      criteria.add('Club: ${filters.currentClub}');
    }

    if (criteria.isEmpty) {
      return 'No filters applied';
    }

    return criteria.join(' • ');
  }

  @override
  List<Object?> get props => [
        id,
        scoutId,
        searchName,
        filters,
        resultCount,
        createdAt,
        lastExecutedAt,
      ];
}
