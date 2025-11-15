// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_results_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResultsModel _$SearchResultsModelFromJson(Map<String, dynamic> json) =>
    SearchResultsModel(
      players: SearchResultsModel._playersFromJson(json['players'] as List),
      totalResults: (json['totalResults'] as num).toInt(),
      currentPage: (json['currentPage'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      perPage: (json['perPage'] as num).toInt(),
      hasMorePages: json['hasMorePages'] as bool,
    );

Map<String, dynamic> _$SearchResultsModelToJson(SearchResultsModel instance) =>
    <String, dynamic>{
      'totalResults': instance.totalResults,
      'currentPage': instance.currentPage,
      'totalPages': instance.totalPages,
      'perPage': instance.perPage,
      'hasMorePages': instance.hasMorePages,
      'players': SearchResultsModel._playersToJson(instance.players),
    };
