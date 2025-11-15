import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:scoutmena_app/core/error/failures.dart';
import 'package:scoutmena_app/features/authentication/domain/usecases/verify_otp.dart';

import '../../../../helpers/test_helpers.mocks.dart';

void main() {
  late VerifyOTP usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = VerifyOTP(mockAuthRepository);
  });

  const tVerificationId = 'verification123';
  const tOtp = '123456';
  const tParams = VerifyOTPParams(
    verificationId: tVerificationId,
    otp: tOtp,
  );

  group('VerifyOTP', () {
    test(
      'should return Firebase User when OTP verification is successful',
      () async {
        // arrange
        final tFirebaseUser = MockFirebaseUser();
        when(mockAuthRepository.verifyOTP(
          verificationId: anyNamed('verificationId'),
          otp: anyNamed('otp'),
        )).thenAnswer((_) async => Right(tFirebaseUser));

        // act
        final result = await usecase(tParams);

        // assert
        expect(result, Right(tFirebaseUser));
        verify(mockAuthRepository.verifyOTP(
          verificationId: tVerificationId,
          otp: tOtp,
        ));
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );

    test(
      'should return AuthenticationFailure when OTP is invalid',
      () async {
        // arrange
        const tFailure = AuthenticationFailure(
          message: 'Invalid OTP code',
        );
        when(mockAuthRepository.verifyOTP(
          verificationId: anyNamed('verificationId'),
          otp: anyNamed('otp'),
        )).thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await usecase(tParams);

        // assert
        expect(result, const Left(tFailure));
        verify(mockAuthRepository.verifyOTP(
          verificationId: tVerificationId,
          otp: tOtp,
        ));
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );

    test(
      'should return AuthenticationFailure when verification ID is expired',
      () async {
        // arrange
        const tFailure = AuthenticationFailure(
          message: 'Verification code expired',
        );
        when(mockAuthRepository.verifyOTP(
          verificationId: anyNamed('verificationId'),
          otp: anyNamed('otp'),
        )).thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await usecase(tParams);

        // assert
        expect(result, const Left(tFailure));
        verify(mockAuthRepository.verifyOTP(
          verificationId: tVerificationId,
          otp: tOtp,
        ));
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
        when(mockAuthRepository.verifyOTP(
          verificationId: anyNamed('verificationId'),
          otp: anyNamed('otp'),
        )).thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await usecase(tParams);

        // assert
        expect(result, const Left(tFailure));
        verify(mockAuthRepository.verifyOTP(
          verificationId: tVerificationId,
          otp: tOtp,
        ));
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );
  });
}

// Mock Firebase User for testing
class MockFirebaseUser extends Mock implements firebase_auth.User {}
