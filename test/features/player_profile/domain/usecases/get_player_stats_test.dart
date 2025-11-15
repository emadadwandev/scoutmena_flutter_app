import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:scoutmena_app/core/error/failures.dart';
import 'package:scoutmena_app/features/player_profile/domain/entities/player_stat.dart';
import 'package:scoutmena_app/features/player_profile/domain/usecases/get_player_stats.dart';

import '../../../../helpers/test_helpers.mocks.dart';

void main() {
  late GetPlayerStats usecase;
  late MockPlayerRepository mockRepository;

  setUp(() {
    mockRepository = MockPlayerRepository();
    usecase = GetPlayerStats(mockRepository);
  });

  const tPlayerId = 'player123';
  final tPlayerStats = [
    PlayerStat(
      id: 'stat1',
      playerId: tPlayerId,
      season: '2024/2025',
      competition: 'Egyptian Premier League',
      matchesPlayed: 15,
      minutesPlayed: 1200,
      goals: 8,
      assists: 5,
      yellowCards: 2,
      redCards: 0,
      passAccuracy: 85.5,
      shotsOnTarget: 20,
      totalShots: 35,
      tackles: 15,
      interceptions: 10,
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 6, 15),
    ),
    PlayerStat(
      id: 'stat2',
      playerId: tPlayerId,
      season: '2023/2024',
      competition: 'Egyptian Premier League',
      matchesPlayed: 20,
      minutesPlayed: 1600,
      goals: 12,
      assists: 7,
      yellowCards: 3,
      redCards: 1,
      passAccuracy: 82.0,
      shotsOnTarget: 28,
      totalShots: 50,
      tackles: 20,
      interceptions: 15,
      createdAt: DateTime(2023, 9, 1),
      updatedAt: DateTime(2024, 5, 30),
    ),
  ];

  test('should return list of PlayerStat from repository when successful', () async {
    // arrange
    when(mockRepository.getPlayerStats(any))
        .thenAnswer((_) async => Right(tPlayerStats));

    // act
    final result = await usecase(const GetPlayerStatsParams(playerId: tPlayerId));

    // assert
    expect(result, Right(tPlayerStats));
    expect((result as Right<Failure, List<PlayerStat>>).value.length, 2);
    verify(mockRepository.getPlayerStats(tPlayerId));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return empty list when player has no statistics', () async {
    // arrange
    final List<PlayerStat> emptyList = [];
    when(mockRepository.getPlayerStats(any))
        .thenAnswer((_) async => Right(emptyList));

    // act
    final result = await usecase(const GetPlayerStatsParams(playerId: tPlayerId));

    // assert
    expect(result, Right(emptyList));
    expect((result as Right<Failure, List<PlayerStat>>).value.isEmpty, true);
    verify(mockRepository.getPlayerStats(tPlayerId));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return AuthenticationFailure when user is not authenticated', () async {
    // arrange
    when(mockRepository.getPlayerStats(any))
        .thenAnswer((_) async => const Left(AuthenticationFailure(message: 'Not authenticated')));

    // act
    final result = await usecase(const GetPlayerStatsParams(playerId: tPlayerId));

    // assert
    expect(result, const Left(AuthenticationFailure(message: 'Not authenticated')));
    verify(mockRepository.getPlayerStats(tPlayerId));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ServerFailure when profile not found', () async {
    // arrange
    when(mockRepository.getPlayerStats(any))
        .thenAnswer((_) async => const Left(ServerFailure(message: 'Player profile not found')));

    // act
    final result = await usecase(const GetPlayerStatsParams(playerId: 'invalid_id'));

    // assert
    expect(result, const Left(ServerFailure(message: 'Player profile not found')));
    verify(mockRepository.getPlayerStats('invalid_id'));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return NetworkFailure when network error occurs', () async {
    // arrange
    when(mockRepository.getPlayerStats(any))
        .thenAnswer((_) async => const Left(NetworkFailure(message: 'No internet connection')));

    // act
    final result = await usecase(const GetPlayerStatsParams(playerId: tPlayerId));

    // assert
    expect(result, const Left(NetworkFailure(message: 'No internet connection')));
    verify(mockRepository.getPlayerStats(tPlayerId));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return CacheFailure when offline data is not available', () async {
    // arrange
    when(mockRepository.getPlayerStats(any))
        .thenAnswer((_) async => const Left(CacheFailure(message: 'No cached stats data')));

    // act
    final result = await usecase(const GetPlayerStatsParams(playerId: tPlayerId));

    // assert
    expect(result, const Left(CacheFailure(message: 'No cached stats data')));
    verify(mockRepository.getPlayerStats(tPlayerId));
    verifyNoMoreInteractions(mockRepository);
  });
}
