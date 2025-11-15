import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/scout_profile.dart';

part 'scout_profile_model.g.dart';

/// Scout profile data model with JSON serialization
@JsonSerializable(explicitToJson: true)
class ScoutProfileModel extends ScoutProfile {
  const ScoutProfileModel({
    required super.id,
    required super.userId,
    required super.organizationName,
    required super.roleTitle,
    required super.yearsOfExperience,
    required super.countriesOfInterest,
    required super.positionsOfInterest,
    super.licenseNumber,
    super.verificationDocumentUrl,
    required super.verificationStatus,
    super.rejectionReason,
    super.contactEmail,
    super.contactPhone,
    super.website,
    super.linkedinUrl,
    super.instagramHandle,
    super.twitterHandle,
    required super.isVerified,
    required super.isActive,
    required super.profileViews,
    required super.playersSaved,
    required super.searchesSaved,
    required super.createdAt,
    required super.updatedAt,
    super.verifiedAt,
  });

  factory ScoutProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ScoutProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ScoutProfileModelToJson(this);

  /// Convert entity to model
  factory ScoutProfileModel.fromEntity(ScoutProfile profile) {
    return ScoutProfileModel(
      id: profile.id,
      userId: profile.userId,
      organizationName: profile.organizationName,
      roleTitle: profile.roleTitle,
      yearsOfExperience: profile.yearsOfExperience,
      countriesOfInterest: profile.countriesOfInterest,
      positionsOfInterest: profile.positionsOfInterest,
      licenseNumber: profile.licenseNumber,
      verificationDocumentUrl: profile.verificationDocumentUrl,
      verificationStatus: profile.verificationStatus,
      rejectionReason: profile.rejectionReason,
      contactEmail: profile.contactEmail,
      contactPhone: profile.contactPhone,
      website: profile.website,
      linkedinUrl: profile.linkedinUrl,
      instagramHandle: profile.instagramHandle,
      twitterHandle: profile.twitterHandle,
      isVerified: profile.isVerified,
      isActive: profile.isActive,
      profileViews: profile.profileViews,
      playersSaved: profile.playersSaved,
      searchesSaved: profile.searchesSaved,
      createdAt: profile.createdAt,
      updatedAt: profile.updatedAt,
      verifiedAt: profile.verifiedAt,
    );
  }
}
