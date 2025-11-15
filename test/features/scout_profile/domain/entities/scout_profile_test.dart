import 'package:flutter_test/flutter_test.dart';
import 'package:scoutmena_app/features/scout_profile/domain/entities/scout_profile.dart';

void main() {
  final tCreatedAt = DateTime(2024, 1, 15);
  final tUpdatedAt = DateTime(2024, 4, 10);
  final tVerifiedAt = DateTime(2024, 1, 20);

  final tScoutProfile = ScoutProfile(
    id: 'scout123',
    userId: 'user123',
    organizationName: 'Premier League Scouts',
    roleTitle: 'Senior Scout',
    yearsOfExperience: 10,
    countriesOfInterest: ['United Kingdom', 'Spain'],
    positionsOfInterest: ['striker', 'attacking_midfielder'],
    licenseNumber: 'FA-12345',
    verificationDocumentUrl: 'https://example.com/doc.pdf',
    verificationStatus: 'approved',
    rejectionReason: null,
    contactEmail: 'scout@premierleague.com',
    contactPhone: '+44123456789',
    website: 'https://plscouts.com',
    linkedinUrl: 'https://linkedin.com/in/scout',
    instagramHandle: '@plscout',
    twitterHandle: '@plscout',
    isVerified: true,
    isActive: true,
    profileViews: 150,
    playersSaved: 25,
    searchesSaved: 10,
    createdAt: tCreatedAt,
    updatedAt: tUpdatedAt,
    verifiedAt: tVerifiedAt,
  );

  group('Scout Profile Verification Status', () {
    test('isPending should return true when status is pending', () {
      final pendingProfile = tScoutProfile.copyWith(verificationStatus: 'pending');

      expect(pendingProfile.isPending, true);
      expect(pendingProfile.isApproved, false);
      expect(pendingProfile.isRejected, false);
    });

    test('isApproved should return true when status is approved', () {
      final approvedProfile = tScoutProfile.copyWith(verificationStatus: 'approved');

      expect(approvedProfile.isApproved, true);
      expect(approvedProfile.isPending, false);
      expect(approvedProfile.isRejected, false);
    });

    test('isRejected should return true when status is rejected', () {
      final rejectedProfile = tScoutProfile.copyWith(
        verificationStatus: 'rejected',
        rejectionReason: 'Invalid documentation',
      );

      expect(rejectedProfile.isRejected, true);
      expect(rejectedProfile.isPending, false);
      expect(rejectedProfile.isApproved, false);
    });
  });

  group('Profile Completeness', () {
    test('profileCompleteness should calculate correctly for fully filled profile', () {
      final fullProfile = ScoutProfile(
        id: 'scout123',
        userId: 'user123',
        organizationName: 'Test Org',
        roleTitle: 'Scout',
        yearsOfExperience: 5,
        countriesOfInterest: ['UK'],
        positionsOfInterest: ['striker'],
        licenseNumber: 'LIC-123',
        contactEmail: 'test@example.com',
        contactPhone: '+123456789',
        website: 'https://example.com',
        linkedinUrl: 'https://linkedin.com',
        instagramHandle: '@test',
        twitterHandle: '@test',
        verificationDocumentUrl: null,
        verificationStatus: 'pending',
        rejectionReason: null,
        isVerified: false,
        isActive: true,
        profileViews: 0,
        playersSaved: 0,
        searchesSaved: 0,
        createdAt: tCreatedAt,
        updatedAt: tUpdatedAt,
        verifiedAt: null,
      );

      // All 12 fields filled: 3 required + 2 interests + 7 optional = 100%
      expect(fullProfile.profileCompleteness, 100);
    });

    test('profileCompleteness should calculate correctly for minimal profile', () {
      final minimalProfile = ScoutProfile(
        id: 'scout123',
        userId: 'user123',
        organizationName: 'Test Org',
        roleTitle: 'Scout',
        yearsOfExperience: 5,
        countriesOfInterest: [],
        positionsOfInterest: [],
        licenseNumber: null,
        verificationDocumentUrl: null,
        verificationStatus: 'pending',
        rejectionReason: null,
        contactEmail: null,
        contactPhone: null,
        website: null,
        linkedinUrl: null,
        instagramHandle: null,
        twitterHandle: null,
        isVerified: false,
        isActive: true,
        profileViews: 0,
        playersSaved: 0,
        searchesSaved: 0,
        createdAt: tCreatedAt,
        updatedAt: tUpdatedAt,
        verifiedAt: null,
      );

      // Only 3 required fields filled out of 12 = 25%
      expect(minimalProfile.profileCompleteness, 25);
    });

    test('profileCompleteness should include interests when present', () {
      final profileWithInterests = ScoutProfile(
        id: 'scout123',
        userId: 'user123',
        organizationName: 'Test Org',
        roleTitle: 'Scout',
        yearsOfExperience: 5,
        countriesOfInterest: ['UK', 'Spain'],
        positionsOfInterest: ['striker'],
        licenseNumber: null,
        verificationDocumentUrl: null,
        verificationStatus: 'pending',
        rejectionReason: null,
        contactEmail: null,
        contactPhone: null,
        website: null,
        linkedinUrl: null,
        instagramHandle: null,
        twitterHandle: null,
        isVerified: false,
        isActive: true,
        profileViews: 0,
        playersSaved: 0,
        searchesSaved: 0,
        createdAt: tCreatedAt,
        updatedAt: tUpdatedAt,
        verifiedAt: null,
      );

      // 3 required + 2 interests = 5/12 = 42%
      expect(profileWithInterests.profileCompleteness, 42);
    });
  });

  group('Equatable', () {
    test('should have correct props for Equatable comparison', () {
      final profile1 = tScoutProfile;
      final profile2 = ScoutProfile(
        id: 'scout123',
        userId: 'user123',
        organizationName: 'Premier League Scouts',
        roleTitle: 'Senior Scout',
        yearsOfExperience: 10,
        countriesOfInterest: ['United Kingdom', 'Spain'],
        positionsOfInterest: ['striker', 'attacking_midfielder'],
        licenseNumber: 'FA-12345',
        verificationDocumentUrl: 'https://example.com/doc.pdf',
        verificationStatus: 'approved',
        rejectionReason: null,
        contactEmail: 'scout@premierleague.com',
        contactPhone: '+44123456789',
        website: 'https://plscouts.com',
        linkedinUrl: 'https://linkedin.com/in/scout',
        instagramHandle: '@plscout',
        twitterHandle: '@plscout',
        isVerified: true,
        isActive: true,
        profileViews: 150,
        playersSaved: 25,
        searchesSaved: 10,
        createdAt: tCreatedAt,
        updatedAt: tUpdatedAt,
        verifiedAt: tVerifiedAt,
      );

      expect(profile1, equals(profile2));
    });

    test('should not be equal when properties differ', () {
      final profile1 = tScoutProfile;
      final profile2 = tScoutProfile.copyWith(roleTitle: 'Head Scout');

      expect(profile1, isNot(equals(profile2)));
    });
  });

  group('CopyWith', () {
    test('copyWith should create new instance with updated properties', () {
      final updatedProfile = tScoutProfile.copyWith(
        roleTitle: 'Head Scout',
        yearsOfExperience: 15,
        website: 'https://newsite.com',
      );

      expect(updatedProfile.roleTitle, 'Head Scout');
      expect(updatedProfile.yearsOfExperience, 15);
      expect(updatedProfile.website, 'https://newsite.com');
      expect(updatedProfile.organizationName, tScoutProfile.organizationName);
    });

    test('copyWith should preserve original values when not specified', () {
      final updatedProfile = tScoutProfile.copyWith(roleTitle: 'Lead Scout');

      expect(updatedProfile.roleTitle, 'Lead Scout');
      expect(updatedProfile.organizationName, tScoutProfile.organizationName);
      expect(updatedProfile.yearsOfExperience, tScoutProfile.yearsOfExperience);
      expect(updatedProfile.countriesOfInterest, tScoutProfile.countriesOfInterest);
    });
  });
}

