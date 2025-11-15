import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/saved_search.dart';
import '../../domain/entities/search_filters.dart';
import 'search_filters_model.dart';

part 'saved_search_model.g.dart';

/// Saved search data model with JSON serialization
@JsonSerializable(explicitToJson: true)
class SavedSearchModel extends SavedSearch {
  @override
  @JsonKey(fromJson: _filtersFromJson, toJson: _filtersToJson)
  final SearchFilters filters;

  const SavedSearchModel({
    required super.id,
    required super.scoutId,
    required super.searchName,
    required this.filters,
    required super.resultCount,
    required super.createdAt,
    super.lastExecutedAt,
  }) : super(filters: filters);

  static SearchFilters _filtersFromJson(Map<String, dynamic> json) =>
      SearchFiltersModel.fromJson(json);

  static Map<String, dynamic> _filtersToJson(SearchFilters filters) =>
      SearchFiltersModel.fromEntity(filters).toJson();

  factory SavedSearchModel.fromJson(Map<String, dynamic> json) =>
      _$SavedSearchModelFromJson(json);

  Map<String, dynamic> toJson() => _$SavedSearchModelToJson(this);

  /// Convert entity to model
  factory SavedSearchModel.fromEntity(SavedSearch search) {
    return SavedSearchModel(
      id: search.id,
      scoutId: search.scoutId,
      searchName: search.searchName,
      filters: search.filters,
      resultCount: search.resultCount,
      createdAt: search.createdAt,
      lastExecutedAt: search.lastExecutedAt,
    );
  }
}
