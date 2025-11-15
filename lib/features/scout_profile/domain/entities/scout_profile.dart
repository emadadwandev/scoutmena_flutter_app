import 'package:equatable/equatable.dart';

/// Scout profile entity representing a scout's professional information
class ScoutProfile extends Equatable {
  final String id;
  final String userId;
  final String organizationName;
  final String roleTitle;
  final int yearsOfExperience;
  final List<String> countriesOfInterest;
  final List<String> positionsOfInterest;
  final String? licenseNumber;
  final String? verificationDocumentUrl;
  final String verificationStatus; // pending, approved, rejected
  final String? rejectionReason;
  final String? contactEmail;
  final String? contactPhone;
  final String? website;
  final String? linkedinUrl;
  final String? instagramHandle;
  final String? twitterHandle;
  final bool isVerified;
  final bool isActive;
  final int profileViews;
  final int playersSaved;
  final int searchesSaved;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? verifiedAt;

  const ScoutProfile({
    required this.id,
    required this.userId,
    required this.organizationName,
    required this.roleTitle,
    required this.yearsOfExperience,
    required this.countriesOfInterest,
    required this.positionsOfInterest,
    this.licenseNumber,
    this.verificationDocumentUrl,
    required this.verificationStatus,
    this.rejectionReason,
    this.contactEmail,
    this.contactPhone,
    this.website,
    this.linkedinUrl,
    this.instagramHandle,
    this.twitterHandle,
    required this.isVerified,
    required this.isActive,
    required this.profileViews,
    required this.playersSaved,
    required this.searchesSaved,
    required this.createdAt,
    required this.updatedAt,
    this.verifiedAt,
  });

  bool get isPending => verificationStatus == 'pending';
  bool get isApproved => verificationStatus == 'approved';
  bool get isRejected => verificationStatus == 'rejected';

  int get profileCompleteness {
    int total = 0;
    int filled = 0;

    // Required fields
    total += 3;
    filled += 3; // organizationName, roleTitle, yearsOfExperience

    // Countries and positions
    total += 2;
    if (countriesOfInterest.isNotEmpty) filled++;
    if (positionsOfInterest.isNotEmpty) filled++;

    // Optional but important fields
    total += 7;
    if (licenseNumber != null) filled++;
    if (contactEmail != null) filled++;
    if (contactPhone != null) filled++;
    if (website != null) filled++;
    if (linkedinUrl != null) filled++;
    if (instagramHandle != null) filled++;
    if (twitterHandle != null) filled++;

    return ((filled / total) * 100).round();
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        organizationName,
        roleTitle,
        yearsOfExperience,
        countriesOfInterest,
        positionsOfInterest,
        licenseNumber,
        verificationDocumentUrl,
        verificationStatus,
        rejectionReason,
        contactEmail,
        contactPhone,
        website,
        linkedinUrl,
        instagramHandle,
        twitterHandle,
        isVerified,
        isActive,
        profileViews,
        playersSaved,
        searchesSaved,
        createdAt,
        updatedAt,
        verifiedAt,
      ];
}
