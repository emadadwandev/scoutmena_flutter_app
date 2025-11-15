import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:scoutmena_app/core/error/failures.dart';
import 'package:scoutmena_app/features/authentication/domain/usecases/sign_in_with_phone.dart';

import '../../../../helpers/test_helpers.mocks.dart';

void main() {
  late SignInWithPhone usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = SignInWithPhone(mockAuthRepository);
  });

  const tPhoneNumber = '+201234567890';
  const tVerificationId = 'verification123';
  const tParams = SignInWithPhoneParams(phoneNumber: tPhoneNumber);

  group('SignInWithPhone', () {
    test(
      'should return verification ID when phone sign-in is initiated successfully',
      () async {
        // arrange
        when(mockAuthRepository.signInWithPhone(any))
            .thenAnswer((_) async => const Right(tVerificationId));

        // act
        final result = await usecase(tParams);

        // assert
        expect(result, const Right(tVerificationId));
        verify(mockAuthRepository.signInWithPhone(tPhoneNumber));
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );

    test(
      'should return ValidationFailure when phone number is invalid',
      () async {
        // arrange
        const tFailure = ValidationFailure(
          message: 'Invalid phone number format',
          errors: {'phone': ['Phone number must be in E.164 format']},
        );
        when(mockAuthRepository.signInWithPhone(any))
            .thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await usecase(tParams);

        // assert
        expect(result, const Left(tFailure));
        verify(mockAuthRepository.signInWithPhone(tPhoneNumber));
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );

    test(
      'should return AuthenticationFailure when Firebase SMS quota is exceeded',
      () async {
        // arrange
        const tFailure = AuthenticationFailure(
          message: 'SMS quota exceeded. Please try again later.',
        );
        when(mockAuthRepository.signInWithPhone(any))
            .thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await usecase(tParams);

        // assert
        expect(result, const Left(tFailure));
        verify(mockAuthRepository.signInWithPhone(tPhoneNumber));
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
        when(mockAuthRepository.signInWithPhone(any))
            .thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await usecase(tParams);

        // assert
        expect(result, const Left(tFailure));
        verify(mockAuthRepository.signInWithPhone(tPhoneNumber));
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );

    test(
      'should return AuthenticationFailure when phone number is blocked',
      () async {
        // arrange
        const tFailure = AuthenticationFailure(
          message: 'This phone number has been blocked',
        );
        when(mockAuthRepository.signInWithPhone(any))
            .thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await usecase(tParams);

        // assert
        expect(result, const Left(tFailure));
        verify(mockAuthRepository.signInWithPhone(tPhoneNumber));
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );
  });
}
