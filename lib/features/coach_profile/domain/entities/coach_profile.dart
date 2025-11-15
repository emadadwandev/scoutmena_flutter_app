import 'package:equatable/equatable.dart';

/// Coach profile entity
class CoachProfile extends Equatable {
  final String id;
  final String userId;
  final String fullName;
  final String? clubName;
  final String? currentTeam;
  final String roleTitle; // 'Head Coach', 'Assistant Coach', 'Youth Coach', etc.
  final int yearsOfExperience;
  final List<String> specializations; // 'Offensive', 'Defensive', 'Goalkeeping', etc.
  final List<String> ageGroups; // 'U12', 'U15', 'U18', 'Senior', etc.
  final String? licenseLevel; // 'UEFA A', 'UEFA B', 'CAF A', etc.
  final DateTime? licenseExpiry;
  final String? email;
  final String? phoneNumber;
  final String? bio;
  final String? profilePhotoUrl;
  final String verificationStatus; // 'pending', 'verified', 'rejected'
  final List<String> achievements;
  final int profileCompleteness; // 0-100
  final DateTime createdAt;
  final DateTime updatedAt;

  const CoachProfile({
    required this.id,
    required this.userId,
    required this.fullName,
    this.clubName,
    this.currentTeam,
    required this.roleTitle,
    required this.yearsOfExperience,
    required this.specializations,
    required this.ageGroups,
    this.licenseLevel,
    this.licenseExpiry,
    this.email,
    this.phoneNumber,
    this.bio,
    this.profilePhotoUrl,
    required this.verificationStatus,
    required this.achievements,
    required this.profileCompleteness,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Check if profile is verified
  bool get isVerified => verificationStatus == 'verified';

  /// Check if profile is complete
  bool get isComplete => profileCompleteness == 100;

  CoachProfile copyWith({
    String? id,
    String? userId,
    String? fullName,
    String? clubName,
    String? currentTeam,
    String? roleTitle,
    int? yearsOfExperience,
    List<String>? specializations,
    List<String>? ageGroups,
    String? licenseLevel,
    DateTime? licenseExpiry,
    String? email,
    String? phoneNumber,
    String? bio,
    String? profilePhotoUrl,
    String? verificationStatus,
    List<String>? achievements,
    int? profileCompleteness,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CoachProfile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      clubName: clubName ?? this.clubName,
      currentTeam: currentTeam ?? this.currentTeam,
      roleTitle: roleTitle ?? this.roleTitle,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      specializations: specializations ?? this.specializations,
      ageGroups: ageGroups ?? this.ageGroups,
      licenseLevel: licenseLevel ?? this.licenseLevel,
      licenseExpiry: licenseExpiry ?? this.licenseExpiry,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      bio: bio ?? this.bio,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      achievements: achievements ?? this.achievements,
      profileCompleteness: profileCompleteness ?? this.profileCompleteness,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        fullName,
        clubName,
        currentTeam,
        roleTitle,
        yearsOfExperience,
        specializations,
        ageGroups,
        licenseLevel,
        licenseExpiry,
        email,
        phoneNumber,
        bio,
        profilePhotoUrl,
        verificationStatus,
        achievements,
        profileCompleteness,
        createdAt,
        updatedAt,
      ];
}
