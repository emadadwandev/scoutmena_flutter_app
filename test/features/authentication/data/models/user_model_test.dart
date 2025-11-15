import 'package:flutter_test/flutter_test.dart';
import 'package:scoutmena_app/features/authentication/data/models/user_model.dart';
import 'package:scoutmena_app/features/authentication/domain/entities/user.dart';

void main() {
  final tUserModel = UserModel(
    id: '123',
    firebaseUid: 'firebase123',
    name: 'Mohamed Salah',
    email: 'salah@example.com',
    phone: '+201234567890',
    accountType: 'player',
    dateOfBirth: '1992-06-15',
    country: 'Egypt',
    profilePhotoUrl: 'https://example.com/photo.jpg',
    isActive: true,
    emailVerified: true,
    phoneVerified: true,
    createdAt: DateTime(2024, 1, 1, 10, 30),
    updatedAt: DateTime(2024, 1, 2, 15, 45),
  );

  final tJson = {
    'id': '123',
    'firebase_uid': 'firebase123',
    'name': 'Mohamed Salah',
    'email': 'salah@example.com',
    'phone': '+201234567890',
    'account_type': 'player',
    'date_of_birth': '1992-06-15',
    'country': 'Egypt',
    'profile_photo_url': 'https://example.com/photo.jpg',
    'is_active': true,
    'email_verified': true,
    'phone_verified': true,
    'created_at': '2024-01-01T10:30:00.000',
    'updated_at': '2024-01-02T15:45:00.000',
  };

  group('UserModel', () {
    group('fromJson', () {
      test('should return valid UserModel from JSON', () {
        // act
        final result = UserModel.fromJson(tJson);

        // assert
        expect(result, equals(tUserModel));
      });

      test('should handle boolean values as integers (1/0)', () {
        // arrange
        final jsonWithIntegers = {
          ...tJson,
          'is_active': 1,
          'email_verified': 1,
          'phone_verified': 1,
        };

        // act
        final result = UserModel.fromJson(jsonWithIntegers);

        // assert
        expect(result.isActive, true);
        expect(result.emailVerified, true);
        expect(result.phoneVerified, true);
      });

      test('should handle null optional fields', () {
        // arrange
        final jsonWithNulls = {
          'id': '123',
          'firebase_uid': 'firebase123',
          'name': 'Test User',
          'email': null,
          'phone': '+201234567890',
          'account_type': 'player',
          'date_of_birth': null,
          'country': null,
          'profile_photo_url': null,
          'is_active': true,
          'email_verified': false,
          'phone_verified': true,
          'created_at': '2024-01-01T10:30:00.000',
          'updated_at': '2024-01-01T10:30:00.000',
        };

        // act
        final result = UserModel.fromJson(jsonWithNulls);

        // assert
        expect(result.email, isNull);
        expect(result.dateOfBirth, isNull);
        expect(result.country, isNull);
        expect(result.profilePhotoUrl, isNull);
      });
    });

    group('toJson', () {
      test('should return valid JSON from UserModel', () {
        // act
        final result = tUserModel.toJson();

        // assert
        expect(result, equals(tJson));
      });

      test('should include all required fields in JSON', () {
        // act
        final result = tUserModel.toJson();

        // assert
        expect(result['id'], isNotNull);
        expect(result['firebase_uid'], isNotNull);
        expect(result['name'], isNotNull);
        expect(result['phone'], isNotNull);
        expect(result['account_type'], isNotNull);
        expect(result['is_active'], isNotNull);
        expect(result['email_verified'], isNotNull);
        expect(result['phone_verified'], isNotNull);
        expect(result['created_at'], isNotNull);
        expect(result['updated_at'], isNotNull);
      });

      test('should handle null optional fields in JSON', () {
        // arrange
        final userWithNulls = UserModel(
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

        // act
        final result = userWithNulls.toJson();

        // assert
        expect(result['email'], isNull);
        expect(result['date_of_birth'], isNull);
        expect(result['country'], isNull);
        expect(result['profile_photo_url'], isNull);
      });
    });

    group('toEntity', () {
      test('should return valid UserEntity from UserModel', () {
        // act
        final result = tUserModel.toEntity();

        // assert
        expect(result, isA<UserEntity>());
        expect(result.id, tUserModel.id);
        expect(result.firebaseUid, tUserModel.firebaseUid);
        expect(result.name, tUserModel.name);
        expect(result.email, tUserModel.email);
        expect(result.phone, tUserModel.phone);
        expect(result.accountType, tUserModel.accountType);
        expect(result.dateOfBirth, tUserModel.dateOfBirth);
        expect(result.country, tUserModel.country);
        expect(result.profilePhotoUrl, tUserModel.profilePhotoUrl);
        expect(result.isActive, tUserModel.isActive);
        expect(result.emailVerified, tUserModel.emailVerified);
        expect(result.phoneVerified, tUserModel.phoneVerified);
        expect(result.createdAt, tUserModel.createdAt);
        expect(result.updatedAt, tUserModel.updatedAt);
      });
    });

    group('fromEntity', () {
      test('should return valid UserModel from UserEntity', () {
        // arrange
        final tEntity = UserEntity(
          id: '123',
          firebaseUid: 'firebase123',
          name: 'Mohamed Salah',
          email: 'salah@example.com',
          phone: '+201234567890',
          accountType: 'player',
          dateOfBirth: '1992-06-15',
          country: 'Egypt',
          profilePhotoUrl: 'https://example.com/photo.jpg',
          isActive: true,
          emailVerified: true,
          phoneVerified: true,
          createdAt: DateTime(2024, 1, 1, 10, 30),
          updatedAt: DateTime(2024, 1, 2, 15, 45),
        );

        // act
        final result = UserModel.fromEntity(tEntity);

        // assert
        expect(result, isA<UserModel>());
        expect(result, equals(tUserModel));
      });
    });

    group('JSON roundtrip', () {
      test('should maintain data integrity through fromJson -> toJson cycle', () {
        // act
        final model = UserModel.fromJson(tJson);
        final json = model.toJson();

        // assert
        expect(json, equals(tJson));
      });

      test('should maintain data integrity through toJson -> fromJson cycle', () {
        // act
        final json = tUserModel.toJson();
        final model = UserModel.fromJson(json);

        // assert
        expect(model, equals(tUserModel));
      });
    });

    group('Entity conversion roundtrip', () {
      test('should maintain data integrity through toEntity -> fromEntity cycle', () {
        // act
        final entity = tUserModel.toEntity();
        final model = UserModel.fromEntity(entity);

        // assert
        expect(model, equals(tUserModel));
      });
    });
  });
}
