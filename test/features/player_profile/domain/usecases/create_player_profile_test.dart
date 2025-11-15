import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:scoutmena_app/core/error/failures.dart';
import 'package:scoutmena_app/features/player_profile/domain/entities/player_profile.dart';
import 'package:scoutmena_app/features/player_profile/domain/usecases/create_player_profile.dart';

import '../../../../helpers/test_helpers.mocks.dart';

void main() {
  late CreatePlayerProfile usecase;
  late MockPlayerRepository mockRepository;

  setUp(() {
    mockRepository = MockPlayerRepository();
    usecase = CreatePlayerProfile(mockRepository);
  });

  group('CreatePlayerProfile', () {
    final tPlayerProfile = PlayerProfile(
      id: 'profile123',
      userId: 'user123',
      fullName: 'Ahmed Salem',
      dateOfBirth: DateTime(2004, 1, 1),
      nationality: 'Saudi Arabia',
      height: 180.0,
      weight: 75.0,
      dominantFoot: 'right',
      positions: const ['striker'],
      yearsPlaying: 3,
      isMinor: false,
      parentalConsentGiven: true,
      profileStatus: 'active',
      profileCompleteness: 85,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final tProfileData = {
      'first_name': 'Ahmed',
      'last_name': 'Salem',
      'position': 'striker',
      'date_of_birth': '2004-01-01',
      'weight': 75.0,
      'height': 180.0,
      'country': 'Saudi Arabia',
      'city': 'Riyadh',
      'bio': 'Professional striker',
    };

    test('should create player profile successfully', () async {
      // arrange
      when(mockRepository.createPlayerProfile(any))
          .thenAnswer((_) async => Right(tPlayerProfile));

      // act
      final result = await usecase(CreatePlayerProfileParams(profileData: tProfileData));

      // assert
      expect(result, Right(tPlayerProfile));
      verify(mockRepository.createPlayerProfile(tProfileData));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ValidationFailure when profile data is invalid', () async {
      // arrange
      final tFailure = ValidationFailure(message: 'Missing required fields', errors: {
        'first_name': ['First name is required'],
        'position': ['Position is required'],
      });
      when(mockRepository.createPlayerProfile(any))
          .thenAnswer((_) async => Left(tFailure));

      // act
      final result = await usecase(CreatePlayerProfileParams(profileData: {}));

      // assert
      expect(result, Left(tFailure));
      verify(mockRepository.createPlayerProfile({}));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return AuthenticationFailure when user is not authenticated', () async {
      // arrange
      final tFailure = AuthenticationFailure(message: 'User not authenticated');
      when(mockRepository.createPlayerProfile(any))
          .thenAnswer((_) async => Left(tFailure));

      // act
      final result = await usecase(CreatePlayerProfileParams(profileData: tProfileData));

      // assert
      expect(result, Left(tFailure));
      verify(mockRepository.createPlayerProfile(tProfileData));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when profile creation fails', () async {
      // arrange
      final tFailure = ServerFailure(message: 'Profile already exists');
      when(mockRepository.createPlayerProfile(any))
          .thenAnswer((_) async => Left(tFailure));

      // act
      final result = await usecase(CreatePlayerProfileParams(profileData: tProfileData));

      // assert
      expect(result, Left(tFailure));
      verify(mockRepository.createPlayerProfile(tProfileData));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NetworkFailure when network connection fails', () async {
      // arrange
      final tFailure = NetworkFailure(message: 'No internet connection');
      when(mockRepository.createPlayerProfile(any))
          .thenAnswer((_) async => Left(tFailure));

      // act
      final result = await usecase(CreatePlayerProfileParams(profileData: tProfileData));

      // assert
      expect(result, Left(tFailure));
      verify(mockRepository.createPlayerProfile(tProfileData));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
