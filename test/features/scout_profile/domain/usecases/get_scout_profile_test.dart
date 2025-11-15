import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:scoutmena_app/core/error/failures.dart';
import 'package:scoutmena_app/features/scout_profile/domain/entities/scout_profile.dart';
import 'package:scoutmena_app/features/scout_profile/domain/usecases/get_scout_profile.dart';

import '../../../../helpers/test_helpers.mocks.dart';

void main() {
  late GetScoutProfile usecase;
  late MockScoutRepository mockRepository;

  setUp(() {
    mockRepository = MockScoutRepository();
    usecase = GetScoutProfile(mockRepository);
  });

  final tScoutId = 'scout123';
  final tScoutProfile = ScoutProfile(
    id: 'scout123',
    userId: 'user123',
    organizationName: 'Premier League Scouts',
    roleTitle: 'Senior Scout',
    yearsOfExperience: 10,
    countriesOfInterest: ['United Kingdom', 'Spain'],
    positionsOfInterest: ['striker', 'attacking_midfielder'],
    licenseNumber: 'FA-12345',
    verificationDocumentUrl: null,
    verificationStatus: 'approved',
    rejectionReason: null,
    contactEmail: 'scout@premierleague.com',
    contactPhone: '+44123456789',
    website: 'https://plscouts.com',
    linkedinUrl: null,
    instagramHandle: null,
    twitterHandle: null,
    isVerified: true,
    isActive: true,
    profileViews: 150,
    playersSaved: 25,
    searchesSaved: 10,
    createdAt: DateTime(2024, 1, 15),
    updatedAt: DateTime(2024, 3, 20),
    verifiedAt: DateTime(2024, 1, 20),
  );

  final tParams = GetScoutProfileParams(scoutId: tScoutId);

  test('should get scout profile successfully when scout exists', () async {
    // Arrange
    when(mockRepository.getScoutProfile(any))
        .thenAnswer((_) async => Right(tScoutProfile));

    // Act
    final result = await usecase(tParams);

    // Assert
    expect(result, Right(tScoutProfile));
    verify(mockRepository.getScoutProfile(tScoutId));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ValidationFailure when scout ID is invalid', () async {
    // Arrange
    final invalidParams = GetScoutProfileParams(scoutId: '');

    when(mockRepository.getScoutProfile(any))
        .thenAnswer((_) async => Left(ValidationFailure(message: 'Invalid scout ID')));

    // Act
    final result = await usecase(invalidParams);

    // Assert
    expect(result, isA<Left>());
    result.fold(
      (failure) => expect(failure, isA<ValidationFailure>()),
      (_) => fail('Should return ValidationFailure'),
    );
    verify(mockRepository.getScoutProfile(''));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return AuthenticationFailure when user is not authenticated', () async {
    // Arrange
    when(mockRepository.getScoutProfile(any))
        .thenAnswer((_) async => Left(AuthenticationFailure(message: 'User not authenticated')));

    // Act
    final result = await usecase(tParams);

    // Assert
    expect(result, isA<Left>());
    result.fold(
      (failure) => expect(failure, isA<AuthenticationFailure>()),
      (_) => fail('Should return AuthenticationFailure'),
    );
    verify(mockRepository.getScoutProfile(tScoutId));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ServerFailure when scout profile does not exist', () async {
    // Arrange
    when(mockRepository.getScoutProfile(any))
        .thenAnswer((_) async => Left(ServerFailure(message: 'Scout profile not found')));

    // Act
    final result = await usecase(tParams);

    // Assert
    expect(result, isA<Left>());
    result.fold(
      (failure) => expect(failure, isA<ServerFailure>()),
      (_) => fail('Should return ServerFailure'),
    );
    verify(mockRepository.getScoutProfile(tScoutId));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return NetworkFailure when there is no internet connection', () async {
    // Arrange
    when(mockRepository.getScoutProfile(any))
        .thenAnswer((_) async => Left(NetworkFailure(message: 'No internet connection')));

    // Act
    final result = await usecase(tParams);

    // Assert
    expect(result, isA<Left>());
    result.fold(
      (failure) => expect(failure, isA<NetworkFailure>()),
      (_) => fail('Should return NetworkFailure'),
    );
    verify(mockRepository.getScoutProfile(tScoutId));
    verifyNoMoreInteractions(mockRepository);
  });
}
