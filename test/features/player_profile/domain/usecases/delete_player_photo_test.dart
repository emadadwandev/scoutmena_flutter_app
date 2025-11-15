import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:scoutmena_app/core/error/failures.dart';
import 'package:scoutmena_app/features/player_profile/domain/usecases/delete_player_photo.dart';

import '../../../../helpers/test_helpers.mocks.dart';

void main() {
  late DeletePlayerPhoto usecase;
  late MockPlayerRepository mockRepository;

  setUp(() {
    mockRepository = MockPlayerRepository();
    usecase = DeletePlayerPhoto(mockRepository);
  });

  const tPlayerId = 'player123';
  const tPhotoId = 'photo123';

  test('should return void when photo deletion is successful', () async {
    // arrange
    when(mockRepository.deletePlayerPhoto(any, any))
        .thenAnswer((_) async => const Right(null));

    // act
    final result = await usecase(const DeletePlayerPhotoParams(
      playerId: tPlayerId,
      photoId: tPhotoId,
    ));

    // assert
    expect(result, const Right(null));
    verify(mockRepository.deletePlayerPhoto(tPlayerId, tPhotoId));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return AuthenticationFailure when user is not authenticated', () async {
    // arrange
    when(mockRepository.deletePlayerPhoto(any, any))
        .thenAnswer((_) async => const Left(AuthenticationFailure(message: 'Not authenticated')));

    // act
    final result = await usecase(const DeletePlayerPhotoParams(
      playerId: tPlayerId,
      photoId: tPhotoId,
    ));

    // assert
    expect(result, const Left(AuthenticationFailure(message: 'Not authenticated')));
    verify(mockRepository.deletePlayerPhoto(tPlayerId, tPhotoId));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ServerFailure when photo not found', () async {
    // arrange
    when(mockRepository.deletePlayerPhoto(any, any))
        .thenAnswer((_) async => const Left(ServerFailure(message: 'Photo not found')));

    // act
    final result = await usecase(const DeletePlayerPhotoParams(
      playerId: tPlayerId,
      photoId: 'invalid_photo_id',
    ));

    // assert
    expect(result, const Left(ServerFailure(message: 'Photo not found')));
    verify(mockRepository.deletePlayerPhoto(tPlayerId, 'invalid_photo_id'));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return PermissionFailure when user lacks permission to delete photo', () async {
    // arrange
    when(mockRepository.deletePlayerPhoto(any, any))
        .thenAnswer((_) async =>
            const Left(PermissionFailure(message: 'You do not have permission to delete this photo')));

    // act
    final result = await usecase(const DeletePlayerPhotoParams(
      playerId: tPlayerId,
      photoId: tPhotoId,
    ));

    // assert
    expect(result, const Left(PermissionFailure(message: 'You do not have permission to delete this photo')));
    verify(mockRepository.deletePlayerPhoto(tPlayerId, tPhotoId));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return NetworkFailure when network error occurs', () async {
    // arrange
    when(mockRepository.deletePlayerPhoto(any, any))
        .thenAnswer((_) async => const Left(NetworkFailure(message: 'No internet connection')));

    // act
    final result = await usecase(const DeletePlayerPhotoParams(
      playerId: tPlayerId,
      photoId: tPhotoId,
    ));

    // assert
    expect(result, const Left(NetworkFailure(message: 'No internet connection')));
    verify(mockRepository.deletePlayerPhoto(tPlayerId, tPhotoId));
    verifyNoMoreInteractions(mockRepository);
  });
}
