// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerProfileModel _$PlayerProfileModelFromJson(Map<String, dynamic> json) =>
    PlayerProfileModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      fullName: json['fullName'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      nationality: json['nationality'] as String,
      height: (json['height'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      dominantFoot: json['dominantFoot'] as String,
      currentClub: json['currentClub'] as String?,
      positions:
          (json['positions'] as List<dynamic>).map((e) => e as String).toList(),
      jerseyNumber: (json['jerseyNumber'] as num?)?.toInt(),
      yearsPlaying: (json['yearsPlaying'] as num).toInt(),
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      instagramHandle: json['instagramHandle'] as String?,
      twitterHandle: json['twitterHandle'] as String?,
      profilePhotoUrl: json['profilePhotoUrl'] as String?,
      isMinor: json['isMinor'] as bool,
      parentName: json['parentName'] as String?,
      parentEmail: json['parentEmail'] as String?,
      parentPhone: json['parentPhone'] as String?,
      emergencyContact: json['emergencyContact'] as String?,
      parentalConsentGiven: json['parentalConsentGiven'] as bool,
      profileStatus: json['profileStatus'] as String,
      profileCompleteness: (json['profileCompleteness'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$PlayerProfileModelToJson(PlayerProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'fullName': instance.fullName,
      'dateOfBirth': instance.dateOfBirth.toIso8601String(),
      'nationality': instance.nationality,
      'height': instance.height,
      'weight': instance.weight,
      'dominantFoot': instance.dominantFoot,
      'currentClub': instance.currentClub,
      'positions': instance.positions,
      'jerseyNumber': instance.jerseyNumber,
      'yearsPlaying': instance.yearsPlaying,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'instagramHandle': instance.instagramHandle,
      'twitterHandle': instance.twitterHandle,
      'profilePhotoUrl': instance.profilePhotoUrl,
      'isMinor': instance.isMinor,
      'parentName': instance.parentName,
      'parentEmail': instance.parentEmail,
      'parentPhone': instance.parentPhone,
      'emergencyContact': instance.emergencyContact,
      'parentalConsentGiven': instance.parentalConsentGiven,
      'profileStatus': instance.profileStatus,
      'profileCompleteness': instance.profileCompleteness,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
