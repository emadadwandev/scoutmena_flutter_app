import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:scoutmena_app/core/error/failures.dart';
import 'package:scoutmena_app/features/authentication/domain/entities/user.dart';
import 'package:scoutmena_app/features/authentication/domain/usecases/login_with_firebase.dart';
import 'package:scoutmena_app/features/authentication/domain/usecases/usecase.dart';

import '../../../../helpers/test_helpers.mocks.dart';

void main() {
  late LoginWithFirebase usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = LoginWithFirebase(mockAuthRepository);
  });

  final tUser = UserEntity(
    id: '123',
    firebaseUid: 'firebase123',
    name: 'Test User',
    phone: '+201234567890',
    accountType: 'player',
    isActive: true,
    emailVerified: false,
    phoneVerified: true,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  group('LoginWithFirebase', () {
    test(
      'should return UserEntity when login is successful',
      () async {
        // arrange
        when(mockAuthRepository.loginWithFirebase())
            .thenAnswer((_) async => Right(tUser));

        // act
        final result = await usecase(NoParams());

        // assert
        expect(result, Right(tUser));
        verify(mockAuthRepository.loginWithFirebase());
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );

    test(
      'should return AuthenticationFailure when login fails',
      () async {
        // arrange
        const tFailure = AuthenticationFailure(
          message: 'Authentication failed',
        );
        when(mockAuthRepository.loginWithFirebase())
            .thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await usecase(NoParams());

        // assert
        expect(result, const Left(tFailure));
        verify(mockAuthRepository.loginWithFirebase());
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
        when(mockAuthRepository.loginWithFirebase())
            .thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await usecase(NoParams());

        // assert
        expect(result, const Left(tFailure));
        verify(mockAuthRepository.loginWithFirebase());
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );
  });
}
