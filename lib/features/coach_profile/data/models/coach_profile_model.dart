import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/coach_profile.dart';

part 'coach_profile_model.g.dart';

/// Coach profile data model with JSON serialization
@JsonSerializable(explicitToJson: true)
class CoachProfileModel extends CoachProfile {
  const CoachProfileModel({
    required super.id,
    required super.userId,
    required super.fullName,
    super.clubName,
    super.currentTeam,
    required super.roleTitle,
    required super.yearsOfExperience,
    required super.specializations,
    required super.ageGroups,
    super.licenseLevel,
    super.licenseExpiry,
    super.email,
    super.phoneNumber,
    super.bio,
    super.profilePhotoUrl,
    required super.verificationStatus,
    required super.achievements,
    required super.profileCompleteness,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CoachProfileModel.fromJson(Map<String, dynamic> json) =>
      _$CoachProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$CoachProfileModelToJson(this);

  factory CoachProfileModel.fromEntity(CoachProfile profile) {
    return CoachProfileModel(
      id: profile.id,
      userId: profile.userId,
      fullName: profile.fullName,
      clubName: profile.clubName,
      currentTeam: profile.currentTeam,
      roleTitle: profile.roleTitle,
      yearsOfExperience: profile.yearsOfExperience,
      specializations: profile.specializations,
      ageGroups: profile.ageGroups,
      licenseLevel: profile.licenseLevel,
      licenseExpiry: profile.licenseExpiry,
      email: profile.email,
      phoneNumber: profile.phoneNumber,
      bio: profile.bio,
      profilePhotoUrl: profile.profilePhotoUrl,
      verificationStatus: profile.verificationStatus,
      achievements: profile.achievements,
      profileCompleteness: profile.profileCompleteness,
      createdAt: profile.createdAt,
      updatedAt: profile.updatedAt,
    );
  }
}
