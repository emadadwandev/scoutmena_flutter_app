import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:scoutmena_app/core/error/failures.dart';
import 'package:scoutmena_app/features/authentication/domain/entities/user.dart';
import 'package:scoutmena_app/features/authentication/domain/usecases/register_user.dart';

import '../../../../helpers/test_helpers.mocks.dart';

void main() {
  late RegisterUser usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = RegisterUser(mockAuthRepository);
  });

  const tFirebaseUid = 'firebase123';
  final tUserData = {
    'name': 'Mohamed Salah',
    'phone': '+201234567890',
    'account_type': 'player',
    'country': 'Egypt',
  };

  final tUser = UserEntity(
    id: '123',
    firebaseUid: tFirebaseUid,
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

  final tParams = RegisterUserParams(
    firebaseUid: tFirebaseUid,
    userData: tUserData,
  );

  group('RegisterUser', () {
    test(
      'should return UserEntity when user registration is successful',
      () async {
        // arrange
        when(mockAuthRepository.register(
          firebaseUid: anyNamed('firebaseUid'),
          userData: anyNamed('userData'),
        )).thenAnswer((_) async => Right(tUser));

        // act
        final result = await usecase(tParams);

        // assert
        expect(result, Right(tUser));
        verify(mockAuthRepository.register(
          firebaseUid: tFirebaseUid,
          userData: tUserData,
        ));
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );

    test(
      'should return ValidationFailure when required fields are missing',
      () async {
        // arrange
        const tFailure = ValidationFailure(
          message: 'Validation failed',
          errors: {
            'name': ['Name is required'],
            'phone': ['Phone number is required'],
          },
        );
        when(mockAuthRepository.register(
          firebaseUid: anyNamed('firebaseUid'),
          userData: anyNamed('userData'),
        )).thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await usecase(tParams);

        // assert
        expect(result, const Left(tFailure));
        verify(mockAuthRepository.register(
          firebaseUid: tFirebaseUid,
          userData: tUserData,
        ));
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );

    test(
      'should return ValidationFailure when phone number already exists',
      () async {
        // arrange
        const tFailure = ValidationFailure(
          message: 'Phone number already registered',
          errors: {
            'phone': ['This phone number is already in use'],
          },
        );
        when(mockAuthRepository.register(
          firebaseUid: anyNamed('firebaseUid'),
          userData: anyNamed('userData'),
        )).thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await usecase(tParams);

        // assert
        expect(result, const Left(tFailure));
        verify(mockAuthRepository.register(
          firebaseUid: tFirebaseUid,
          userData: tUserData,
        ));
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );

    test(
      'should return AuthenticationFailure when Firebase UID is invalid',
      () async {
        // arrange
        const tFailure = AuthenticationFailure(
          message: 'Invalid Firebase user ID',
        );
        when(mockAuthRepository.register(
          firebaseUid: anyNamed('firebaseUid'),
          userData: anyNamed('userData'),
        )).thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await usecase(tParams);

        // assert
        expect(result, const Left(tFailure));
        verify(mockAuthRepository.register(
          firebaseUid: tFirebaseUid,
          userData: tUserData,
        ));
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );

    test(
      'should return ServerFailure when API call fails',
      () async {
        // arrange
        const tFailure = ServerFailure(
          message: 'Server error occurred',
        );
        when(mockAuthRepository.register(
          firebaseUid: anyNamed('firebaseUid'),
          userData: anyNamed('userData'),
        )).thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await usecase(tParams);

        // assert
        expect(result, const Left(tFailure));
        verify(mockAuthRepository.register(
          firebaseUid: tFirebaseUid,
          userData: tUserData,
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
        when(mockAuthRepository.register(
          firebaseUid: anyNamed('firebaseUid'),
          userData: anyNamed('userData'),
        )).thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await usecase(tParams);

        // assert
        expect(result, const Left(tFailure));
        verify(mockAuthRepository.register(
          firebaseUid: tFirebaseUid,
          userData: tUserData,
        ));
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );
  });
}
