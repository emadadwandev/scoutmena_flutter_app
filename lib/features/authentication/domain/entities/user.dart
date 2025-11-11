import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String firebaseUid;
  final String name;
  final String? email;
  final String phone;
  final String accountType;
  final String? dateOfBirth;
  final String? country;
  final String? profilePhotoUrl;
  final bool isActive;
  final bool emailVerified;
  final bool phoneVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserEntity({
    required this.id,
    required this.firebaseUid,
    required this.name,
    this.email,
    required this.phone,
    required this.accountType,
    this.dateOfBirth,
    this.country,
    this.profilePhotoUrl,
    required this.isActive,
    required this.emailVerified,
    required this.phoneVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isPlayer => accountType == 'player';
  bool get isScout => accountType == 'scout';
  bool get isParent => accountType == 'parent';

  int? get age {
    if (dateOfBirth == null) return null;
    final dob = DateTime.tryParse(dateOfBirth!);
    if (dob == null) return null;
    
    final now = DateTime.now();
    int age = now.year - dob.year;
    if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return age;
  }

  bool get isMinor {
    final userAge = age;
    return userAge != null && userAge < 18;
  }

  @override
  List<Object?> get props => [
        id,
        firebaseUid,
        name,
        email,
        phone,
        accountType,
        dateOfBirth,
        country,
        profilePhotoUrl,
        isActive,
        emailVerified,
        phoneVerified,
        createdAt,
        updatedAt,
      ];
}
