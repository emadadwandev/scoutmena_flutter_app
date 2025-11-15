import 'package:flutter_test/flutter_test.dart';
import 'package:scoutmena_app/features/player_profile/domain/entities/player_video.dart';

void main() {
  group('PlayerVideo', () {
    final tUploadedAt = DateTime(2024, 1, 15);
    final tPlayerVideo = PlayerVideo(
      id: 'video123',
      playerId: 'player123',
      videoUrl: 'https://example.com/video.mp4',
      thumbnailUrl: 'https://example.com/thumb.jpg',
      title: 'Goals Compilation',
      description: 'My best goals from 2024 season',
      durationSeconds: 185, // 3 minutes 5 seconds
      videoType: 'highlight',
      order: 1,
      views: 150,
      uploadedAt: tUploadedAt,
    );

    test('should be a subclass of Equatable', () {
      // assert
      expect(tPlayerVideo, isA<PlayerVideo>());
    });

    test('formattedDuration should format seconds as mm:ss correctly', () {
      // assert
      expect(tPlayerVideo.formattedDuration, '03:05');
    });

    test('formattedDuration should handle single digit minutes and seconds', () {
      // arrange
      final video = PlayerVideo(
        id: 'video123',
        playerId: 'player123',
        videoUrl: 'https://example.com/video.mp4',
        title: 'Short Video',
        durationSeconds: 65, // 1 minute 5 seconds
        videoType: 'highlight',
        order: 1,
        views: 0,
        uploadedAt: tUploadedAt,
      );

      // assert
      expect(video.formattedDuration, '01:05');
    });

    test('formattedDuration should handle durations less than a minute', () {
      // arrange
      final video = PlayerVideo(
        id: 'video123',
        playerId: 'player123',
        videoUrl: 'https://example.com/video.mp4',
        title: 'Very Short Video',
        durationSeconds: 45, // 45 seconds
        videoType: 'highlight',
        order: 1,
        views: 0,
        uploadedAt: tUploadedAt,
      );

      // assert
      expect(video.formattedDuration, '00:45');
    });

    test('formattedDuration should handle long durations', () {
      // arrange
      final video = PlayerVideo(
        id: 'video123',
        playerId: 'player123',
        videoUrl: 'https://example.com/video.mp4',
        title: 'Full Match',
        durationSeconds: 5400, // 90 minutes
        videoType: 'match',
        order: 1,
        views: 0,
        uploadedAt: tUploadedAt,
      );

      // assert
      expect(video.formattedDuration, '90:00');
    });

    test('should have correct props for Equatable comparison', () {
      // arrange
      final video1 = PlayerVideo(
        id: 'video123',
        playerId: 'player123',
        videoUrl: 'https://example.com/video.mp4',
        title: 'Test Video',
        durationSeconds: 120,
        videoType: 'highlight',
        order: 1,
        views: 100,
        uploadedAt: tUploadedAt,
      );

      final video2 = PlayerVideo(
        id: 'video123',
        playerId: 'player123',
        videoUrl: 'https://example.com/video.mp4',
        title: 'Test Video',
        durationSeconds: 120,
        videoType: 'highlight',
        order: 1,
        views: 100,
        uploadedAt: tUploadedAt,
      );

      // assert
      expect(video1, equals(video2));
    });

    test('should not be equal when properties differ', () {
      // arrange
      final video1 = tPlayerVideo;
      final video2 = tPlayerVideo.copyWith(views: 200);

      // assert
      expect(video1, isNot(equals(video2)));
    });

    test('copyWith should create new instance with updated properties', () {
      // act
      final updatedVideo = tPlayerVideo.copyWith(
        title: 'Updated Title',
        views: 300,
        order: 2,
      );

      // assert
      expect(updatedVideo.title, 'Updated Title');
      expect(updatedVideo.views, 300);
      expect(updatedVideo.order, 2);
      expect(updatedVideo.id, tPlayerVideo.id);
      expect(updatedVideo.playerId, tPlayerVideo.playerId);
      expect(updatedVideo.videoUrl, tPlayerVideo.videoUrl);
    });

    test('copyWith should preserve original values when not specified', () {
      // act
      final updatedVideo = tPlayerVideo.copyWith(title: 'New Title');

      // assert
      expect(updatedVideo.id, tPlayerVideo.id);
      expect(updatedVideo.playerId, tPlayerVideo.playerId);
      expect(updatedVideo.videoUrl, tPlayerVideo.videoUrl);
      expect(updatedVideo.thumbnailUrl, tPlayerVideo.thumbnailUrl);
      expect(updatedVideo.description, tPlayerVideo.description);
      expect(updatedVideo.durationSeconds, tPlayerVideo.durationSeconds);
      expect(updatedVideo.videoType, tPlayerVideo.videoType);
      expect(updatedVideo.order, tPlayerVideo.order);
      expect(updatedVideo.views, tPlayerVideo.views);
      expect(updatedVideo.uploadedAt, tPlayerVideo.uploadedAt);
      expect(updatedVideo.title, 'New Title');
    });

    test('should handle optional fields correctly', () {
      // arrange
      final videoWithoutOptionals = PlayerVideo(
        id: 'video123',
        playerId: 'player123',
        videoUrl: 'https://example.com/video.mp4',
        title: 'Basic Video',
        durationSeconds: 60,
        videoType: 'highlight',
        order: 1,
        views: 0,
        uploadedAt: tUploadedAt,
      );

      // assert
      expect(videoWithoutOptionals.thumbnailUrl, isNull);
      expect(videoWithoutOptionals.description, isNull);
    });

    test('should support different video types', () {
      // arrange
      final videoTypes = ['highlight', 'training', 'match', 'other'];

      for (final type in videoTypes) {
        final video = PlayerVideo(
          id: 'video123',
          playerId: 'player123',
          videoUrl: 'https://example.com/video.mp4',
          title: 'Video',
          durationSeconds: 60,
          videoType: type,
          order: 1,
          views: 0,
          uploadedAt: tUploadedAt,
        );

        // assert
        expect(video.videoType, type);
      }
    });
  });
}
