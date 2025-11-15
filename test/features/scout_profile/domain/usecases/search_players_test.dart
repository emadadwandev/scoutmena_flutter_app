import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:scoutmena_app/core/error/failures.dart';
import 'package:scoutmena_app/features/scout_profile/domain/entities/search_filters.dart';
import 'package:scoutmena_app/features/scout_profile/domain/entities/search_results.dart';
import 'package:scoutmena_app/features/scout_profile/domain/usecases/search_players.dart';

import '../../../../helpers/test_helpers.mocks.dart';

void main() {
  late SearchPlayers usecase;
  late MockScoutRepository mockRepository;

  setUp(() {
    mockRepository = MockScoutRepository();
    usecase = SearchPlayers(mockRepository);
  });

  final tFilters = SearchFilters(
    positions: ['striker', 'winger'],
    minAge: 16,
    maxAge: 23,
    countries: ['United Kingdom', 'Spain'],
    sortBy: 'recent',
    sortOrder: 'desc',
  );

  final tSearchResults = SearchResults.empty();

  final tParams = SearchPlayersParams(
    filters: tFilters,
    page: 1,
  );

  test('should search players successfully with filters', () async {
    // Arrange
    when(mockRepository.searchPlayers(any, any))
        .thenAnswer((_) async => Right(tSearchResults));

    // Act
    final result = await usecase(tParams);

    // Assert
    expect(result, Right(tSearchResults));
    verify(mockRepository.searchPlayers(tFilters, 1));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ValidationFailure when filters are invalid', () async {
    // Arrange
    final invalidFilters = SearchFilters(
      minAge: 30,
      maxAge: 15, // maxAge < minAge is invalid
    );
    final invalidParams = SearchPlayersParams(filters: invalidFilters);

    when(mockRepository.searchPlayers(any, any))
        .thenAnswer((_) async => Left(ValidationFailure(message: 'Max age must be greater than min age')));

    // Act
    final result = await usecase(invalidParams);

    // Assert
    expect(result, isA<Left>());
    result.fold(
      (failure) => expect(failure, isA<ValidationFailure>()),
      (_) => fail('Should return ValidationFailure'),
    );
    verify(mockRepository.searchPlayers(invalidFilters, 1));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return AuthenticationFailure when user is not authenticated', () async {
    // Arrange
    when(mockRepository.searchPlayers(any, any))
        .thenAnswer((_) async => Left(AuthenticationFailure(message: 'User not authenticated')));

    // Act
    final result = await usecase(tParams);

    // Assert
    expect(result, isA<Left>());
    result.fold(
      (failure) => expect(failure, isA<AuthenticationFailure>()),
      (_) => fail('Should return AuthenticationFailure'),
    );
    verify(mockRepository.searchPlayers(tFilters, 1));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ServerFailure when search operation fails', () async {
    // Arrange
    when(mockRepository.searchPlayers(any, any))
        .thenAnswer((_) async => Left(ServerFailure(message: 'Search service unavailable')));

    // Act
    final result = await usecase(tParams);

    // Assert
    expect(result, isA<Left>());
    result.fold(
      (failure) => expect(failure, isA<ServerFailure>()),
      (_) => fail('Should return ServerFailure'),
    );
    verify(mockRepository.searchPlayers(tFilters, 1));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return NetworkFailure when there is no internet connection', () async {
    // Arrange
    when(mockRepository.searchPlayers(any, any))
        .thenAnswer((_) async => Left(NetworkFailure(message: 'No internet connection')));

    // Act
    final result = await usecase(tParams);

    // Assert
    expect(result, isA<Left>());
    result.fold(
      (failure) => expect(failure, isA<NetworkFailure>()),
      (_) => fail('Should return NetworkFailure'),
    );
    verify(mockRepository.searchPlayers(tFilters, 1));
    verifyNoMoreInteractions(mockRepository);
  });
}
