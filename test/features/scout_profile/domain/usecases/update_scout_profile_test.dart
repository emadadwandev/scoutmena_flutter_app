import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:scoutmena_app/core/error/failures.dart';
import 'package:scoutmena_app/features/scout_profile/domain/entities/scout_profile.dart';
import 'package:scoutmena_app/features/scout_profile/domain/usecases/update_scout_profile.dart';

import '../../../../helpers/test_helpers.mocks.dart';

void main() {
  late UpdateScoutProfile usecase;
  late MockScoutRepository mockRepository;

  setUp(() {
    mockRepository = MockScoutRepository();
    usecase = UpdateScoutProfile(mockRepository);
  });

  final tScoutId = 'scout123';
  final tProfileData = {
    'role_title': 'Head Scout',
    'years_of_experience': 15,
    'website': 'https://newscoutspage.com',
  };

  final tUpdatedProfile = ScoutProfile(
    id: 'scout123',
    userId: 'user123',
    organizationName: 'Premier League Scouts',
    roleTitle: 'Head Scout',
    yearsOfExperience: 15,
    countriesOfInterest: ['United Kingdom', 'Spain', 'Germany'],
    positionsOfInterest: ['striker', 'attacking_midfielder'],
    licenseNumber: 'FA-12345',
    verificationDocumentUrl: null,
    verificationStatus: 'approved',
    rejectionReason: null,
    contactEmail: 'scout@premierleague.com',
    contactPhone: '+44123456789',
    website: 'https://newscoutspage.com',
    linkedinUrl: null,
    instagramHandle: null,
    twitterHandle: null,
    isVerified: true,
    isActive: true,
    profileViews: 200,
    playersSaved: 30,
    searchesSaved: 12,
    createdAt: DateTime(2024, 1, 15),
    updatedAt: DateTime(2024, 4, 10),
    verifiedAt: DateTime(2024, 1, 20),
  );

  final tParams = UpdateScoutProfileParams(
    scoutId: tScoutId,
    profileData: tProfileData,
  );

  test('should update scout profile successfully when data is valid', () async {
    // Arrange
    when(mockRepository.updateScoutProfile(any, any))
        .thenAnswer((_) async => Right(tUpdatedProfile));

    // Act
    final result = await usecase(tParams);

    // Assert
    expect(result, Right(tUpdatedProfile));
    verify(mockRepository.updateScoutProfile(tScoutId, tProfileData));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ValidationFailure when data is invalid', () async {
    // Arrange
    final invalidData = {
      'years_of_experience': -5, // Negative value not allowed
    };
    final invalidParams = UpdateScoutProfileParams(
      scoutId: tScoutId,
      profileData: invalidData,
    );

    when(mockRepository.updateScoutProfile(any, any))
        .thenAnswer((_) async => Left(ValidationFailure(message: 'Years of experience cannot be negative')));

    // Act
    final result = await usecase(invalidParams);

    // Assert
    expect(result, isA<Left>());
    result.fold(
      (failure) => expect(failure, isA<ValidationFailure>()),
      (_) => fail('Should return ValidationFailure'),
    );
    verify(mockRepository.updateScoutProfile(tScoutId, invalidData));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return AuthenticationFailure when user is not authenticated', () async {
    // Arrange
    when(mockRepository.updateScoutProfile(any, any))
        .thenAnswer((_) async => Left(AuthenticationFailure(message: 'User not authenticated')));

    // Act
    final result = await usecase(tParams);

    // Assert
    expect(result, isA<Left>());
    result.fold(
      (failure) => expect(failure, isA<AuthenticationFailure>()),
      (_) => fail('Should return AuthenticationFailure'),
    );
    verify(mockRepository.updateScoutProfile(tScoutId, tProfileData));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ServerFailure when profile does not exist', () async {
    // Arrange
    when(mockRepository.updateScoutProfile(any, any))
        .thenAnswer((_) async => Left(ServerFailure(message: 'Scout profile not found')));

    // Act
    final result = await usecase(tParams);

    // Assert
    expect(result, isA<Left>());
    result.fold(
      (failure) => expect(failure, isA<ServerFailure>()),
      (_) => fail('Should return ServerFailure'),
    );
    verify(mockRepository.updateScoutProfile(tScoutId, tProfileData));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return NetworkFailure when there is no internet connection', () async {
    // Arrange
    when(mockRepository.updateScoutProfile(any, any))
        .thenAnswer((_) async => Left(NetworkFailure(message: 'No internet connection')));

    // Act
    final result = await usecase(tParams);

    // Assert
    expect(result, isA<Left>());
    result.fold(
      (failure) => expect(failure, isA<NetworkFailure>()),
      (_) => fail('Should return NetworkFailure'),
    );
    verify(mockRepository.updateScoutProfile(tScoutId, tProfileData));
    verifyNoMoreInteractions(mockRepository);
  });
}
