import 'package:flutter_test/flutter_test.dart';
import 'package:scoutmena_app/features/player_profile/domain/entities/player_photo.dart';

void main() {
  group('PlayerPhoto', () {
    final tUploadedAt = DateTime(2024, 1, 15);
    final tPlayerPhoto = PlayerPhoto(
      id: 'photo123',
      playerId: 'player123',
      photoUrl: 'https://example.com/photo.jpg',
      thumbnailUrl: 'https://example.com/thumb.jpg',
      caption: 'My best action shot',
      isPrimary: true,
      order: 1,
      uploadedAt: tUploadedAt,
    );

    test('should be a subclass of Equatable', () {
      // assert
      expect(tPlayerPhoto, isA<PlayerPhoto>());
    });

    test('should have correct props for Equatable comparison', () {
      // arrange
      final photo1 = PlayerPhoto(
        id: 'photo123',
        playerId: 'player123',
        photoUrl: 'https://example.com/photo.jpg',
        thumbnailUrl: 'https://example.com/thumb.jpg',
        caption: 'Caption',
        isPrimary: true,
        order: 1,
        uploadedAt: tUploadedAt,
      );

      final photo2 = PlayerPhoto(
        id: 'photo123',
        playerId: 'player123',
        photoUrl: 'https://example.com/photo.jpg',
        thumbnailUrl: 'https://example.com/thumb.jpg',
        caption: 'Caption',
        isPrimary: true,
        order: 1,
        uploadedAt: tUploadedAt,
      );

      // assert
      expect(photo1, equals(photo2));
      expect(photo1.hashCode, equals(photo2.hashCode));
    });

    test('should not be equal when properties differ', () {
      // arrange
      final photo1 = PlayerPhoto(
        id: 'photo123',
        playerId: 'player123',
        photoUrl: 'https://example.com/photo.jpg',
        isPrimary: true,
        order: 1,
        uploadedAt: tUploadedAt,
      );

      final photo2 = PlayerPhoto(
        id: 'photo456', // Different ID
        playerId: 'player123',
        photoUrl: 'https://example.com/photo.jpg',
        isPrimary: true,
        order: 1,
        uploadedAt: tUploadedAt,
      );

      // assert
      expect(photo1, isNot(equals(photo2)));
    });

    test('copyWith should create new instance with updated properties', () {
      // act
      final updatedPhoto = tPlayerPhoto.copyWith(
        caption: 'Updated caption',
        isPrimary: false,
        order: 2,
      );

      // assert
      expect(updatedPhoto.id, tPlayerPhoto.id);
      expect(updatedPhoto.playerId, tPlayerPhoto.playerId);
      expect(updatedPhoto.photoUrl, tPlayerPhoto.photoUrl);
      expect(updatedPhoto.caption, 'Updated caption');
      expect(updatedPhoto.isPrimary, false);
      expect(updatedPhoto.order, 2);
    });

    test('copyWith should preserve original values when not specified', () {
      // act
      final updatedPhoto = tPlayerPhoto.copyWith(caption: 'New caption');

      // assert
      expect(updatedPhoto.id, tPlayerPhoto.id);
      expect(updatedPhoto.playerId, tPlayerPhoto.playerId);
      expect(updatedPhoto.photoUrl, tPlayerPhoto.photoUrl);
      expect(updatedPhoto.thumbnailUrl, tPlayerPhoto.thumbnailUrl);
      expect(updatedPhoto.isPrimary, tPlayerPhoto.isPrimary);
      expect(updatedPhoto.order, tPlayerPhoto.order);
      expect(updatedPhoto.uploadedAt, tPlayerPhoto.uploadedAt);
      expect(updatedPhoto.caption, 'New caption');
    });

    test('should handle null optional fields correctly', () {
      // arrange
      final photoWithoutOptionals = PlayerPhoto(
        id: 'photo123',
        playerId: 'player123',
        photoUrl: 'https://example.com/photo.jpg',
        isPrimary: false,
        order: 1,
        uploadedAt: tUploadedAt,
      );

      // assert
      expect(photoWithoutOptionals.thumbnailUrl, isNull);
      expect(photoWithoutOptionals.caption, isNull);
    });
  });
}
