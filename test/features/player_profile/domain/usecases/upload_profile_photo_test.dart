import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:scoutmena_app/core/error/failures.dart';
import 'package:scoutmena_app/features/player_profile/domain/usecases/upload_profile_photo.dart';

import '../../../../helpers/test_helpers.mocks.dart';

void main() {
  late UploadProfilePhoto usecase;
  late MockPlayerRepository mockRepository;

  setUp(() {
    mockRepository = MockPlayerRepository();
    usecase = UploadProfilePhoto(mockRepository);
  });

  group('UploadProfilePhoto', () {
    const tPlayerId = 'player123';
    final tPhotoFile = File('test/fixtures/profile.jpg');
    const tPhotoUrl = 'https://storage.example.com/profiles/profile123.jpg';

    test('should upload profile photo successfully and return URL', () async {
      // arrange
      when(mockRepository.uploadProfilePhoto(any, any))
          .thenAnswer((_) async => const Right(tPhotoUrl));

      // act
      final result = await usecase(UploadProfilePhotoParams(
        playerId: tPlayerId,
        photoFile: tPhotoFile,
      ));

      // assert
      expect(result, const Right(tPhotoUrl));
      verify(mockRepository.uploadProfilePhoto(tPlayerId, tPhotoFile));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ValidationFailure when photo file is invalid', () async {
      // arrange
      final tFailure = ValidationFailure(message: 'Invalid photo file', errors: {
        'photo_file': ['File format not supported'],
      });
      when(mockRepository.uploadProfilePhoto(any, any))
          .thenAnswer((_) async => Left(tFailure));

      // act
      final result = await usecase(UploadProfilePhotoParams(
        playerId: tPlayerId,
        photoFile: tPhotoFile,
      ));

      // assert
      expect(result, Left(tFailure));
      verify(mockRepository.uploadProfilePhoto(tPlayerId, tPhotoFile));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return AuthenticationFailure when user is not authenticated', () async {
      // arrange
      final tFailure = AuthenticationFailure(message: 'User not authenticated');
      when(mockRepository.uploadProfilePhoto(any, any))
          .thenAnswer((_) async => Left(tFailure));

      // act
      final result = await usecase(UploadProfilePhotoParams(
        playerId: tPlayerId,
        photoFile: tPhotoFile,
      ));

      // assert
      expect(result, Left(tFailure));
      verify(mockRepository.uploadProfilePhoto(tPlayerId, tPhotoFile));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when upload fails', () async {
      // arrange
      final tFailure = ServerFailure(message: 'Photo upload failed');
      when(mockRepository.uploadProfilePhoto(any, any))
          .thenAnswer((_) async => Left(tFailure));

      // act
      final result = await usecase(UploadProfilePhotoParams(
        playerId: tPlayerId,
        photoFile: tPhotoFile,
      ));

      // assert
      expect(result, Left(tFailure));
      verify(mockRepository.uploadProfilePhoto(tPlayerId, tPhotoFile));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NetworkFailure when network connection fails', () async {
      // arrange
      final tFailure = NetworkFailure(message: 'No internet connection');
      when(mockRepository.uploadProfilePhoto(any, any))
          .thenAnswer((_) async => Left(tFailure));

      // act
      final result = await usecase(UploadProfilePhotoParams(
        playerId: tPlayerId,
        photoFile: tPhotoFile,
      ));

      // assert
      expect(result, Left(tFailure));
      verify(mockRepository.uploadProfilePhoto(tPlayerId, tPhotoFile));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