// Extension for copyWith (would be in the actual entity file)
extension ScoutProfileCopyWith on ScoutProfile {
  ScoutProfile copyWith({
    String? id,
    String? userId,
    String? organizationName,
    String? roleTitle,
    int? yearsOfExperience,
    List<String>? countriesOfInterest,
    List<String>? positionsOfInterest,
    String? licenseNumber,
    String? verificationDocumentUrl,
    String? verificationStatus,
    String? rejectionReason,
    String? contactEmail,
    String? contactPhone,
    String? website,
    String? linkedinUrl,
    String? instagramHandle,
    String? twitterHandle,
    bool? isVerified,
    bool? isActive,
    int? profileViews,
    int? playersSaved,
    int? searchesSaved,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? verifiedAt,
  }) {
    return ScoutProfile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      organizationName: organizationName ?? this.organizationName,
      roleTitle: roleTitle ?? this.roleTitle,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      countriesOfInterest: countriesOfInterest ?? this.countriesOfInterest,
      positionsOfInterest: positionsOfInterest ?? this.positionsOfInterest,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      verificationDocumentUrl: verificationDocumentUrl ?? this.verificationDocumentUrl,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      contactEmail: contactEmail ?? this.contactEmail,
      contactPhone: contactPhone ?? this.contactPhone,
      website: website ?? this.website,
      linkedinUrl: linkedinUrl ?? this.linkedinUrl,
      instagramHandle: instagramHandle ?? this.instagramHandle,
      twitterHandle: twitterHandle ?? this.twitterHandle,
      isVerified: isVerified ?? this.isVerified,
      isActive: isActive ?? this.isActive,
      profileViews: profileViews ?? this.profileViews,
      playersSaved: playersSaved ?? this.playersSaved,
      searchesSaved: searchesSaved ?? this.searchesSaved,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      verifiedAt: verifiedAt ?? this.verifiedAt,
    );
  }
}
