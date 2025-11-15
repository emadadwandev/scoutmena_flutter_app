import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:scoutmena_app/core/error/failures.dart';
import 'package:scoutmena_app/features/player_profile/domain/entities/player_profile.dart';
import 'package:scoutmena_app/features/player_profile/domain/usecases/update_player_profile.dart';

import '../../../../helpers/test_helpers.mocks.dart';

void main() {
  late UpdatePlayerProfile usecase;
  late MockPlayerRepository mockRepository;

  setUp(() {
    mockRepository = MockPlayerRepository();
    usecase = UpdatePlayerProfile(mockRepository);
  });

  const tPlayerId = 'player123';
  final tProfileData = {
    'height': 180.0,
    'weight': 75.0,
    'current_club': 'New Club FC',
    'positions': ['striker'],
  };

  final tUpdatedProfile = PlayerProfile(
    id: tPlayerId,
    userId: 'user123',
    fullName: 'John Doe',
    dateOfBirth: DateTime(2005, 1, 15),
    nationality: 'Egypt',
    height: 180.0, // updated
    weight: 75.0, // updated
    dominantFoot: 'right',
    currentClub: 'New Club FC', // updated
    positions: ['striker'],
    jerseyNumber: 10,
    yearsPlaying: 8,
    isMinor: true,
    parentalConsentGiven: true,
    profileStatus: 'active',
    profileCompleteness: 98,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 6, 20), // updated
  );

  test('should return updated PlayerProfile when update is successful', () async {
    // arrange
    when(mockRepository.updatePlayerProfile(any, any))
        .thenAnswer((_) async => Right(tUpdatedProfile));

    // act
    final result = await usecase(UpdatePlayerProfileParams(
      playerId: tPlayerId,
      profileData: tProfileData,
    ));

    // assert
    expect(result, Right(tUpdatedProfile));
    verify(mockRepository.updatePlayerProfile(tPlayerId, tProfileData));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ValidationFailure when profile data is invalid', () async {
    // arrange
    when(mockRepository.updatePlayerProfile(any, any))
        .thenAnswer((_) async => const Left(ValidationFailure(
              message: 'Invalid profile data',
              errors: {'height': ['Height must be between 140 and 220 cm']},
            )));

    // act
    final result = await usecase(UpdatePlayerProfileParams(
      playerId: tPlayerId,
      profileData: {'height': 300.0}, // invalid height
    ));

    // assert
    expect(
      result,
      const Left(ValidationFailure(
        message: 'Invalid profile data',
        errors: {'height': ['Height must be between 140 and 220 cm']},
      )),
    );
    verify(mockRepository.updatePlayerProfile(tPlayerId, {'height': 300.0}));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return AuthenticationFailure when user is not authenticated', () async {
    // arrange
    when(mockRepository.updatePlayerProfile(any, any))
        .thenAnswer((_) async => const Left(AuthenticationFailure(message: 'Not authenticated')));

    // act
    final result = await usecase(UpdatePlayerProfileParams(
      playerId: tPlayerId,
      profileData: tProfileData,
    ));

    // assert
    expect(result, const Left(AuthenticationFailure(message: 'Not authenticated')));
    verify(mockRepository.updatePlayerProfile(tPlayerId, tProfileData));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ServerFailure when profile not found', () async {
    // arrange
    when(mockRepository.updatePlayerProfile(any, any))
        .thenAnswer((_) async => const Left(ServerFailure(message: 'Profile not found')));

    // act
    final result = await usecase(UpdatePlayerProfileParams(
      playerId: 'invalid_id',
      profileData: tProfileData,
    ));

    // assert
    expect(result, const Left(ServerFailure(message: 'Profile not found')));
    verify(mockRepository.updatePlayerProfile('invalid_id', tProfileData));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return PermissionFailure when user lacks permission to update profile', () async {
    // arrange
    when(mockRepository.updatePlayerProfile(any, any))
        .thenAnswer((_) async =>
            const Left(PermissionFailure(message: 'You do not have permission to update this profile')));

    // act
    final result = await usecase(UpdatePlayerProfileParams(
      playerId: tPlayerId,
      profileData: tProfileData,
    ));

    // assert
    expect(result, const Left(PermissionFailure(message: 'You do not have permission to update this profile')));
    verify(mockRepository.updatePlayerProfile(tPlayerId, tProfileData));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return NetworkFailure when network error occurs', () async {
    // arrange
    when(mockRepository.updatePlayerProfile(any, any))
        .thenAnswer((_) async => const Left(NetworkFailure(message: 'No internet connection')));

    // act
    final result = await usecase(UpdatePlayerProfileParams(
      playerId: tPlayerId,
      profileData: tProfileData,
    ));

    // assert
    expect(result, const Left(NetworkFailure(message: 'No internet connection')));
    verify(mockRepository.updatePlayerProfile(tPlayerId, tProfileData));
    verifyNoMoreInteractions(mockRepository);
  });
}
