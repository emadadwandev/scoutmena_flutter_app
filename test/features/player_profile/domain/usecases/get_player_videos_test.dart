import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:scoutmena_app/core/error/failures.dart';
import 'package:scoutmena_app/features/player_profile/domain/entities/player_video.dart';
import 'package:scoutmena_app/features/player_profile/domain/usecases/get_player_videos.dart';

import '../../../../helpers/test_helpers.mocks.dart';

void main() {
  late GetPlayerVideos usecase;
  late MockPlayerRepository mockRepository;

  setUp(() {
    mockRepository = MockPlayerRepository();
    usecase = GetPlayerVideos(mockRepository);
  });

  group('GetPlayerVideos', () {
    const tPlayerId = 'player123';
    final tPlayerVideos = [
      PlayerVideo(
        id: 'video1',
        playerId: tPlayerId,
        videoUrl: 'https://example.com/video1.mp4',
        title: 'Goals Compilation',
        durationSeconds: 180,
        videoType: 'highlight',
        order: 1,
        views: 150,
        uploadedAt: DateTime(2024, 1, 15),
      ),
      PlayerVideo(
        id: 'video2',
        playerId: tPlayerId,
        videoUrl: 'https://example.com/video2.mp4',
        title: 'Training Session',
        durationSeconds: 300,
        videoType: 'training',
        order: 2,
        views: 80,
        uploadedAt: DateTime(2024, 1, 20),
      ),
    ];

    test('should return list of player videos when successful', () async {
      // arrange
      when(mockRepository.getPlayerVideos(any))
          .thenAnswer((_) async => Right(tPlayerVideos));

      // act
      final result = await usecase(const GetPlayerVideosParams(playerId: tPlayerId));

      // assert
      expect(result, Right(tPlayerVideos));
      verify(mockRepository.getPlayerVideos(tPlayerId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return empty list when player has no videos', () async {
      // arrange
      when(mockRepository.getPlayerVideos(any))
          .thenAnswer((_) async => const Right(<PlayerVideo>[]));

      // act
      final result = await usecase(const GetPlayerVideosParams(playerId: tPlayerId));

      // assert
      expect(result, const Right(<PlayerVideo>[]));
      verify(mockRepository.getPlayerVideos(tPlayerId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return AuthenticationFailure when user is not authenticated', () async {
      // arrange
      final tFailure = AuthenticationFailure(message: 'User not authenticated');
      when(mockRepository.getPlayerVideos(any))
          .thenAnswer((_) async => Left(tFailure));

      // act
      final result = await usecase(const GetPlayerVideosParams(playerId: tPlayerId));

      // assert
      expect(result, Left(tFailure));
      verify(mockRepository.getPlayerVideos(tPlayerId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when player profile is not found', () async {
      // arrange
      final tFailure = ServerFailure(message: 'Player profile not found');
      when(mockRepository.getPlayerVideos(any))
          .thenAnswer((_) async => Left(tFailure));

      // act
      final result = await usecase(const GetPlayerVideosParams(playerId: tPlayerId));

      // assert
      expect(result, Left(tFailure));
      verify(mockRepository.getPlayerVideos(tPlayerId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NetworkFailure when network connection fails', () async {
      // arrange
      final tFailure = NetworkFailure(message: 'No internet connection');
      when(mockRepository.getPlayerVideos(any))
          .thenAnswer((_) async => Left(tFailure));

      // act
      final result = await usecase(const GetPlayerVideosParams(playerId: tPlayerId));

      // assert
      expect(result, Left(tFailure));
      verify(mockRepository.getPlayerVideos(tPlayerId));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
