import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:scoutmena_app/core/error/failures.dart';
import 'package:scoutmena_app/features/scout_profile/domain/entities/scout_profile.dart';
import 'package:scoutmena_app/features/scout_profile/domain/usecases/create_scout_profile.dart';

import '../../../../helpers/test_helpers.mocks.dart';

void main() {
  late CreateScoutProfile usecase;
  late MockScoutRepository mockRepository;

  setUp(() {
    mockRepository = MockScoutRepository();
    usecase = CreateScoutProfile(mockRepository);
  });

  final tProfileData = {
    'organization_name': 'Premier League Scouts',
    'role_title': 'Senior Scout',
    'years_of_experience': 10,
    'countries_of_interest': ['United Kingdom', 'Spain'],
    'positions_of_interest': ['striker', 'attacking_midfielder'],
    'license_number': 'FA-12345',
    'contact_email': 'scout@premierleague.com',
  };

  final tScoutProfile = ScoutProfile(
    id: '1',
    userId: 'user123',
    organizationName: 'Premier League Scouts',
    roleTitle: 'Senior Scout',
    yearsOfExperience: 10,
    countriesOfInterest: ['United Kingdom', 'Spain'],
    positionsOfInterest: ['striker', 'attacking_midfielder'],
    licenseNumber: 'FA-12345',
    verificationDocumentUrl: null,
    verificationStatus: 'pending',
    rejectionReason: null,
    contactEmail: 'scout@premierleague.com',
    contactPhone: null,
    website: null,
    linkedinUrl: null,
    instagramHandle: null,
    twitterHandle: null,
    isVerified: false,
    isActive: true,
    profileViews: 0,
    playersSaved: 0,
    searchesSaved: 0,
    createdAt: DateTime(2024, 1, 15),
    updatedAt: DateTime(2024, 1, 15),
    verifiedAt: null,
  );

  final tParams = CreateScoutProfileParams(profileData: tProfileData);

  test('should create scout profile successfully when data is valid', () async {
    // Arrange
    when(mockRepository.createScoutProfile(any))
        .thenAnswer((_) async => Right(tScoutProfile));

    // Act
    final result = await usecase(tParams);

    // Assert
    expect(result, Right(tScoutProfile));
    verify(mockRepository.createScoutProfile(tProfileData));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ValidationFailure when required fields are missing', () async {
    // Arrange
    final invalidData = {
      'organization_name': '', // Empty required field
      'role_title': 'Scout',
    };
    final invalidParams = CreateScoutProfileParams(profileData: invalidData);

    when(mockRepository.createScoutProfile(any))
        .thenAnswer((_) async => Left(ValidationFailure(message: 'Organization name is required')));

    // Act
    final result = await usecase(invalidParams);

    // Assert
    expect(result, isA<Left>());
    result.fold(
      (failure) => expect(failure, isA<ValidationFailure>()),
      (_) => fail('Should return ValidationFailure'),
    );
    verify(mockRepository.createScoutProfile(invalidData));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return AuthenticationFailure when user is not authenticated', () async {
    // Arrange
    when(mockRepository.createScoutProfile(any))
        .thenAnswer((_) async => Left(AuthenticationFailure(message: 'User not authenticated')));

    // Act
    final result = await usecase(tParams);

    // Assert
    expect(result, isA<Left>());
    result.fold(
      (failure) => expect(failure, isA<AuthenticationFailure>()),
      (_) => fail('Should return AuthenticationFailure'),
    );
    verify(mockRepository.createScoutProfile(tProfileData));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ServerFailure when scout profile already exists', () async {
    // Arrange
    when(mockRepository.createScoutProfile(any))
        .thenAnswer((_) async => Left(ServerFailure(message: 'Scout profile already exists')));

    // Act
    final result = await usecase(tParams);

    // Assert
    expect(result, isA<Left>());
    result.fold(
      (failure) => expect(failure, isA<ServerFailure>()),
      (_) => fail('Should return ServerFailure'),
    );
    verify(mockRepository.createScoutProfile(tProfileData));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return NetworkFailure when there is no internet connection', () async {
    // Arrange
    when(mockRepository.createScoutProfile(any))
        .thenAnswer((_) async => Left(NetworkFailure(message: 'No internet connection')));

    // Act
    final result = await usecase(tParams);

    // Assert
    expect(result, isA<Left>());
    result.fold(
      (failure) => expect(failure, isA<NetworkFailure>()),
      (_) => fail('Should return NetworkFailure'),
    );
    verify(mockRepository.createScoutProfile(tProfileData));
    verifyNoMoreInteractions(mockRepository);
  });
}
