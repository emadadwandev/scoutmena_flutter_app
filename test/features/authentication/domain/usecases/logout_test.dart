import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:scoutmena_app/core/error/failures.dart';
import 'package:scoutmena_app/features/authentication/domain/usecases/logout.dart';
import 'package:scoutmena_app/features/authentication/domain/usecases/usecase.dart';

import '../../../../helpers/test_helpers.mocks.dart';

void main() {
  late Logout usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = Logout(mockAuthRepository);
  });

  group('Logout', () {
    test(
      'should return void when logout is successful',
      () async {
        // arrange
        when(mockAuthRepository.logout())
            .thenAnswer((_) async => const Right(null));

        // act
        final result = await usecase(NoParams());

        // assert
        expect(result, const Right(null));
        verify(mockAuthRepository.logout());
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );

    test(
      'should clear local cache even if Firebase logout fails',
      () async {
        // arrange
        when(mockAuthRepository.logout())
            .thenAnswer((_) async => const Right(null));

        // act
        final result = await usecase(NoParams());

        // assert
        expect(result, const Right(null));
        verify(mockAuthRepository.logout());
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );

    test(
      'should return CacheFailure when clearing local storage fails',
      () async {
        // arrange
        const tFailure = CacheFailure(
          message: 'Failed to clear cached data',
        );
        when(mockAuthRepository.logout())
            .thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await usecase(NoParams());

        // assert
        expect(result, const Left(tFailure));
        verify(mockAuthRepository.logout());
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );

    test(
      'should return AuthenticationFailure when Firebase sign-out fails',
      () async {
        // arrange
        const tFailure = AuthenticationFailure(
          message: 'Failed to sign out from Firebase',
        );
        when(mockAuthRepository.logout())
            .thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await usecase(NoParams());

        // assert
        expect(result, const Left(tFailure));
        verify(mockAuthRepository.logout());
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );

    test(
      'should handle logout when user is already logged out',
      () async {
        // arrange
        when(mockAuthRepository.logout())
            .thenAnswer((_) async => const Right(null));

        // act
        final result = await usecase(NoParams());

        // assert
        expect(result, const Right(null));
        verify(mockAuthRepository.logout());
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );
  });
}
