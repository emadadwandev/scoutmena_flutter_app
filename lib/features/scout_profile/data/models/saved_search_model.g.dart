// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_search_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SavedSearchModel _$SavedSearchModelFromJson(Map<String, dynamic> json) =>
    SavedSearchModel(
      id: json['id'] as String,
      scoutId: json['scoutId'] as String,
      searchName: json['searchName'] as String,
      filters: SavedSearchModel._filtersFromJson(
          json['filters'] as Map<String, dynamic>),
      resultCount: (json['resultCount'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastExecutedAt: json['lastExecutedAt'] == null
          ? null
          : DateTime.parse(json['lastExecutedAt'] as String),
    );

Map<String, dynamic> _$SavedSearchModelToJson(SavedSearchModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'scoutId': instance.scoutId,
      'searchName': instance.searchName,
      'resultCount': instance.resultCount,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastExecutedAt': instance.lastExecutedAt?.toIso8601String(),
      'filters': SavedSearchModel._filtersToJson(instance.filters),
    };
