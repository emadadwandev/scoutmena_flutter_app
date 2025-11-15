import 'dart:io';

/// Model class to hold all form data during profile setup
class ProfileSetupFormData {
  // Step 1: Basic Information
  File? profilePhoto;
  String fullName;
  DateTime? dateOfBirth;
  String? nationality;
  double? height; // in cm
  double? weight; // in kg
  String? dominantFoot; // 'left', 'right', 'both'

  // Step 2: Football Information
  String? currentClub;
  List<String> positions;
  int? jerseyNumber;
  int? yearsPlaying;

  // Step 3: Contact & Social
  String? email;
  String? phoneNumber;
  String? instagramHandle;
  String? twitterHandle;

  // Step 4: Parent Information (for minors)
  String? parentName;
  String? parentEmail;
  String? parentPhone;
  String? emergencyContact;

  // Metadata
  bool isMinor;

  ProfileSetupFormData({
    this.profilePhoto,
    this.fullName = '',
    this.dateOfBirth,
    this.nationality,
    this.height,
    this.weight,
    this.dominantFoot,
    this.currentClub,
    this.positions = const [],
    this.jerseyNumber,
    this.yearsPlaying,
    this.email,
    this.phoneNumber,
    this.instagramHandle,
    this.twitterHandle,
    this.parentName,
    this.parentEmail,
    this.parentPhone,
    this.emergencyContact,
    this.isMinor = false,
  });

  /// Convert to Map for API submission
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'full_name': fullName,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'nationality': nationality,
      'height': height,
      'weight': weight,
      'dominant_foot': dominantFoot,
      'current_club': currentClub,
      'positions': positions,
      'jersey_number': jerseyNumber,
      'years_playing': yearsPlaying,
      'email': email,
      'phone_number': phoneNumber,
      'instagram_handle': instagramHandle,
      'twitter_handle': twitterHandle,
      'is_minor': isMinor,
    };

    // Add parent info if minor
    if (isMinor) {
      data['parent_name'] = parentName;
      data['parent_email'] = parentEmail;
      data['parent_phone'] = parentPhone;
      data['emergency_contact'] = emergencyContact;
      data['parental_consent_given'] = false; // Will need consent process
    }

    return data;
  }

  /// Calculate age from date of birth
  int? get age {
    if (dateOfBirth == null) return null;
    final now = DateTime.now();
    int age = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month ||
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      age--;
    }
    return age;
  }

  /// Calculate profile completeness (0-100%)
  int get completeness {
    int total = 0;
    int filled = 0;

    // Required fields
    total += 7; // name, dob, nationality, height, weight, dominant_foot, positions
    if (fullName.isNotEmpty) filled++;
    if (dateOfBirth != null) filled++;
    if (nationality != null && nationality!.isNotEmpty) filled++;
    if (height != null) filled++;
    if (weight != null) filled++;
    if (dominantFoot != null) filled++;
    if (positions.isNotEmpty) filled++;

    // Optional but important fields
    total += 3; // club, years playing, jersey number
    if (currentClub != null && currentClub!.isNotEmpty) filled++;
    if (yearsPlaying != null) filled++;
    if (jerseyNumber != null) filled++;

    // Contact fields
    total += 2; // email, phone
    if (email != null && email!.isNotEmpty) filled++;
    if (phoneNumber != null && phoneNumber!.isNotEmpty) filled++;

    // Parent fields if minor
    if (isMinor) {
      total += 3; // parent name, email, phone
      if (parentName != null && parentName!.isNotEmpty) filled++;
      if (parentEmail != null && parentEmail!.isNotEmpty) filled++;
      if (parentPhone != null && parentPhone!.isNotEmpty) filled++;
    }

    return ((filled / total) * 100).round();
  }

  /// Check if basic info step is complete
  bool get isBasicInfoComplete {
    return fullName.isNotEmpty &&
        dateOfBirth != null &&
        nationality != null &&
        nationality!.isNotEmpty &&
        height != null &&
        weight != null &&
        dominantFoot != null;
  }

  /// Check if football info step is complete
  bool get isFootballInfoComplete {
    return positions.isNotEmpty && yearsPlaying != null;
  }

  /// Check if contact step is complete
  bool get isContactInfoComplete {
    return email != null && email!.isNotEmpty;
  }

  /// Check if parent info step is complete (only for minors)
  bool get isParentInfoComplete {
    if (!isMinor) return true;
    return parentName != null &&
        parentName!.isNotEmpty &&
        parentEmail != null &&
        parentEmail!.isNotEmpty &&
        parentPhone != null &&
        parentPhone!.isNotEmpty;
  }

  ProfileSetupFormData copyWith({
    File? profilePhoto,
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
    String? parentName,
    String? parentEmail,
    String? parentPhone,
    String? emergencyContact,
    bool? isMinor,
  }) {
    return ProfileSetupFormData(
      profilePhoto: profilePhoto ?? this.profilePhoto,
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
      parentName: parentName ?? this.parentName,
      parentEmail: parentEmail ?? this.parentEmail,
      parentPhone: parentPhone ?? this.parentPhone,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      isMinor: isMinor ?? this.isMinor,
    );
  }
}
