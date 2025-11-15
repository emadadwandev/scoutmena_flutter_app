import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:scoutmena_app/core/error/failures.dart';
import 'package:scoutmena_app/features/player_profile/domain/entities/player_profile.dart';
import 'package:scoutmena_app/features/player_profile/domain/usecases/get_player_profile.dart';

import '../../../../helpers/test_helpers.mocks.dart';

void main() {
  late GetPlayerProfile usecase;
  late MockPlayerRepository mockRepository;

  setUp(() {
    mockRepository = MockPlayerRepository();
    usecase = GetPlayerProfile(mockRepository);
  });

  const tPlayerId = 'player123';
  final tPlayerProfile = PlayerProfile(
    id: tPlayerId,
    userId: 'user123',
    fullName: 'John Doe',
    dateOfBirth: DateTime(2005, 1, 15),
    nationality: 'Egypt',
    height: 175.0,
    weight: 70.0,
    dominantFoot: 'right',
    currentClub: 'Al Ahly Youth',
    positions: ['striker', 'right_winger'],
    jerseyNumber: 10,
    yearsPlaying: 8,
    email: 'john.doe@example.com',
    phoneNumber: '+201234567890',
    instagramHandle: '@johndoe',
    twitterHandle: '@johndoe',
    profilePhotoUrl: 'https://example.com/photo.jpg',
    isMinor: true,
    parentName: 'Jane Doe',
    parentEmail: 'jane.doe@example.com',
    parentPhone: '+201234567891',
    emergencyContact: '+201234567891',
    parentalConsentGiven: true,
    profileStatus: 'active',
    profileCompleteness: 95,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 6, 15),
  );

  test('should return PlayerProfile from repository when successful', () async {
    // arrange
    when(mockRepository.getPlayerProfile(any))
        .thenAnswer((_) async => Right(tPlayerProfile));

    // act
    final result = await usecase(const GetPlayerProfileParams(playerId: tPlayerId));

    // assert
    expect(result, Right(tPlayerProfile));
    verify(mockRepository.getPlayerProfile(tPlayerId));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return AuthenticationFailure when player is not authenticated', () async {
    // arrange
    when(mockRepository.getPlayerProfile(any))
        .thenAnswer((_) async => const Left(AuthenticationFailure(message: 'Not authenticated')));

    // act
    final result = await usecase(const GetPlayerProfileParams(playerId: tPlayerId));

    // assert
    expect(result, const Left(AuthenticationFailure(message: 'Not authenticated')));
    verify(mockRepository.getPlayerProfile(tPlayerId));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ServerFailure when profile not found', () async {
    // arrange
    when(mockRepository.getPlayerProfile(any))
        .thenAnswer((_) async => const Left(ServerFailure(message: 'Player profile not found')));

    // act
    final result = await usecase(const GetPlayerProfileParams(playerId: tPlayerId));

    // assert
    expect(result, const Left(ServerFailure(message: 'Player profile not found')));
    verify(mockRepository.getPlayerProfile(tPlayerId));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return NetworkFailure when network error occurs', () async {
    // arrange
    when(mockRepository.getPlayerProfile(any))
        .thenAnswer((_) async => const Left(NetworkFailure(message: 'No internet connection')));

    // act
    final result = await usecase(const GetPlayerProfileParams(playerId: tPlayerId));

    // assert
    expect(result, const Left(NetworkFailure(message: 'No internet connection')));
    verify(mockRepository.getPlayerProfile(tPlayerId));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return CacheFailure when offline data is not available', () async {
    // arrange
    when(mockRepository.getPlayerProfile(any))
        .thenAnswer((_) async => const Left(CacheFailure(message: 'No cached profile data')));

    // act
    final result = await usecase(const GetPlayerProfileParams(playerId: tPlayerId));

    // assert
    expect(result, const Left(CacheFailure(message: 'No cached profile data')));
    verify(mockRepository.getPlayerProfile(tPlayerId));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ValidationFailure for invalid player ID', () async {
    // arrange
    when(mockRepository.getPlayerProfile(any))
        .thenAnswer((_) async => const Left(ValidationFailure(message: 'Invalid player ID')));

    // act
    final result = await usecase(const GetPlayerProfileParams(playerId: ''));

    // assert
    expect(result, const Left(ValidationFailure(message: 'Invalid player ID')));
    verify(mockRepository.getPlayerProfile(''));
    verifyNoMoreInteractions(mockRepository);
  });
}
