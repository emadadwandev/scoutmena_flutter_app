/// Base class for all exceptions
class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => message;
}

/// Server exception (API errors)
class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.statusCode,
  });
}

/// Cache exception (local storage errors)
class CacheException extends AppException {
  const CacheException({required super.message});
}

/// Network exception (no internet, timeout)
class NetworkException extends AppException {
  const NetworkException({required super.message});
}

/// Authentication exception
class AuthenticationException extends AppException {
  const AuthenticationException({
    required super.message,
    super.statusCode,
  });
}

/// Validation exception
class ValidationException extends AppException {
  final Map<String, List<String>>? errors;

  const ValidationException({
    required super.message,
    this.errors,
    super.statusCode,
  });
}

/// Permission exception
class PermissionException extends AppException {
  const PermissionException({required super.message});
}

/// File exception (upload/download errors)
class FileException extends AppException {
  const FileException({required super.message});
}
