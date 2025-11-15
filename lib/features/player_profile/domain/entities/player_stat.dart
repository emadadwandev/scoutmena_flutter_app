import 'package:equatable/equatable.dart';

/// Player statistics entity
class PlayerStat extends Equatable {
  final String id;
  final String playerId;
  final String season; // e.g., "2024/2025"
  final String competition; // e.g., "Premier League", "Champions League"
  final int matchesPlayed;
  final int minutesPlayed;
  final int goals;
  final int assists;
  final int yellowCards;
  final int redCards;
  final double? passAccuracy; // percentage 0-100
  final int? shotsOnTarget;
  final int? totalShots;
  final int? tackles;
  final int? interceptions;
  final int? cleanSheets;
  final int? saves; // for goalkeepers
  final DateTime createdAt;
  final DateTime updatedAt;

  const PlayerStat({
    required this.id,
    required this.playerId,
    required this.season,
    required this.competition,
    required this.matchesPlayed,
    required this.minutesPlayed,
    required this.goals,
    required this.assists,
    required this.yellowCards,
    required this.redCards,
    this.passAccuracy,
    this.shotsOnTarget,
    this.totalShots,
    this.tackles,
    this.interceptions,
    this.cleanSheets,
    this.saves,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Calculate goals per match ratio
  double get goalsPerMatch =>
      matchesPlayed > 0 ? goals / matchesPlayed : 0.0;

  /// Calculate assists per match ratio
  double get assistsPerMatch =>
      matchesPlayed > 0 ? assists / matchesPlayed : 0.0;

  /// Calculate shot accuracy percentage
  double? get shotAccuracy {
    if (totalShots != null && totalShots! > 0 && shotsOnTarget != null) {
      return (shotsOnTarget! / totalShots!) * 100;
    }
    return null;
  }

  /// Calculate average minutes per match
  double get averageMinutesPerMatch =>
      matchesPlayed > 0 ? minutesPlayed / matchesPlayed : 0.0;

  PlayerStat copyWith({
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
    return PlayerStat(
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

  @override
  List<Object?> get props => [
        id,
        playerId,
        season,
        competition,
        matchesPlayed,
        minutesPlayed,
        goals,
        assists,
        yellowCards,
        redCards,
        passAccuracy,
        shotsOnTarget,
        totalShots,
        tackles,
        interceptions,
        cleanSheets,
        saves,
        createdAt,
        updatedAt,
      ];
}
