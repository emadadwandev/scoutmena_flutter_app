import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:scoutmena_app/core/error/failures.dart';
import 'package:scoutmena_app/features/player_profile/domain/entities/player_stat.dart';
import 'package:scoutmena_app/features/player_profile/domain/usecases/create_player_stat.dart';

import '../../../../helpers/test_helpers.mocks.dart';

void main() {
  late CreatePlayerStat usecase;
  late MockPlayerRepository mockRepository;

  setUp(() {
    mockRepository = MockPlayerRepository();
    usecase = CreatePlayerStat(mockRepository);
  });

  const tPlayerId = 'player123';
  final tStatData = {
    'season': '2024/2025',
    'competition': 'Egyptian Premier League',
    'matches_played': 15,
    'goals': 8,
    'assists': 5,
  };

  final tPlayerStat = PlayerStat(
    id: 'stat123',
    playerId: tPlayerId,
    season: '2024/2025',
    competition: 'Egyptian Premier League',
    matchesPlayed: 15,
    minutesPlayed: 1200,
    goals: 8,
    assists: 5,
    yellowCards: 2,
    redCards: 0,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 6, 15),
  );

  test('should return PlayerStat when stat creation is successful', () async {
    // arrange
    when(mockRepository.createPlayerStat(any, any))
        .thenAnswer((_) async => Right(tPlayerStat));

    // act
    final result = await usecase(CreatePlayerStatParams(
      playerId: tPlayerId,
      statData: tStatData,
    ));

    // assert
    expect(result, Right(tPlayerStat));
    verify(mockRepository.createPlayerStat(tPlayerId, tStatData));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ValidationFailure when stat data is invalid', () async {
    // arrange
    when(mockRepository.createPlayerStat(any, any))
        .thenAnswer((_) async => const Left(ValidationFailure(
              message: 'Invalid stat data',
              errors: {'matches_played': ['Must be a positive number']},
            )));

    // act
    final result = await usecase(CreatePlayerStatParams(
      playerId: tPlayerId,
      statData: {'matches_played': -5},
    ));

    // assert
    expect(
      result,
      const Left(ValidationFailure(
        message: 'Invalid stat data',
        errors: {'matches_played': ['Must be a positive number']},
      )),
    );
    verify(mockRepository.createPlayerStat(tPlayerId, {'matches_played': -5}));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return AuthenticationFailure when user is not authenticated', () async {
    // arrange
    when(mockRepository.createPlayerStat(any, any))
        .thenAnswer((_) async => const Left(AuthenticationFailure(message: 'Not authenticated')));

    // act
    final result = await usecase(CreatePlayerStatParams(
      playerId: tPlayerId,
      statData: tStatData,
    ));

    // assert
    expect(result, const Left(AuthenticationFailure(message: 'Not authenticated')));
    verify(mockRepository.createPlayerStat(tPlayerId, tStatData));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ServerFailure when profile not found', () async {
    // arrange
    when(mockRepository.createPlayerStat(any, any))
        .thenAnswer((_) async => const Left(ServerFailure(message: 'Player profile not found')));

    // act
    final result = await usecase(CreatePlayerStatParams(
      playerId: 'invalid_id',
      statData: tStatData,
    ));

    // assert
    expect(result, const Left(ServerFailure(message: 'Player profile not found')));
    verify(mockRepository.createPlayerStat('invalid_id', tStatData));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return NetworkFailure when network error occurs', () async {
    // arrange
    when(mockRepository.createPlayerStat(any, any))
        .thenAnswer((_) async => const Left(NetworkFailure(message: 'No internet connection')));

    // act
    final result = await usecase(CreatePlayerStatParams(
      playerId: tPlayerId,
      statData: tStatData,
    ));

    // assert
    expect(result, const Left(NetworkFailure(message: 'No internet connection')));
    verify(mockRepository.createPlayerStat(tPlayerId, tStatData));
    verifyNoMoreInteractions(mockRepository);
  });
}
