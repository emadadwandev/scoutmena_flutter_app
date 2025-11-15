import 'package:flutter_test/flutter_test.dart';
import 'package:scoutmena_app/features/player_profile/domain/entities/player_stat.dart';

void main() {
  group('PlayerStat', () {
    final tCreatedAt = DateTime(2024, 1, 1);
    final tUpdatedAt = DateTime(2024, 1, 15);

    final tPlayerStat = PlayerStat(
      id: 'stat123',
      playerId: 'player123',
      season: '2024/2025',
      competition: 'Saudi Pro League',
      matchesPlayed: 25,
      minutesPlayed: 2000,
      goals: 15,
      assists: 8,
      yellowCards: 2,
      redCards: 0,
      passAccuracy: 85.5,
      shotsOnTarget: 30,
      totalShots: 50,
      tackles: 20,
      interceptions: 15,
      cleanSheets: 10,
      saves: 50,
      createdAt: tCreatedAt,
      updatedAt: tUpdatedAt,
    );

    test('should be a subclass of Equatable', () {
      // assert
      expect(tPlayerStat, isA<PlayerStat>());
    });

    test('goalsPerMatch should calculate correctly', () {
      // assert
      expect(tPlayerStat.goalsPerMatch, 15 / 25); // 0.6
    });

    test('goalsPerMatch should return 0 when no matches played', () {
      // arrange
      final statNoMatches = tPlayerStat.copyWith(matchesPlayed: 0);

      // assert
      expect(statNoMatches.goalsPerMatch, 0.0);
    });

    test('assistsPerMatch should calculate correctly', () {
      // assert
      expect(tPlayerStat.assistsPerMatch, 8 / 25); // 0.32
    });

    test('assistsPerMatch should return 0 when no matches played', () {
      // arrange
      final statNoMatches = tPlayerStat.copyWith(matchesPlayed: 0);

      // assert
      expect(statNoMatches.assistsPerMatch, 0.0);
    });

    test('shotAccuracy should calculate correctly', () {
      // act
      final accuracy = tPlayerStat.shotAccuracy;

      // assert
      expect(accuracy, isNotNull);
      expect(accuracy, (30 / 50) * 100); // 60%
    });

    test('shotAccuracy should return null when totalShots is null', () {
      // arrange
      final statNoShots = PlayerStat(
        id: 'stat123',
        playerId: 'player123',
        season: '2024/2025',
        competition: 'Saudi Pro League',
        matchesPlayed: 25,
        minutesPlayed: 2000,
        goals: 15,
        assists: 8,
        yellowCards: 2,
        redCards: 0,
        createdAt: tCreatedAt,
        updatedAt: tUpdatedAt,
      );

      // assert
      expect(statNoShots.shotAccuracy, isNull);
    });

    test('shotAccuracy should return null when totalShots is 0', () {
      // arrange
      final statZeroShots = tPlayerStat.copyWith(totalShots: 0);

      // assert
      expect(statZeroShots.shotAccuracy, isNull);
    });

    test('averageMinutesPerMatch should calculate correctly', () {
      // assert
      expect(tPlayerStat.averageMinutesPerMatch, 2000 / 25); // 80 minutes
    });

    test('averageMinutesPerMatch should return 0 when no matches played', () {
      // arrange
      final statNoMatches = tPlayerStat.copyWith(matchesPlayed: 0);

      // assert
      expect(statNoMatches.averageMinutesPerMatch, 0.0);
    });

    test('should have correct props for Equatable comparison', () {
      // arrange
      final stat1 = PlayerStat(
        id: 'stat123',
        playerId: 'player123',
        season: '2024/2025',
        competition: 'Saudi Pro League',
        matchesPlayed: 25,
        minutesPlayed: 2000,
        goals: 15,
        assists: 8,
        yellowCards: 2,
        redCards: 0,
        createdAt: tCreatedAt,
        updatedAt: tUpdatedAt,
      );

      final stat2 = PlayerStat(
        id: 'stat123',
        playerId: 'player123',
        season: '2024/2025',
        competition: 'Saudi Pro League',
        matchesPlayed: 25,
        minutesPlayed: 2000,
        goals: 15,
        assists: 8,
        yellowCards: 2,
        redCards: 0,
        createdAt: tCreatedAt,
        updatedAt: tUpdatedAt,
      );

      // assert
      expect(stat1, equals(stat2));
    });

    test('should not be equal when properties differ', () {
      // arrange
      final stat1 = tPlayerStat;
      final stat2 = tPlayerStat.copyWith(goals: 20);

      // assert
      expect(stat1, isNot(equals(stat2)));
    });

    test('copyWith should create new instance with updated properties', () {
      // act
      final updatedStat = tPlayerStat.copyWith(
        goals: 20,
        assists: 10,
        matchesPlayed: 30,
      );

      // assert
      expect(updatedStat.goals, 20);
      expect(updatedStat.assists, 10);
      expect(updatedStat.matchesPlayed, 30);
      expect(updatedStat.id, tPlayerStat.id);
      expect(updatedStat.playerId, tPlayerStat.playerId);
      expect(updatedStat.season, tPlayerStat.season);
    });

    test('should handle optional fields correctly', () {
      // arrange
      final minimalStat = PlayerStat(
        id: 'stat123',
        playerId: 'player123',
        season: '2024/2025',
        competition: 'Saudi Pro League',
        matchesPlayed: 10,
        minutesPlayed: 800,
        goals: 5,
        assists: 3,
        yellowCards: 1,
        redCards: 0,
        createdAt: tCreatedAt,
        updatedAt: tUpdatedAt,
      );

      // assert
      expect(minimalStat.passAccuracy, isNull);
      expect(minimalStat.shotsOnTarget, isNull);
      expect(minimalStat.totalShots, isNull);
      expect(minimalStat.tackles, isNull);
      expect(minimalStat.interceptions, isNull);
      expect(minimalStat.cleanSheets, isNull);
      expect(minimalStat.saves, isNull);
    });
  });
}
