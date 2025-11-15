// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scout_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScoutProfileModel _$ScoutProfileModelFromJson(Map<String, dynamic> json) =>
    ScoutProfileModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      organizationName: json['organizationName'] as String,
      roleTitle: json['roleTitle'] as String,
      yearsOfExperience: (json['yearsOfExperience'] as num).toInt(),
      countriesOfInterest: (json['countriesOfInterest'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      positionsOfInterest: (json['positionsOfInterest'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      licenseNumber: json['licenseNumber'] as String?,
      verificationDocumentUrl: json['verificationDocumentUrl'] as String?,
      verificationStatus: json['verificationStatus'] as String,
      rejectionReason: json['rejectionReason'] as String?,
      contactEmail: json['contactEmail'] as String?,
      contactPhone: json['contactPhone'] as String?,
      website: json['website'] as String?,
      linkedinUrl: json['linkedinUrl'] as String?,
      instagramHandle: json['instagramHandle'] as String?,
      twitterHandle: json['twitterHandle'] as String?,
      isVerified: json['isVerified'] as bool,
      isActive: json['isActive'] as bool,
      profileViews: (json['profileViews'] as num).toInt(),
      playersSaved: (json['playersSaved'] as num).toInt(),
      searchesSaved: (json['searchesSaved'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      verifiedAt: json['verifiedAt'] == null
          ? null
          : DateTime.parse(json['verifiedAt'] as String),
    );

Map<String, dynamic> _$ScoutProfileModelToJson(ScoutProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'organizationName': instance.organizationName,
      'roleTitle': instance.roleTitle,
      'yearsOfExperience': instance.yearsOfExperience,
      'countriesOfInterest': instance.countriesOfInterest,
      'positionsOfInterest': instance.positionsOfInterest,
      'licenseNumber': instance.licenseNumber,
      'verificationDocumentUrl': instance.verificationDocumentUrl,
      'verificationStatus': instance.verificationStatus,
      'rejectionReason': instance.rejectionReason,
      'contactEmail': instance.contactEmail,
      'contactPhone': instance.contactPhone,
      'website': instance.website,
      'linkedinUrl': instance.linkedinUrl,
      'instagramHandle': instance.instagramHandle,
      'twitterHandle': instance.twitterHandle,
      'isVerified': instance.isVerified,
      'isActive': instance.isActive,
      'profileViews': instance.profileViews,
      'playersSaved': instance.playersSaved,
      'searchesSaved': instance.searchesSaved,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'verifiedAt': instance.verifiedAt?.toIso8601String(),
    };
