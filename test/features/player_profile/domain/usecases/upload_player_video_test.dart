import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:scoutmena_app/core/error/failures.dart';
import 'package:scoutmena_app/features/player_profile/domain/entities/player_video.dart';
import 'package:scoutmena_app/features/player_profile/domain/usecases/upload_player_video.dart';

import '../../../../helpers/test_helpers.mocks.dart';

void main() {
  late UploadPlayerVideo usecase;
  late MockPlayerRepository mockRepository;

  setUp(() {
    mockRepository = MockPlayerRepository();
    usecase = UploadPlayerVideo(mockRepository);
  });

  group('UploadPlayerVideo', () {
    const tPlayerId = 'player123';
    final tVideoFile = File('test/fixtures/video.mp4');
    final tThumbnailFile = File('test/fixtures/thumbnail.jpg');
    const tTitle = 'Goals Compilation';
    const tDescription = 'My best goals from 2024 season';

    final tPlayerVideo = PlayerVideo(
      id: 'video123',
      playerId: tPlayerId,
      videoUrl: 'https://storage.example.com/videos/video123.mp4',
      thumbnailUrl: 'https://storage.example.com/thumbnails/thumb123.jpg',
      title: tTitle,
      description: tDescription,
      durationSeconds: 180,
      videoType: 'highlight',
      order: 1,
      views: 0,
      uploadedAt: DateTime.now(),
    );

    test('should upload player video successfully', () async {
      // arrange
      when(mockRepository.uploadPlayerVideo(
        any,
        any,
        title: anyNamed('title'),
        description: anyNamed('description'),
        videoType: anyNamed('videoType'),
        thumbnailFile: anyNamed('thumbnailFile'),
      )).thenAnswer((_) async => Right(tPlayerVideo));

      // act
      final result = await usecase(UploadPlayerVideoParams(
        playerId: tPlayerId,
        videoFile: tVideoFile,
        title: tTitle,
        description: tDescription,
        videoType: 'highlight',
        thumbnailFile: tThumbnailFile,
      ));

      // assert
      expect(result, Right(tPlayerVideo));
      verify(mockRepository.uploadPlayerVideo(
        tPlayerId,
        tVideoFile,
        title: tTitle,
        description: tDescription,
        videoType: 'highlight',
        thumbnailFile: tThumbnailFile,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ValidationFailure when video file is invalid', () async {
      // arrange
      final tFailure = ValidationFailure(message: 'Invalid video file', errors: {
        'video_file': ['File size exceeds limit'],
      });
      when(mockRepository.uploadPlayerVideo(
        any,
        any,
        title: anyNamed('title'),
        description: anyNamed('description'),
        videoType: anyNamed('videoType'),
        thumbnailFile: anyNamed('thumbnailFile'),
      )).thenAnswer((_) async => Left(tFailure));

      // act
      final result = await usecase(UploadPlayerVideoParams(
        playerId: tPlayerId,
        videoFile: tVideoFile,
        title: tTitle,
      ));

      // assert
      expect(result, Left(tFailure));
      verify(mockRepository.uploadPlayerVideo(
        tPlayerId,
        tVideoFile,
        title: tTitle,
        description: null,
        videoType: 'highlight',
        thumbnailFile: null,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return AuthenticationFailure when user is not authenticated', () async {
      // arrange
      final tFailure = AuthenticationFailure(message: 'User not authenticated');
      when(mockRepository.uploadPlayerVideo(
        any,
        any,
        title: anyNamed('title'),
        description: anyNamed('description'),
        videoType: anyNamed('videoType'),
        thumbnailFile: anyNamed('thumbnailFile'),
      )).thenAnswer((_) async => Left(tFailure));

      // act
      final result = await usecase(UploadPlayerVideoParams(
        playerId: tPlayerId,
        videoFile: tVideoFile,
        title: tTitle,
      ));

      // assert
      expect(result, Left(tFailure));
      verify(mockRepository.uploadPlayerVideo(
        tPlayerId,
        tVideoFile,
        title: tTitle,
        description: null,
        videoType: 'highlight',
        thumbnailFile: null,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when upload fails', () async {
      // arrange
      final tFailure = ServerFailure(message: 'Video upload failed');
      when(mockRepository.uploadPlayerVideo(
        any,
        any,
        title: anyNamed('title'),
        description: anyNamed('description'),
        videoType: anyNamed('videoType'),
        thumbnailFile: anyNamed('thumbnailFile'),
      )).thenAnswer((_) async => Left(tFailure));

      // act
      final result = await usecase(UploadPlayerVideoParams(
        playerId: tPlayerId,
        videoFile: tVideoFile,
        title: tTitle,
      ));

      // assert
      expect(result, Left(tFailure));
      verify(mockRepository.uploadPlayerVideo(
        tPlayerId,
        tVideoFile,
        title: tTitle,
        description: null,
        videoType: 'highlight',
        thumbnailFile: null,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NetworkFailure when network connection fails', () async {
      // arrange
      final tFailure = NetworkFailure(message: 'No internet connection');
      when(mockRepository.uploadPlayerVideo(
        any,
        any,
        title: anyNamed('title'),
        description: anyNamed('description'),
        videoType: anyNamed('videoType'),
        thumbnailFile: anyNamed('thumbnailFile'),
      )).thenAnswer((_) async => Left(tFailure));

      // act
      final result = await usecase(UploadPlayerVideoParams(
        playerId: tPlayerId,
        videoFile: tVideoFile,
        title: tTitle,
      ));

      // assert
      expect(result, Left(tFailure));
      verify(mockRepository.uploadPlayerVideo(
        tPlayerId,
        tVideoFile,
        title: tTitle,
        description: null,
        videoType: 'highlight',
        thumbnailFile: null,
      ));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
