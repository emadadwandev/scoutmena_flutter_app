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

  /// Convert to Map for API submission to /api/v1/player/profile
  /// Note: date_of_birth is NOT sent here - it's already stored in users table from registration
  Map<String, dynamic> toJson() {
    // Split full name into first and last name
    final nameParts = fullName.trim().split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    // Ensure last_name is never empty - backend requires it
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : 'Player';

    final data = <String, dynamic>{
      'first_name': firstName,
      'last_name': lastName,
      // DOB is NOT required for profile creation - it's read from user.date_of_birth
      'nationality': _convertCountryToIsoCode(nationality),
      'height_cm': height?.toInt(),
      'weight_kg': weight?.toInt(),
      'preferred_foot': dominantFoot,
      'current_club': currentClub,
      'primary_position': _convertPositionToBackendFormat(positions.isNotEmpty ? positions.first : null),
      'secondary_positions': positions.length > 1 
          ? positions.sublist(1).map((p) => _convertPositionToBackendFormat(p)).toList()
          : null,
      'jersey_number': jerseyNumber,
      'career_start_date': yearsPlaying != null 
          ? DateTime(DateTime.now().year - yearsPlaying!).toIso8601String()
          : null,
      'contact_email': email,
      'contact_phone': phoneNumber,
      'social_links': {
        if (instagramHandle != null && instagramHandle!.isNotEmpty)
          'instagram': instagramHandle,
        if (twitterHandle != null && twitterHandle!.isNotEmpty)
          'twitter': twitterHandle,
      },
    };

    // Parent info is NOT needed for profile creation - consent was handled at registration
    // Profile will inherit minor status from user.age and apply safeguards automatically

    return data;
  }

  /// Convert country name to ISO 3166-1 alpha-3 code
  String? _convertCountryToIsoCode(String? countryName) {
    if (countryName == null) return null;
    
    // Common country mappings (expand as needed)
    final countryMap = {
      'Oman': 'OMN',
      'United Arab Emirates': 'ARE',
      'Saudi Arabia': 'SAU',
      'Qatar': 'QAT',
      'Kuwait': 'KWT',
      'Bahrain': 'BHR',
      'Egypt': 'EGY',
      'Jordan': 'JOR',
      'Lebanon': 'LBN',
      'Iraq': 'IRQ',
      'Syria': 'SYR',
      'Palestine': 'PSE',
      'Yemen': 'YEM',
      'Morocco': 'MAR',
      'Algeria': 'DZA',
      'Tunisia': 'TUN',
      'Libya': 'LBY',
      'Sudan': 'SDN',
      'Somalia': 'SOM',
      'Djibouti': 'DJI',
      'Comoros': 'COM',
      'Mauritania': 'MRT',
    };
    
    return countryMap[countryName];
  }

  /// Convert position abbreviation to backend format
  String? _convertPositionToBackendFormat(String? position) {
    if (position == null) return null;
    
    // Position mappings from Flutter abbreviations to backend format
    final positionMap = {
      'GK': 'goalkeeper',
      'CB': 'center_back',
      'RB': 'right_back',
      'LB': 'left_back',
      'CDM': 'defensive_midfielder',
      'CM': 'central_midfielder',
      'CAM': 'attacking_midfielder',
      'RW': 'right_winger',
      'LW': 'left_winger',
      'ST': 'striker',
      'CF': 'second_striker',
    };
    
    return positionMap[position];
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
