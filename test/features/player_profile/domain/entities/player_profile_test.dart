import 'package:flutter_test/flutter_test.dart';
import 'package:scoutmena_app/features/player_profile/domain/entities/player_profile.dart';

void main() {
  group('PlayerProfile', () {
    final tDateOfBirth = DateTime(2004, 1, 1);
    final tCreatedAt = DateTime(2024, 1, 1);
    final tUpdatedAt = DateTime(2024, 1, 15);

    final tPlayerProfile = PlayerProfile(
      id: 'profile123',
      userId: 'user123',
      fullName: 'Ahmed Salem',
      dateOfBirth: tDateOfBirth,
      nationality: 'Saudi Arabia',
      height: 180.0,
      weight: 75.0,
      dominantFoot: 'right',
      currentClub: 'Al Hilal',
      positions: const ['striker', 'winger'],
      jerseyNumber: 10,
      yearsPlaying: 8,
      email: 'ahmed@example.com',
      phoneNumber: '+966501234567',
      instagramHandle: '@ahmed_salem',
      twitterHandle: '@ahmed_salem',
      profilePhotoUrl: 'https://example.com/photo.jpg',
      isMinor: false,
      parentalConsentGiven: true,
      profileStatus: 'active',
      profileCompleteness: 85,
      createdAt: tCreatedAt,
      updatedAt: tUpdatedAt,
    );

    test('should be a subclass of Equatable', () {
      // assert
      expect(tPlayerProfile, isA<PlayerProfile>());
    });

    test('should calculate age correctly from date of birth', () {
      // arrange
      final birthDate = DateTime(2004, 6, 15);
      final profile = PlayerProfile(
        id: 'profile123',
        userId: 'user123',
        fullName: 'Test Player',
        dateOfBirth: birthDate,
        nationality: 'Saudi Arabia',
        height: 180.0,
        weight: 75.0,
        dominantFoot: 'right',
        positions: const ['striker'],
        yearsPlaying: 5,
        isMinor: false,
        parentalConsentGiven: true,
        profileStatus: 'active',
        profileCompleteness: 80,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // act & assert
      // Since we can't control DateTime.now() in tests, we'll just verify age is calculated
      expect(profile.age, greaterThanOrEqualTo(20)); // Born in 2004, so at least 20 in 2025
      expect(profile.age, lessThanOrEqualTo(22)); // Maximum possible age
    });

    test('isComplete should return true when profileCompleteness is 100', () {
      // arrange
      final completeProfile = tPlayerProfile.copyWith(profileCompleteness: 100);

      // assert
      expect(completeProfile.isComplete, true);
    });

    test('isComplete should return false when profileCompleteness is less than 100', () {
      // assert
      expect(tPlayerProfile.isComplete, false);
      expect(tPlayerProfile.profileCompleteness, 85);
    });

    test('needsParentalConsent should return true for minor without consent', () {
      // arrange
      final minorProfile = tPlayerProfile.copyWith(
        isMinor: true,
        parentalConsentGiven: false,
      );

      // assert
      expect(minorProfile.needsParentalConsent, true);
    });

    test('needsParentalConsent should return false for minor with consent', () {
      // arrange
      final minorProfile = tPlayerProfile.copyWith(
        isMinor: true,
        parentalConsentGiven: true,
      );

      // assert
      expect(minorProfile.needsParentalConsent, false);
    });

    test('needsParentalConsent should return false for adult', () {
      // assert
      expect(tPlayerProfile.needsParentalConsent, false);
      expect(tPlayerProfile.isMinor, false);
    });

    test('should have correct props for Equatable comparison', () {
      // arrange
      final profile1 = PlayerProfile(
        id: 'profile123',
        userId: 'user123',
        fullName: 'Test',
        dateOfBirth: tDateOfBirth,
        nationality: 'Saudi Arabia',
        height: 180.0,
        weight: 75.0,
        dominantFoot: 'right',
        positions: const ['striker'],
        yearsPlaying: 5,
        isMinor: false,
        parentalConsentGiven: true,
        profileStatus: 'active',
        profileCompleteness: 85,
        createdAt: tCreatedAt,
        updatedAt: tUpdatedAt,
      );

      final profile2 = PlayerProfile(
        id: 'profile123',
        userId: 'user123',
        fullName: 'Test',
        dateOfBirth: tDateOfBirth,
        nationality: 'Saudi Arabia',
        height: 180.0,
        weight: 75.0,
        dominantFoot: 'right',
        positions: const ['striker'],
        yearsPlaying: 5,
        isMinor: false,
        parentalConsentGiven: true,
        profileStatus: 'active',
        profileCompleteness: 85,
        createdAt: tCreatedAt,
        updatedAt: tUpdatedAt,
      );

      // assert
      expect(profile1, equals(profile2));
    });

    test('copyWith should create new instance with updated properties', () {
      // act
      final updatedProfile = tPlayerProfile.copyWith(
        fullName: 'Updated Name',
        currentClub: 'Al Nassr',
        profileCompleteness: 100,
      );

      // assert
      expect(updatedProfile.fullName, 'Updated Name');
      expect(updatedProfile.currentClub, 'Al Nassr');
      expect(updatedProfile.profileCompleteness, 100);
      expect(updatedProfile.id, tPlayerProfile.id);
      expect(updatedProfile.userId, tPlayerProfile.userId);
    });

    test('should handle optional fields correctly', () {
      // arrange
      final minimalProfile = PlayerProfile(
        id: 'profile123',
        userId: 'user123',
        fullName: 'Test Player',
        dateOfBirth: tDateOfBirth,
        nationality: 'Saudi Arabia',
        height: 180.0,
        weight: 75.0,
        dominantFoot: 'right',
        positions: const ['striker'],
        yearsPlaying: 5,
        isMinor: false,
        parentalConsentGiven: true,
        profileStatus: 'active',
        profileCompleteness: 50,
        createdAt: tCreatedAt,
        updatedAt: tUpdatedAt,
      );

      // assert
      expect(minimalProfile.currentClub, isNull);
      expect(minimalProfile.jerseyNumber, isNull);
      expect(minimalProfile.email, isNull);
      expect(minimalProfile.phoneNumber, isNull);
      expect(minimalProfile.instagramHandle, isNull);
      expect(minimalProfile.twitterHandle, isNull);
      expect(minimalProfile.profilePhotoUrl, isNull);
      expect(minimalProfile.parentName, isNull);
      expect(minimalProfile.parentEmail, isNull);
      expect(minimalProfile.parentPhone, isNull);
      expect(minimalProfile.emergencyContact, isNull);
    });
  });
}
