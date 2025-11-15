import 'package:equatable/equatable.dart';

/// Search filters for player search
class SearchFilters extends Equatable {
  final List<String>? positions;
  final int? minAge;
  final int? maxAge;
  final List<String>? countries;
  final int? minHeight;
  final int? maxHeight;
  final String? dominantFoot; // left, right, both
  final String? currentClub;
  final List<String>? nationalities;
  final String? searchQuery;
  final String? sortBy; // recent, relevant, alphabetical
  final String? sortOrder; // asc, desc

  const SearchFilters({
    this.positions,
    this.minAge,
    this.maxAge,
    this.countries,
    this.minHeight,
    this.maxHeight,
    this.dominantFoot,
    this.currentClub,
    this.nationalities,
    this.searchQuery,
    this.sortBy,
    this.sortOrder,
  });

  /// Check if any filters are active
  bool get hasActiveFilters {
    return positions != null ||
        minAge != null ||
        maxAge != null ||
        countries != null ||
        minHeight != null ||
        maxHeight != null ||
        dominantFoot != null ||
        currentClub != null ||
        nationalities != null ||
        searchQuery != null;
  }

  /// Count active filters
  int get activeFilterCount {
    int count = 0;
    if (positions != null && positions!.isNotEmpty) count++;
    if (minAge != null || maxAge != null) count++;
    if (countries != null && countries!.isNotEmpty) count++;
    if (minHeight != null || maxHeight != null) count++;
    if (dominantFoot != null) count++;
    if (currentClub != null && currentClub!.isNotEmpty) count++;
    if (nationalities != null && nationalities!.isNotEmpty) count++;
    return count;
  }

  /// Convert to query parameters map
  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{};

    if (positions != null && positions!.isNotEmpty) {
      params['positions'] = positions!.join(',');
    }
    if (minAge != null) params['min_age'] = minAge;
    if (maxAge != null) params['max_age'] = maxAge;
    if (countries != null && countries!.isNotEmpty) {
      params['countries'] = countries!.join(',');
    }
    if (minHeight != null) params['min_height'] = minHeight;
    if (maxHeight != null) params['max_height'] = maxHeight;
    if (dominantFoot != null) params['dominant_foot'] = dominantFoot;
    if (currentClub != null && currentClub!.isNotEmpty) {
      params['current_club'] = currentClub;
    }
    if (nationalities != null && nationalities!.isNotEmpty) {
      params['nationalities'] = nationalities!.join(',');
    }
    if (searchQuery != null && searchQuery!.isNotEmpty) {
      params['query'] = searchQuery;
    }
    if (sortBy != null) params['sort_by'] = sortBy;
    if (sortOrder != null) params['sort_order'] = sortOrder;

    return params;
  }

  /// Create a copy with updated values
  SearchFilters copyWith({
    List<String>? positions,
    int? minAge,
    int? maxAge,
    List<String>? countries,
    int? minHeight,
    int? maxHeight,
    String? dominantFoot,
    String? currentClub,
    List<String>? nationalities,
    String? searchQuery,
    String? sortBy,
    String? sortOrder,
  }) {
    return SearchFilters(
      positions: positions ?? this.positions,
      minAge: minAge ?? this.minAge,
      maxAge: maxAge ?? this.maxAge,
      countries: countries ?? this.countries,
      minHeight: minHeight ?? this.minHeight,
      maxHeight: maxHeight ?? this.maxHeight,
      dominantFoot: dominantFoot ?? this.dominantFoot,
      currentClub: currentClub ?? this.currentClub,
      nationalities: nationalities ?? this.nationalities,
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  /// Clear all filters
  SearchFilters clearAll() {
    return const SearchFilters();
  }

  @override
  List<Object?> get props => [
        positions,
        minAge,
        maxAge,
        countries,
        minHeight,
        maxHeight,
        dominantFoot,
        currentClub,
        nationalities,
        searchQuery,
        sortBy,
        sortOrder,
      ];
}
