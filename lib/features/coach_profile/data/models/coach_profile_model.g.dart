// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coach_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoachProfileModel _$CoachProfileModelFromJson(Map<String, dynamic> json) =>
    CoachProfileModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      fullName: json['fullName'] as String,
      clubName: json['clubName'] as String?,
      currentTeam: json['currentTeam'] as String?,
      roleTitle: json['roleTitle'] as String,
      yearsOfExperience: (json['yearsOfExperience'] as num).toInt(),
      specializations: (json['specializations'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      ageGroups:
          (json['ageGroups'] as List<dynamic>).map((e) => e as String).toList(),
      licenseLevel: json['licenseLevel'] as String?,
      licenseExpiry: json['licenseExpiry'] == null
          ? null
          : DateTime.parse(json['licenseExpiry'] as String),
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      bio: json['bio'] as String?,
      profilePhotoUrl: json['profilePhotoUrl'] as String?,
      verificationStatus: json['verificationStatus'] as String,
      achievements: (json['achievements'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      profileCompleteness: (json['profileCompleteness'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$CoachProfileModelToJson(CoachProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'fullName': instance.fullName,
      'clubName': instance.clubName,
      'currentTeam': instance.currentTeam,
      'roleTitle': instance.roleTitle,
      'yearsOfExperience': instance.yearsOfExperience,
      'specializations': instance.specializations,
      'ageGroups': instance.ageGroups,
      'licenseLevel': instance.licenseLevel,
      'licenseExpiry': instance.licenseExpiry?.toIso8601String(),
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'bio': instance.bio,
      'profilePhotoUrl': instance.profilePhotoUrl,
      'verificationStatus': instance.verificationStatus,
      'achievements': instance.achievements,
      'profileCompleteness': instance.profileCompleteness,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
