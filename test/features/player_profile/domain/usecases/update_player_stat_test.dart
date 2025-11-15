import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:scoutmena_app/core/error/failures.dart';
import 'package:scoutmena_app/features/player_profile/domain/entities/player_stat.dart';
import 'package:scoutmena_app/features/player_profile/domain/usecases/update_player_stat.dart';

import '../../../../helpers/test_helpers.mocks.dart';

void main() {
  late UpdatePlayerStat usecase;
  late MockPlayerRepository mockRepository;

  setUp(() {
    mockRepository = MockPlayerRepository();
    usecase = UpdatePlayerStat(mockRepository);
  });

  group('UpdatePlayerStat', () {
    const tPlayerId = 'player123';
    const tStatId = 'stat456';
    final tPlayerStat = PlayerStat(
      id: 'stat456',
      playerId: 'player123',
      season: '2024',
      competition: 'Saudi Pro League',
      matchesPlayed: 25,
      minutesPlayed: 2000,
      goals: 15,
      assists: 8,
      yellowCards: 2,
      redCards: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final tStatData = {
      'matches_played': 25,
      'goals': 15,
      'assists': 8,
      'yellow_cards': 2,
      'red_cards': 0,
      'minutes_played': 2000,
    };

    test('should update player stat successfully', () async {
      // arrange
      when(mockRepository.updatePlayerStat(any, any, any))
          .thenAnswer((_) async => Right(tPlayerStat));

      // act
      final result = await usecase(UpdatePlayerStatParams(
        playerId: tPlayerId,
        statId: tStatId,
        statData: tStatData,
      ));

      // assert
      expect(result, Right(tPlayerStat));
      verify(mockRepository.updatePlayerStat(tPlayerId, tStatId, tStatData));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ValidationFailure when stat data is invalid', () async {
      // arrange
      final tFailure = ValidationFailure(message: 'Invalid stat data', errors: {
        'goals': ['Goals cannot be negative'],
      });
      when(mockRepository.updatePlayerStat(any, any, any))
          .thenAnswer((_) async => Left(tFailure));

      final invalidData = {'goals': -5};

      // act
      final result = await usecase(UpdatePlayerStatParams(
        playerId: tPlayerId,
        statId: tStatId,
        statData: invalidData,
      ));

      // assert
      expect(result, Left(tFailure));
      verify(mockRepository.updatePlayerStat(tPlayerId, tStatId, invalidData));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return AuthenticationFailure when user is not authenticated', () async {
      // arrange
      final tFailure = AuthenticationFailure(message: 'User not authenticated');
      when(mockRepository.updatePlayerStat(any, any, any))
          .thenAnswer((_) async => Left(tFailure));

      // act
      final result = await usecase(UpdatePlayerStatParams(
        playerId: tPlayerId,
        statId: tStatId,
        statData: tStatData,
      ));

      // assert
      expect(result, Left(tFailure));
      verify(mockRepository.updatePlayerStat(tPlayerId, tStatId, tStatData));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when stat is not found', () async {
      // arrange
      final tFailure = ServerFailure(message: 'Stat not found');
      when(mockRepository.updatePlayerStat(any, any, any))
          .thenAnswer((_) async => Left(tFailure));

      // act
      final result = await usecase(UpdatePlayerStatParams(
        playerId: tPlayerId,
        statId: tStatId,
        statData: tStatData,
      ));

      // assert
      expect(result, Left(tFailure));
      verify(mockRepository.updatePlayerStat(tPlayerId, tStatId, tStatData));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NetworkFailure when network connection fails', () async {
      // arrange
      final tFailure = NetworkFailure(message: 'No internet connection');
      when(mockRepository.updatePlayerStat(any, any, any))
          .thenAnswer((_) async => Left(tFailure));

      // act
      final result = await usecase(UpdatePlayerStatParams(
        playerId: tPlayerId,
        statId: tStatId,
        statData: tStatData,
      ));

      // assert
      expect(result, Left(tFailure));
      verify(mockRepository.updatePlayerStat(tPlayerId, tStatId, tStatData));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
