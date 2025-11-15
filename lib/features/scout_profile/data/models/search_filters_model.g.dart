// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_filters_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchFiltersModel _$SearchFiltersModelFromJson(Map<String, dynamic> json) =>
    SearchFiltersModel(
      positions: (json['positions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      minAge: (json['minAge'] as num?)?.toInt(),
      maxAge: (json['maxAge'] as num?)?.toInt(),
      countries: (json['countries'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      minHeight: (json['minHeight'] as num?)?.toInt(),
      maxHeight: (json['maxHeight'] as num?)?.toInt(),
      dominantFoot: json['dominantFoot'] as String?,
      currentClub: json['currentClub'] as String?,
      nationalities: (json['nationalities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      searchQuery: json['searchQuery'] as String?,
      sortBy: json['sortBy'] as String?,
      sortOrder: json['sortOrder'] as String?,
    );

Map<String, dynamic> _$SearchFiltersModelToJson(SearchFiltersModel instance) =>
    <String, dynamic>{
      'positions': instance.positions,
      'minAge': instance.minAge,
      'maxAge': instance.maxAge,
      'countries': instance.countries,
      'minHeight': instance.minHeight,
      'maxHeight': instance.maxHeight,
      'dominantFoot': instance.dominantFoot,
      'currentClub': instance.currentClub,
      'nationalities': instance.nationalities,
      'searchQuery': instance.searchQuery,
      'sortBy': instance.sortBy,
      'sortOrder': instance.sortOrder,
    };
