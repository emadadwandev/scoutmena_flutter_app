import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:scoutmena_app/core/error/failures.dart';
import 'package:scoutmena_app/features/player_profile/domain/usecases/delete_player_video.dart';

import '../../../../helpers/test_helpers.mocks.dart';

void main() {
  late DeletePlayerVideo usecase;
  late MockPlayerRepository mockRepository;

  setUp(() {
    mockRepository = MockPlayerRepository();
    usecase = DeletePlayerVideo(mockRepository);
  });

  group('DeletePlayerVideo', () {
    const tPlayerId = 'player123';
    const tVideoId = 'video789';

    test('should delete player video successfully', () async {
      // arrange
      when(mockRepository.deletePlayerVideo(any, any))
          .thenAnswer((_) async => const Right(null));

      // act
      final result = await usecase(const DeletePlayerVideoParams(
        playerId: tPlayerId,
        videoId: tVideoId,
      ));

      // assert
      expect(result, const Right(null));
      verify(mockRepository.deletePlayerVideo(tPlayerId, tVideoId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return AuthenticationFailure when user is not authenticated', () async {
      // arrange
      final tFailure = AuthenticationFailure(message: 'User not authenticated');
      when(mockRepository.deletePlayerVideo(any, any))
          .thenAnswer((_) async => Left(tFailure));

      // act
      final result = await usecase(const DeletePlayerVideoParams(
        playerId: tPlayerId,
        videoId: tVideoId,
      ));

      // assert
      expect(result, Left(tFailure));
      verify(mockRepository.deletePlayerVideo(tPlayerId, tVideoId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when video is not found', () async {
      // arrange
      final tFailure = ServerFailure(message: 'Video not found');
      when(mockRepository.deletePlayerVideo(any, any))
          .thenAnswer((_) async => Left(tFailure));

      // act
      final result = await usecase(const DeletePlayerVideoParams(
        playerId: tPlayerId,
        videoId: tVideoId,
      ));

      // assert
      expect(result, Left(tFailure));
      verify(mockRepository.deletePlayerVideo(tPlayerId, tVideoId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when user has no permission to delete', () async {
      // arrange
      final tFailure = ServerFailure(message: 'Permission denied');
      when(mockRepository.deletePlayerVideo(any, any))
          .thenAnswer((_) async => Left(tFailure));

      // act
      final result = await usecase(const DeletePlayerVideoParams(
        playerId: tPlayerId,
        videoId: tVideoId,
      ));

      // assert
      expect(result, Left(tFailure));
      verify(mockRepository.deletePlayerVideo(tPlayerId, tVideoId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NetworkFailure when network connection fails', () async {
      // arrange
      final tFailure = NetworkFailure(message: 'No internet connection');
      when(mockRepository.deletePlayerVideo(any, any))
          .thenAnswer((_) async => Left(tFailure));

      // act
      final result = await usecase(const DeletePlayerVideoParams(
        playerId: tPlayerId,
        videoId: tVideoId,
      ));

      // assert
      expect(result, Left(tFailure));
      verify(mockRepository.deletePlayerVideo(tPlayerId, tVideoId));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
