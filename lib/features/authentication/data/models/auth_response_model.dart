import 'package:equatable/equatable.dart';
import 'user_model.dart';

class AuthResponseModel extends Equatable {
  final bool success;
  final String message;
  final UserModel? user;
  final bool? requiresParentalConsent;
  final String? consentSentTo;

  const AuthResponseModel({
    required this.success,
    required this.message,
    this.user,
    this.requiresParentalConsent,
    this.consentSentTo,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    // Check if this is a parental consent response
    final data = json['data'] as Map<String, dynamic>?;
    final requiresConsent = data?['requires_parental_consent'] as bool? ?? false;
    
    return AuthResponseModel(
      success: json['success'] as bool? ?? true,
      message: json['message'] as String? ?? '',
      user: data != null && data['user'] != null
          ? UserModel.fromJson(data['user'] as Map<String, dynamic>)
          : null,
      requiresParentalConsent: requiresConsent,
      consentSentTo: data?['parental_consent_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': {
        'user': user?.toJson(),
        'requires_parental_consent': requiresParentalConsent,
        'consent_sent_to': consentSentTo,
      },
    };
  }

  @override
  List<Object?> get props => [
        success,
        message,
        user,
        requiresParentalConsent,
        consentSentTo,
      ];
}
