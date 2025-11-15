import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/search_filters.dart';

part 'search_filters_model.g.dart';

/// Search filters data model with JSON serialization
@JsonSerializable(explicitToJson: true)
class SearchFiltersModel extends SearchFilters {
  const SearchFiltersModel({
    super.positions,
    super.minAge,
    super.maxAge,
    super.countries,
    super.minHeight,
    super.maxHeight,
    super.dominantFoot,
    super.currentClub,
    super.nationalities,
    super.searchQuery,
    super.sortBy,
    super.sortOrder,
  });

  factory SearchFiltersModel.fromJson(Map<String, dynamic> json) =>
      _$SearchFiltersModelFromJson(json);

  Map<String, dynamic> toJson() => _$SearchFiltersModelToJson(this);

  /// Convert entity to model
  factory SearchFiltersModel.fromEntity(SearchFilters filters) {
    return SearchFiltersModel(
      positions: filters.positions,
      minAge: filters.minAge,
      maxAge: filters.maxAge,
      countries: filters.countries,
      minHeight: filters.minHeight,
      maxHeight: filters.maxHeight,
      dominantFoot: filters.dominantFoot,
      currentClub: filters.currentClub,
      nationalities: filters.nationalities,
      searchQuery: filters.searchQuery,
      sortBy: filters.sortBy,
      sortOrder: filters.sortOrder,
    );
  }
}
