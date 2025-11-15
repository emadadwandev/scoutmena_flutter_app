// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_stat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerStatModel _$PlayerStatModelFromJson(Map<String, dynamic> json) =>
    PlayerStatModel(
      id: json['id'] as String,
      playerId: json['playerId'] as String,
      season: json['season'] as String,
      competition: json['competition'] as String,
      matchesPlayed: (json['matchesPlayed'] as num).toInt(),
      minutesPlayed: (json['minutesPlayed'] as num).toInt(),
      goals: (json['goals'] as num).toInt(),
      assists: (json['assists'] as num).toInt(),
      yellowCards: (json['yellowCards'] as num).toInt(),
      redCards: (json['redCards'] as num).toInt(),
      passAccuracy: (json['passAccuracy'] as num?)?.toDouble(),
      shotsOnTarget: (json['shotsOnTarget'] as num?)?.toInt(),
      totalShots: (json['totalShots'] as num?)?.toInt(),
      tackles: (json['tackles'] as num?)?.toInt(),
      interceptions: (json['interceptions'] as num?)?.toInt(),
      cleanSheets: (json['cleanSheets'] as num?)?.toInt(),
      saves: (json['saves'] as num?)?.toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$PlayerStatModelToJson(PlayerStatModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'playerId': instance.playerId,
      'season': instance.season,
      'competition': instance.competition,
      'matchesPlayed': instance.matchesPlayed,
      'minutesPlayed': instance.minutesPlayed,
      'goals': instance.goals,
      'assists': instance.assists,
      'yellowCards': instance.yellowCards,
      'redCards': instance.redCards,
      'passAccuracy': instance.passAccuracy,
      'shotsOnTarget': instance.shotsOnTarget,
      'totalShots': instance.totalShots,
      'tackles': instance.tackles,
      'interceptions': instance.interceptions,
      'cleanSheets': instance.cleanSheets,
      'saves': instance.saves,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
