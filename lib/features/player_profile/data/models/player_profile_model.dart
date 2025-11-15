import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/player_profile.dart';

part 'player_profile_model.g.dart';

/// Data model for player profile with JSON serialization
@JsonSerializable(explicitToJson: true)
class PlayerProfileModel extends PlayerProfile {
  const PlayerProfileModel({
    required super.id,
    required super.userId,
    required super.fullName,
    required super.dateOfBirth,
    required super.nationality,
    required super.height,
    required super.weight,
    required super.dominantFoot,
    super.currentClub,
    required super.positions,
    super.jerseyNumber,
    required super.yearsPlaying,
    super.email,
    super.phoneNumber,
    super.instagramHandle,
    super.twitterHandle,
    super.profilePhotoUrl,
    required super.isMinor,
    super.parentName,
    super.parentEmail,
    super.parentPhone,
    super.emergencyContact,
    required super.parentalConsentGiven,
    required super.profileStatus,
    required super.profileCompleteness,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Create model from JSON
  factory PlayerProfileModel.fromJson(Map<String, dynamic> json) =>
      _$PlayerProfileModelFromJson(json);

  /// Convert model to JSON
  Map<String, dynamic> toJson() => _$PlayerProfileModelToJson(this);

  /// Create model from entity
  factory PlayerProfileModel.fromEntity(PlayerProfile entity) {
    return PlayerProfileModel(
      id: entity.id,
      userId: entity.userId,
      fullName: entity.fullName,
      dateOfBirth: entity.dateOfBirth,
      nationality: entity.nationality,
      height: entity.height,
      weight: entity.weight,
      dominantFoot: entity.dominantFoot,
      currentClub: entity.currentClub,
      positions: entity.positions,
      jerseyNumber: entity.jerseyNumber,
      yearsPlaying: entity.yearsPlaying,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      instagramHandle: entity.instagramHandle,
      twitterHandle: entity.twitterHandle,
      profilePhotoUrl: entity.profilePhotoUrl,
      isMinor: entity.isMinor,
      parentName: entity.parentName,
      parentEmail: entity.parentEmail,
      parentPhone: entity.parentPhone,
      emergencyContact: entity.emergencyContact,
      parentalConsentGiven: entity.parentalConsentGiven,
      profileStatus: entity.profileStatus,
      profileCompleteness: entity.profileCompleteness,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Convert model to entity
  PlayerProfile toEntity() => this;

  @override
  PlayerProfileModel copyWith({
    String? id,
    String? userId,
    String? fullName,
    DateTime? dateOfBirth,
    String? nationality,
    double? height,
    double? weight,
    String? dominantFoot,
    String? currentClub,
    List<String>? positions,
    int? jerseyNumber,
    int? yearsPlaying,
    String? email,
    String? phoneNumber,
    String? instagramHandle,
    String? twitterHandle,
    String? profilePhotoUrl,
    bool? isMinor,
    String? parentName,
    String? parentEmail,
    String? parentPhone,
    String? emergencyContact,
    bool? parentalConsentGiven,
    String? profileStatus,
    int? profileCompleteness,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PlayerProfileModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      nationality: nationality ?? this.nationality,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      dominantFoot: dominantFoot ?? this.dominantFoot,
      currentClub: currentClub ?? this.currentClub,
      positions: positions ?? this.positions,
      jerseyNumber: jerseyNumber ?? this.jerseyNumber,
      yearsPlaying: yearsPlaying ?? this.yearsPlaying,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      instagramHandle: instagramHandle ?? this.instagramHandle,
      twitterHandle: twitterHandle ?? this.twitterHandle,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      isMinor: isMinor ?? this.isMinor,
      parentName: parentName ?? this.parentName,
      parentEmail: parentEmail ?? this.parentEmail,
      parentPhone: parentPhone ?? this.parentPhone,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      parentalConsentGiven: parentalConsentGiven ?? this.parentalConsentGiven,
      profileStatus: profileStatus ?? this.profileStatus,
      profileCompleteness: profileCompleteness ?? this.profileCompleteness,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
