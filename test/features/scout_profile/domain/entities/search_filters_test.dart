import 'package:flutter_test/flutter_test.dart';
import 'package:scoutmena_app/features/scout_profile/domain/entities/search_filters.dart';

void main() {
  final tFilters = SearchFilters(
    positions: ['striker', 'winger'],
    minAge: 16,
    maxAge: 23,
    countries: ['United Kingdom', 'Spain'],
    minHeight: 170,
    maxHeight: 190,
    dominantFoot: 'right',
    currentClub: 'Manchester United U23',
    nationalities: ['England', 'Spain'],
    searchQuery: 'top striker',
    sortBy: 'recent',
    sortOrder: 'desc',
  );

  group('Computed Properties', () {
    test('hasActiveFilters should return true when filters are present', () {
      expect(tFilters.hasActiveFilters, true);
    });

    test('hasActiveFilters should return false when no filters are set', () {
      const emptyFilters = SearchFilters();

      expect(emptyFilters.hasActiveFilters, false);
    });

    test('activeFilterCount should count all active filter categories', () {
      // 7 categories: positions, age, countries, height, foot, club, nationalities
      expect(tFilters.activeFilterCount, 7);
    });

    test('activeFilterCount should return 0 for empty filters', () {
      const emptyFilters = SearchFilters();

      expect(emptyFilters.activeFilterCount, 0);
    });

    test('activeFilterCount should count age range as single filter', () {
      const filtersWithAge = SearchFilters(
        minAge: 18,
        maxAge: 25,
      );

      expect(filtersWithAge.activeFilterCount, 1);
    });

    test('activeFilterCount should count height range as single filter', () {
      const filtersWithHeight = SearchFilters(
        minHeight: 170,
        maxHeight: 190,
      );

      expect(filtersWithHeight.activeFilterCount, 1);
    });

    test('activeFilterCount should ignore empty list filters', () {
      const filtersWithEmptyLists = SearchFilters(
        positions: [],
        countries: [],
        nationalities: [],
      );

      expect(filtersWithEmptyLists.activeFilterCount, 0);
    });
  });

  group('toQueryParams', () {
    test('should convert all filters to query parameters', () {
      final params = tFilters.toQueryParams();

      expect(params['positions'], 'striker,winger');
      expect(params['min_age'], 16);
      expect(params['max_age'], 23);
      expect(params['countries'], 'United Kingdom,Spain');
      expect(params['min_height'], 170);
      expect(params['max_height'], 190);
      expect(params['dominant_foot'], 'right');
      expect(params['current_club'], 'Manchester United U23');
      expect(params['nationalities'], 'England,Spain');
      expect(params['query'], 'top striker');
      expect(params['sort_by'], 'recent');
      expect(params['sort_order'], 'desc');
    });

    test('should omit null filters from query parameters', () {
      const partialFilters = SearchFilters(
        positions: ['striker'],
        minAge: 18,
      );

      final params = partialFilters.toQueryParams();

      expect(params.containsKey('positions'), true);
      expect(params.containsKey('min_age'), true);
      expect(params.containsKey('max_age'), false);
      expect(params.containsKey('countries'), false);
    });

    test('should omit empty list filters from query parameters', () {
      const filtersWithEmptyLists = SearchFilters(
        positions: [],
        minAge: 18,
      );

      final params = filtersWithEmptyLists.toQueryParams();

      expect(params.containsKey('positions'), false);
      expect(params.containsKey('min_age'), true);
    });

    test('should handle empty string filters correctly', () {
      const filtersWithEmptyStrings = SearchFilters(
        currentClub: '',
        searchQuery: '',
      );

      final params = filtersWithEmptyStrings.toQueryParams();

      expect(params.containsKey('current_club'), false);
      expect(params.containsKey('query'), false);
    });
  });

  group('Equatable', () {
    test('should have correct props for Equatable comparison', () {
      final filters1 = tFilters;
      final filters2 = SearchFilters(
        positions: ['striker', 'winger'],
        minAge: 16,
        maxAge: 23,
        countries: ['United Kingdom', 'Spain'],
        minHeight: 170,
        maxHeight: 190,
        dominantFoot: 'right',
        currentClub: 'Manchester United U23',
        nationalities: ['England', 'Spain'],
        searchQuery: 'top striker',
        sortBy: 'recent',
        sortOrder: 'desc',
      );

      expect(filters1, equals(filters2));
    });

    test('should not be equal when properties differ', () {
      final filters1 = tFilters;
      final filters2 = tFilters.copyWith(minAge: 18);

      expect(filters1, isNot(equals(filters2)));
    });
  });

  group('CopyWith', () {
    test('copyWith should create new instance with updated properties', () {
      final updatedFilters = tFilters.copyWith(
        minAge: 18,
        maxAge: 25,
        sortBy: 'alphabetical',
      );

      expect(updatedFilters.minAge, 18);
      expect(updatedFilters.maxAge, 25);
      expect(updatedFilters.sortBy, 'alphabetical');
      expect(updatedFilters.positions, tFilters.positions);
    });

    test('copyWith should preserve original values when not specified', () {
      final updatedFilters = tFilters.copyWith(minAge: 20);

      expect(updatedFilters.minAge, 20);
      expect(updatedFilters.maxAge, tFilters.maxAge);
      expect(updatedFilters.positions, tFilters.positions);
      expect(updatedFilters.countries, tFilters.countries);
    });
  });

  group('ClearAll', () {
    test('clearAll should return empty filters', () {
      final clearedFilters = tFilters.clearAll();

      expect(clearedFilters.hasActiveFilters, false);
      expect(clearedFilters.activeFilterCount, 0);
      expect(clearedFilters.positions, null);
      expect(clearedFilters.minAge, null);
      expect(clearedFilters.countries, null);
    });
  });
}
