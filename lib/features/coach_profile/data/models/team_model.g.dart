// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamModel _$TeamModelFromJson(Map<String, dynamic> json) => TeamModel(
      id: json['id'] as String,
      coachId: json['coachId'] as String,
      teamName: json['teamName'] as String,
      ageGroup: json['ageGroup'] as String,
      clubName: json['clubName'] as String?,
      playerIds:
          (json['playerIds'] as List<dynamic>).map((e) => e as String).toList(),
      season: json['season'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$TeamModelToJson(TeamModel instance) => <String, dynamic>{
      'id': instance.id,
      'coachId': instance.coachId,
      'teamName': instance.teamName,
      'clubName': instance.clubName,
      'season': instance.season,
      'ageGroup': instance.ageGroup,
      'playerIds': instance.playerIds,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
