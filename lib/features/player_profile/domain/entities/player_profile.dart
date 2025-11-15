import 'package:equatable/equatable.dart';

/// Player profile entity representing a player's complete profile information
class PlayerProfile extends Equatable {
  final String id;
  final String userId;
  final String fullName;
  final DateTime dateOfBirth;
  final String nationality;
  final double height; // in cm
  final double weight; // in kg
  final String dominantFoot; // 'left', 'right', 'both'
  final String? currentClub;
  final List<String> positions;
  final int? jerseyNumber;
  final int yearsPlaying;
  final String? email;
  final String? phoneNumber;
  final String? instagramHandle;
  final String? twitterHandle;
  final String? profilePhotoUrl;
  final bool isMinor;
  final String? parentName;
  final String? parentEmail;
  final String? parentPhone;
  final String? emergencyContact;
  final bool parentalConsentGiven;
  final String profileStatus; // 'incomplete', 'pending_consent', 'active'
  final int profileCompleteness; // 0-100
  final DateTime createdAt;
  final DateTime updatedAt;

  const PlayerProfile({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.dateOfBirth,
    required this.nationality,
    required this.height,
    required this.weight,
    required this.dominantFoot,
    this.currentClub,
    required this.positions,
    this.jerseyNumber,
    required this.yearsPlaying,
    this.email,
    this.phoneNumber,
    this.instagramHandle,
    this.twitterHandle,
    this.profilePhotoUrl,
    required this.isMinor,
    this.parentName,
    this.parentEmail,
    this.parentPhone,
    this.emergencyContact,
    required this.parentalConsentGiven,
    required this.profileStatus,
    required this.profileCompleteness,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Calculate age from date of birth
  int get age {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  /// Check if profile is complete
  bool get isComplete => profileCompleteness == 100;

  /// Check if profile needs parental consent
  bool get needsParentalConsent => isMinor && !parentalConsentGiven;

  /// Copy with method for immutable updates
  PlayerProfile copyWith({
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
    return PlayerProfile(
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

  @override
  List<Object?> get props => [
        id,
        userId,
        fullName,
        dateOfBirth,
        nationality,
        height,
        weight,
        dominantFoot,
        currentClub,
        positions,
        jerseyNumber,
        yearsPlaying,
        email,
        phoneNumber,
        instagramHandle,
        twitterHandle,
        profilePhotoUrl,
        isMinor,
        parentName,
        parentEmail,
        parentPhone,
        emergencyContact,
        parentalConsentGiven,
        profileStatus,
        profileCompleteness,
        createdAt,
        updatedAt,
      ];
}
