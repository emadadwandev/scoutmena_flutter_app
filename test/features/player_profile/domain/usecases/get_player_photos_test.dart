import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:scoutmena_app/core/error/failures.dart';
import 'package:scoutmena_app/features/player_profile/domain/entities/player_photo.dart';
import 'package:scoutmena_app/features/player_profile/domain/usecases/get_player_photos.dart';

import '../../../../helpers/test_helpers.mocks.dart';

void main() {
  late GetPlayerPhotos usecase;
  late MockPlayerRepository mockRepository;

  setUp(() {
    mockRepository = MockPlayerRepository();
    usecase = GetPlayerPhotos(mockRepository);
  });

  const tPlayerId = 'player123';
  final tPlayerPhotos = [
    PlayerPhoto(
      id: 'photo1',
      playerId: tPlayerId,
      photoUrl: 'https://example.com/photo1.jpg',
      thumbnailUrl: 'https://example.com/photo1_thumb.jpg',
      caption: 'Training session',
      isPrimary: true,
      order: 1,
      uploadedAt: DateTime(2024, 6, 1),
    ),
    PlayerPhoto(
      id: 'photo2',
      playerId: tPlayerId,
      photoUrl: 'https://example.com/photo2.jpg',
      thumbnailUrl: 'https://example.com/photo2_thumb.jpg',
      caption: 'Match day',
      isPrimary: false,
      order: 2,
      uploadedAt: DateTime(2024, 6, 15),
    ),
  ];

  test('should return list of PlayerPhoto when successful', () async {
    // arrange
    when(mockRepository.getPlayerPhotos(any))
        .thenAnswer((_) async => Right(tPlayerPhotos));

    // act
    final result = await usecase(const GetPlayerPhotosParams(playerId: tPlayerId));

    // assert
    expect(result, Right(tPlayerPhotos));
    expect((result as Right<Failure, List<PlayerPhoto>>).value.length, 2);
    verify(mockRepository.getPlayerPhotos(tPlayerId));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return empty list when player has no photos', () async {
    // arrange
    final List<PlayerPhoto> emptyList = [];
    when(mockRepository.getPlayerPhotos(any))
        .thenAnswer((_) async => Right(emptyList));

    // act
    final result = await usecase(const GetPlayerPhotosParams(playerId: tPlayerId));

    // assert
    expect(result, Right(emptyList));
    expect((result as Right<Failure, List<PlayerPhoto>>).value.isEmpty, true);
    verify(mockRepository.getPlayerPhotos(tPlayerId));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return AuthenticationFailure when user is not authenticated', () async {
    // arrange
    when(mockRepository.getPlayerPhotos(any))
        .thenAnswer((_) async => const Left(AuthenticationFailure(message: 'Not authenticated')));

    // act
    final result = await usecase(const GetPlayerPhotosParams(playerId: tPlayerId));

    // assert
    expect(result, const Left(AuthenticationFailure(message: 'Not authenticated')));
    verify(mockRepository.getPlayerPhotos(tPlayerId));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ServerFailure when profile not found', () async {
    // arrange
    when(mockRepository.getPlayerPhotos(any))
        .thenAnswer((_) async => const Left(ServerFailure(message: 'Player profile not found')));

    // act
    final result = await usecase(const GetPlayerPhotosParams(playerId: 'invalid_id'));

    // assert
    expect(result, const Left(ServerFailure(message: 'Player profile not found')));
    verify(mockRepository.getPlayerPhotos('invalid_id'));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return NetworkFailure when network error occurs', () async {
    // arrange
    when(mockRepository.getPlayerPhotos(any))
        .thenAnswer((_) async => const Left(NetworkFailure(message: 'No internet connection')));

    // act
    final result = await usecase(const GetPlayerPhotosParams(playerId: tPlayerId));

    // assert
    expect(result, const Left(NetworkFailure(message: 'No internet connection')));
    verify(mockRepository.getPlayerPhotos(tPlayerId));
    verifyNoMoreInteractions(mockRepository);
  });
}
