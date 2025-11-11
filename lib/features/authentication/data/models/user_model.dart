import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

class UserModel extends Equatable {
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

  const UserModel({
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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      firebaseUid: json['firebase_uid'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String,
      accountType: json['account_type'] as String,
      dateOfBirth: json['date_of_birth'] as String?,
      country: json['country'] as String?,
      profilePhotoUrl: json['profile_photo_url'] as String?,
      isActive: json['is_active'] == 1 || json['is_active'] == true,
      emailVerified: json['email_verified'] == 1 || json['email_verified'] == true,
      phoneVerified: json['phone_verified'] == 1 || json['phone_verified'] == true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firebase_uid': firebaseUid,
      'name': name,
      'email': email,
      'phone': phone,
      'account_type': accountType,
      'date_of_birth': dateOfBirth,
      'country': country,
      'profile_photo_url': profilePhotoUrl,
      'is_active': isActive,
      'email_verified': emailVerified,
      'phone_verified': phoneVerified,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      firebaseUid: firebaseUid,
      name: name,
      email: email,
      phone: phone,
      accountType: accountType,
      dateOfBirth: dateOfBirth,
      country: country,
      profilePhotoUrl: profilePhotoUrl,
      isActive: isActive,
      emailVerified: emailVerified,
      phoneVerified: phoneVerified,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      firebaseUid: entity.firebaseUid,
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      accountType: entity.accountType,
      dateOfBirth: entity.dateOfBirth,
      country: entity.country,
      profilePhotoUrl: entity.profilePhotoUrl,
      isActive: entity.isActive,
      emailVerified: entity.emailVerified,
      phoneVerified: entity.phoneVerified,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
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
