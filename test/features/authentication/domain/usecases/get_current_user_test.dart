import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:scoutmena_app/core/error/failures.dart';
import 'package:scoutmena_app/features/authentication/domain/entities/user.dart';
import 'package:scoutmena_app/features/authentication/domain/usecases/get_current_user.dart';
import 'package:scoutmena_app/features/authentication/domain/usecases/usecase.dart';

import '../../../../helpers/test_helpers.mocks.dart';

void main() {
  late GetCurrentUser usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = GetCurrentUser(mockAuthRepository);
  });

  final tUser = UserEntity(
    id: '123',
    firebaseUid: 'firebase123',
    name: 'Mohamed Salah',
    phone: '+201234567890',
    accountType: 'player',
    country: 'Egypt',
    isActive: true,
    emailVerified: false,
    phoneVerified: true,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  group('GetCurrentUser', () {
    test(
      'should return UserEntity when user is authenticated',
      () async {
        // arrange
        when(mockAuthRepository.getCurrentUser())
            .thenAnswer((_) async => Right(tUser));

        // act
        final result = await usecase(NoParams());

        // assert
        expect(result, Right(tUser));
        verify(mockAuthRepository.getCurrentUser());
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );

    test(
      'should return AuthenticationFailure when user is not authenticated',
      () async {
        // arrange
        const tFailure = AuthenticationFailure(
          message: 'User not authenticated',
        );
        when(mockAuthRepository.getCurrentUser())
            .thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await usecase(NoParams());

        // assert
        expect(result, const Left(tFailure));
        verify(mockAuthRepository.getCurrentUser());
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );

    test(
      'should return AuthenticationFailure when token is expired',
      () async {
        // arrange
        const tFailure = AuthenticationFailure(
          message: 'Authentication token expired',
        );
        when(mockAuthRepository.getCurrentUser())
            .thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await usecase(NoParams());

        // assert
        expect(result, const Left(tFailure));
        verify(mockAuthRepository.getCurrentUser());
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );

    test(
      'should return CacheFailure when user data is not cached',
      () async {
        // arrange
        const tFailure = CacheFailure(
          message: 'No cached user data found',
        );
        when(mockAuthRepository.getCurrentUser())
            .thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await usecase(NoParams());

        // assert
        expect(result, const Left(tFailure));
        verify(mockAuthRepository.getCurrentUser());
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );

    test(
      'should return NetworkFailure when there is no internet connection',
      () async {
        // arrange
        const tFailure = NetworkFailure(
          message: 'No internet connection',
        );
        when(mockAuthRepository.getCurrentUser())
            .thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await usecase(NoParams());

        // assert
        expect(result, const Left(tFailure));
        verify(mockAuthRepository.getCurrentUser());
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );

    test(
      'should return ServerFailure when API call fails',
      () async {
        // arrange
        const tFailure = ServerFailure(
          message: 'Failed to fetch user data',
        );
        when(mockAuthRepository.getCurrentUser())
            .thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await usecase(NoParams());

        // assert
        expect(result, const Left(tFailure));
        verify(mockAuthRepository.getCurrentUser());
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );
  });
}
