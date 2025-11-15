import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:scoutmena_app/core/error/failures.dart';
import 'package:scoutmena_app/features/player_profile/domain/usecases/delete_player_stat.dart';

import '../../../../helpers/test_helpers.mocks.dart';

void main() {
  late DeletePlayerStat usecase;
  late MockPlayerRepository mockRepository;

  setUp(() {
    mockRepository = MockPlayerRepository();
    usecase = DeletePlayerStat(mockRepository);
  });

  group('DeletePlayerStat', () {
    const tPlayerId = 'player123';
    const tStatId = 'stat456';

    test('should delete player stat successfully', () async {
      // arrange
      when(mockRepository.deletePlayerStat(any, any))
          .thenAnswer((_) async => const Right(null));

      // act
      final result = await usecase(const DeletePlayerStatParams(
        playerId: tPlayerId,
        statId: tStatId,
      ));

      // assert
      expect(result, const Right(null));
      verify(mockRepository.deletePlayerStat(tPlayerId, tStatId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return AuthenticationFailure when user is not authenticated', () async {
      // arrange
      final tFailure = AuthenticationFailure(message: 'User not authenticated');
      when(mockRepository.deletePlayerStat(any, any))
          .thenAnswer((_) async => Left(tFailure));

      // act
      final result = await usecase(const DeletePlayerStatParams(
        playerId: tPlayerId,
        statId: tStatId,
      ));

      // assert
      expect(result, Left(tFailure));
      verify(mockRepository.deletePlayerStat(tPlayerId, tStatId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when stat is not found', () async {
      // arrange
      final tFailure = ServerFailure(message: 'Stat not found');
      when(mockRepository.deletePlayerStat(any, any))
          .thenAnswer((_) async => Left(tFailure));

      // act
      final result = await usecase(const DeletePlayerStatParams(
        playerId: tPlayerId,
        statId: tStatId,
      ));

      // assert
      expect(result, Left(tFailure));
      verify(mockRepository.deletePlayerStat(tPlayerId, tStatId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when user has no permission to delete', () async {
      // arrange
      final tFailure = ServerFailure(message: 'Permission denied');
      when(mockRepository.deletePlayerStat(any, any))
          .thenAnswer((_) async => Left(tFailure));

      // act
      final result = await usecase(const DeletePlayerStatParams(
        playerId: tPlayerId,
        statId: tStatId,
      ));

      // assert
      expect(result, Left(tFailure));
      verify(mockRepository.deletePlayerStat(tPlayerId, tStatId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NetworkFailure when network connection fails', () async {
      // arrange
      final tFailure = NetworkFailure(message: 'No internet connection');
      when(mockRepository.deletePlayerStat(any, any))
          .thenAnswer((_) async => Left(tFailure));

      // act
      final result = await usecase(const DeletePlayerStatParams(
        playerId: tPlayerId,
        statId: tStatId,
      ));

      // assert
      expect(result, Left(tFailure));
      verify(mockRepository.deletePlayerStat(tPlayerId, tStatId));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
