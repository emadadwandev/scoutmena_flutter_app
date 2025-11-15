import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:scoutmena_app/core/error/failures.dart';
import 'package:scoutmena_app/features/player_profile/domain/entities/player_photo.dart';
import 'package:scoutmena_app/features/player_profile/domain/usecases/upload_player_photo.dart';

import '../../../../helpers/test_helpers.mocks.dart';

void main() {
  late UploadPlayerPhoto usecase;
  late MockPlayerRepository mockRepository;

  setUp(() {
    mockRepository = MockPlayerRepository();
    usecase = UploadPlayerPhoto(mockRepository);
  });

  const tPlayerId = 'player123';
  final tPhotoFile = File('test_photo.jpg');
  const tCaption = 'Training session';
  
  final tPlayerPhoto = PlayerPhoto(
    id: 'photo123',
    playerId: tPlayerId,
    photoUrl: 'https://example.com/photos/photo123.jpg',
    thumbnailUrl: 'https://example.com/photos/photo123_thumb.jpg',
    caption: tCaption,
    isPrimary: false,
    order: 1,
    uploadedAt: DateTime(2024, 6, 20),
  );

  test('should return PlayerPhoto when upload is successful', () async {
    // arrange
    when(mockRepository.uploadPlayerPhoto(
      any,
      any,
      caption: anyNamed('caption'),
      isPrimary: anyNamed('isPrimary'),
    )).thenAnswer((_) async => Right(tPlayerPhoto));

    // act
    final result = await usecase(UploadPlayerPhotoParams(
      playerId: tPlayerId,
      photoFile: tPhotoFile,
      caption: tCaption,
      isPrimary: false,
    ));

    // assert
    expect(result, Right(tPlayerPhoto));
    verify(mockRepository.uploadPlayerPhoto(
      tPlayerId,
      tPhotoFile,
      caption: tCaption,
      isPrimary: false,
    ));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should upload photo as primary when isPrimary is true', () async {
    // arrange
    final tPrimaryPhoto = tPlayerPhoto.copyWith(isPrimary: true);
    when(mockRepository.uploadPlayerPhoto(
      any,
      any,
      caption: anyNamed('caption'),
      isPrimary: anyNamed('isPrimary'),
    )).thenAnswer((_) async => Right(tPrimaryPhoto));

    // act
    final result = await usecase(UploadPlayerPhotoParams(
      playerId: tPlayerId,
      photoFile: tPhotoFile,
      isPrimary: true,
    ));

    // assert
    expect(result, Right(tPrimaryPhoto));
    expect((result as Right<Failure, PlayerPhoto>).value.isPrimary, true);
    verify(mockRepository.uploadPlayerPhoto(
      tPlayerId,
      tPhotoFile,
      caption: null,
      isPrimary: true,
    ));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return FileFailure when file is invalid or corrupted', () async {
    // arrange
    when(mockRepository.uploadPlayerPhoto(
      any,
      any,
      caption: anyNamed('caption'),
      isPrimary: anyNamed('isPrimary'),
    )).thenAnswer((_) async => const Left(FileFailure(message: 'Invalid image file')));

    // act
    final result = await usecase(UploadPlayerPhotoParams(
      playerId: tPlayerId,
      photoFile: tPhotoFile,
    ));

    // assert
    expect(result, const Left(FileFailure(message: 'Invalid image file')));
    verify(mockRepository.uploadPlayerPhoto(
      tPlayerId,
      tPhotoFile,
      caption: null,
      isPrimary: false,
    ));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ValidationFailure when file size exceeds limit', () async {
    // arrange
    when(mockRepository.uploadPlayerPhoto(
      any,
      any,
      caption: anyNamed('caption'),
      isPrimary: anyNamed('isPrimary'),
    )).thenAnswer((_) async => const Left(ValidationFailure(
          message: 'File size exceeds limit',
          errors: {'file': ['Maximum file size is 10MB']},
        )));

    // act
    final result = await usecase(UploadPlayerPhotoParams(
      playerId: tPlayerId,
      photoFile: tPhotoFile,
    ));

    // assert
    expect(
      result,
      const Left(ValidationFailure(
        message: 'File size exceeds limit',
        errors: {'file': ['Maximum file size is 10MB']},
      )),
    );
    verify(mockRepository.uploadPlayerPhoto(
      tPlayerId,
      tPhotoFile,
      caption: null,
      isPrimary: false,
    ));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return AuthenticationFailure when user is not authenticated', () async {
    // arrange
    when(mockRepository.uploadPlayerPhoto(
      any,
      any,
      caption: anyNamed('caption'),
      isPrimary: anyNamed('isPrimary'),
    )).thenAnswer((_) async => const Left(AuthenticationFailure(message: 'Not authenticated')));

    // act
    final result = await usecase(UploadPlayerPhotoParams(
      playerId: tPlayerId,
      photoFile: tPhotoFile,
    ));

    // assert
    expect(result, const Left(AuthenticationFailure(message: 'Not authenticated')));
    verify(mockRepository.uploadPlayerPhoto(
      tPlayerId,
      tPhotoFile,
      caption: null,
      isPrimary: false,
    ));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return NetworkFailure when network error occurs', () async {
    // arrange
    when(mockRepository.uploadPlayerPhoto(
      any,
      any,
      caption: anyNamed('caption'),
      isPrimary: anyNamed('isPrimary'),
    )).thenAnswer((_) async => const Left(NetworkFailure(message: 'No internet connection')));

    // act
    final result = await usecase(UploadPlayerPhotoParams(
      playerId: tPlayerId,
      photoFile: tPhotoFile,
    ));

    // assert
    expect(result, const Left(NetworkFailure(message: 'No internet connection')));
    verify(mockRepository.uploadPlayerPhoto(
      tPlayerId,
      tPhotoFile,
      caption: null,
      isPrimary: false,
    ));
    verifyNoMoreInteractions(mockRepository);
  });
}
