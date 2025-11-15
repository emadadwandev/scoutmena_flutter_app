import 'package:equatable/equatable.dart';

/// Base class for all failures
abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Server failure (API errors, 500, etc.)
class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

/// Cache failure (local storage errors)
class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

/// Network failure (no internet, timeout, etc.)
class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

/// Authentication failure (invalid credentials, token expired, etc.)
class AuthenticationFailure extends Failure {
  const AuthenticationFailure({required super.message});
}

/// Validation failure (form validation errors)
class ValidationFailure extends Failure {
  final Map<String, List<String>>? errors;

  const ValidationFailure({
    required super.message,
    this.errors,
  });

  @override
  List<Object?> get props => [message, errors];
}

/// Permission failure (camera, storage, location, etc.)
class PermissionFailure extends Failure {
  const PermissionFailure({required super.message});
}

/// File failure (upload, download, processing errors)
class FileFailure extends Failure {
  const FileFailure({required super.message});
}

/// Parental consent required failure (minor registration)
class ParentalConsentRequiredFailure extends Failure {
  final String? consentId;

  const ParentalConsentRequiredFailure({
    required super.message,
    this.consentId,
  });

  @override
  List<Object?> get props => [message, consentId];
}

/// Unknown/Generic failure
class UnknownFailure extends Failure {
  const UnknownFailure({required super.message});
}
