import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/player_stat.dart';

part 'player_stat_model.g.dart';

/// Data model for player statistics with JSON serialization
@JsonSerializable(explicitToJson: true)
class PlayerStatModel extends PlayerStat {
  const PlayerStatModel({
    required super.id,
    required super.playerId,
    required super.season,
    required super.competition,
    required super.matchesPlayed,
    required super.minutesPlayed,
    required super.goals,
    required super.assists,
    required super.yellowCards,
    required super.redCards,
    super.passAccuracy,
    super.shotsOnTarget,
    super.totalShots,
    super.tackles,
    super.interceptions,
    super.cleanSheets,
    super.saves,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Create model from JSON
  factory PlayerStatModel.fromJson(Map<String, dynamic> json) =>
      _$PlayerStatModelFromJson(json);

  /// Convert model to JSON
  Map<String, dynamic> toJson() => _$PlayerStatModelToJson(this);

  /// Create model from entity
  factory PlayerStatModel.fromEntity(PlayerStat entity) {
    return PlayerStatModel(
      id: entity.id,
      playerId: entity.playerId,
      season: entity.season,
      competition: entity.competition,
      matchesPlayed: entity.matchesPlayed,
      minutesPlayed: entity.minutesPlayed,
      goals: entity.goals,
      assists: entity.assists,
      yellowCards: entity.yellowCards,
      redCards: entity.redCards,
      passAccuracy: entity.passAccuracy,
      shotsOnTarget: entity.shotsOnTarget,
      totalShots: entity.totalShots,
      tackles: entity.tackles,
      interceptions: entity.interceptions,
      cleanSheets: entity.cleanSheets,
      saves: entity.saves,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Convert model to entity
  PlayerStat toEntity() => this;

  @override
  PlayerStatModel copyWith({
    String? id,
    String? playerId,
    String? season,
    String? competition,
    int? matchesPlayed,
    int? minutesPlayed,
    int? goals,
    int? assists,
    int? yellowCards,
    int? redCards,
    double? passAccuracy,
    int? shotsOnTarget,
    int? totalShots,
    int? tackles,
    int? interceptions,
    int? cleanSheets,
    int? saves,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PlayerStatModel(
      id: id ?? this.id,
      playerId: playerId ?? this.playerId,
      season: season ?? this.season,
      competition: competition ?? this.competition,
      matchesPlayed: matchesPlayed ?? this.matchesPlayed,
      minutesPlayed: minutesPlayed ?? this.minutesPlayed,
      goals: goals ?? this.goals,
      assists: assists ?? this.assists,
      yellowCards: yellowCards ?? this.yellowCards,
      redCards: redCards ?? this.redCards,
      passAccuracy: passAccuracy ?? this.passAccuracy,
      shotsOnTarget: shotsOnTarget ?? this.shotsOnTarget,
      totalShots: totalShots ?? this.totalShots,
      tackles: tackles ?? this.tackles,
      interceptions: interceptions ?? this.interceptions,
      cleanSheets: cleanSheets ?? this.cleanSheets,
      saves: saves ?? this.saves,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
