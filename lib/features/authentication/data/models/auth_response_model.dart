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
    return AuthResponseModel(
      success: json['success'] as bool? ?? true,
      message: json['message'] as String? ?? '',
      user: json['data'] != null && json['data']['user'] != null
          ? UserModel.fromJson(json['data']['user'] as Map<String, dynamic>)
          : null,
      requiresParentalConsent:
          json['data']?['requires_parental_consent'] as bool?,
      consentSentTo: json['data']?['consent_sent_to'] as String?,
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
