import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/app_constants.dart';
import '../error/exceptions.dart';

/// API Client with Firebase authentication and automatic token refresh
class ApiClient {
  late final Dio _dio;
  final FlutterSecureStorage _secureStorage;
  final FirebaseAuth _firebaseAuth;

  ApiClient({
    required FlutterSecureStorage secureStorage,
    required FirebaseAuth firebaseAuth,
  })  : _secureStorage = secureStorage,
        _firebaseAuth = firebaseAuth {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: Duration(seconds: AppConstants.apiTimeoutSeconds),
        receiveTimeout: Duration(seconds: AppConstants.apiTimeoutSeconds),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    // Add Firebase token interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          try {
            // UI TESTING MODE: Use mock token if bypass is enabled
            if (AppConstants.enableUITestingMode && AppConstants.bypassFirebaseAuth) {
              // First check for auth token (Sanctum), then fallback to mock Firebase token
              final authToken = await _secureStorage.read(
                key: AppConstants.keyAuthToken,
              );
              
              if (authToken != null && authToken.isNotEmpty) {
                print('🔑 Using Sanctum token (testing mode): ${authToken.substring(0, 20)}...');
                options.headers['Authorization'] = 'Bearer $authToken';
              } else {
                print('🔑 Using mock Firebase token (testing mode)');
                options.headers['Authorization'] = 'Bearer ${AppConstants.mockFirebaseToken}';
              }
              return handler.next(options);
            }
            
            // Priority 1: Check for Sanctum auth token (from email/password login)
            final authToken = await _secureStorage.read(
              key: AppConstants.keyAuthToken,
            );
            
            if (authToken != null && authToken.isNotEmpty) {
              print('🔑 Using Sanctum auth token: ${authToken.substring(0, 20)}...');
              options.headers['Authorization'] = 'Bearer $authToken';
              return handler.next(options);
            }
            
            // Priority 2: Get Firebase ID token from secure storage
            final firebaseToken = await _secureStorage.read(
              key: AppConstants.keyFirebaseToken,
            );

            if (firebaseToken != null && firebaseToken.isNotEmpty) {
              print('🔑 Using Firebase token: ${firebaseToken.substring(0, 20)}...');
              options.headers['Authorization'] = 'Bearer $firebaseToken';
            } else {
              print('⚠️ No auth token found in storage!');
            }

            return handler.next(options);
          } catch (e) {
            return handler.next(options);
          }
        },
        onError: (error, handler) async {
          // Handle 401 Unauthorized - token expired
          if (error.response?.statusCode == 401) {
            try {
              // Attempt to refresh Firebase token
              final refreshed = await _refreshFirebaseToken();

              if (refreshed) {
                // Retry the failed request with new token
                final response = await _retry(error.requestOptions);
                return handler.resolve(response);
              }
            } catch (e) {
              // If refresh fails, return authentication error
              return handler.reject(
                DioException(
                  requestOptions: error.requestOptions,
                  error: const AuthenticationException(
                    message: 'Session expired. Please login again.',
                    statusCode: 401,
                  ),
                ),
              );
            }
          }

          return handler.next(error);
        },
      ),
    );

    // Add logging interceptor (only in debug mode)
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
  }

  /// Get Dio instance for direct use
  Dio get dio => _dio;

  /// Store authentication token (Sanctum token from email/password login)
  Future<void> setAuthToken(String token) async {
    await _secureStorage.write(
      key: AppConstants.keyAuthToken,
      value: token,
    );
  }

  /// Clear authentication token
  Future<void> clearAuthToken() async {
    await _secureStorage.delete(key: AppConstants.keyAuthToken);
  }

  /// Clear all stored tokens (auth + Firebase)
  Future<void> clearAllTokens() async {
    print('🗑️ Clearing all stored tokens...');
    await _secureStorage.delete(key: AppConstants.keyAuthToken);
    await _secureStorage.delete(key: AppConstants.keyFirebaseToken);
    print('✅ All tokens cleared');
  }

  /// Refresh Firebase authentication token
  Future<bool> _refreshFirebaseToken() async {
    try {
      final user = _firebaseAuth.currentUser;

      if (user == null) {
        throw const AuthenticationException(
          message: 'User not authenticated',
        );
      }

      // Force refresh the token
      final token = await user.getIdToken(true);

      if (token != null) {
        // Store the new token
        await _secureStorage.write(
          key: AppConstants.keyFirebaseToken,
          value: token,
        );
        return true;
      }

      return false;
    } catch (e) {
      throw AuthenticationException(
        message: 'Failed to refresh token: ${e.toString()}',
      );
    }
  }

  /// Retry a failed request with updated token
  Future<Response> _retry(RequestOptions requestOptions) async {
    try {
      // Get the refreshed token
      final token = await _secureStorage.read(
        key: AppConstants.keyFirebaseToken,
      );

      // Update authorization header
      final headers = Map<String, dynamic>.from(requestOptions.headers);
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final options = Options(
        method: requestOptions.method,
        headers: headers,
      );

      return await _dio.request(
        requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        onSendProgress: onSendProgress,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// PATCH request
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Handle Dio exceptions and convert to app exceptions
  AppException _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException(
          message: 'Connection timeout. Please check your internet connection.',
        );

      case DioExceptionType.connectionError:
        return const NetworkException(
          message: 'No internet connection. Please check your network.',
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;

        // Try to extract error message from response
        String message = 'An error occurred';

        if (data is Map<String, dynamic>) {
          message = data['message'] ?? data['error'] ?? message;

          // Handle validation errors
          if (data.containsKey('errors') && data['errors'] is Map) {
            return ValidationException(
              message: message,
              errors: Map<String, List<String>>.from(
                (data['errors'] as Map).map(
                  (key, value) => MapEntry(
                    key.toString(),
                    value is List
                        ? value.map((e) => e.toString()).toList()
                        : [value.toString()],
                  ),
                ),
              ),
              statusCode: statusCode,
            );
          }
        } else if (data is String) {
          message = data;
        }

        if (statusCode == 401 || statusCode == 403) {
          return AuthenticationException(
            message: message,
            statusCode: statusCode,
          );
        }

        return ServerException(
          message: message,
          statusCode: statusCode,
        );

      case DioExceptionType.cancel:
        return const ServerException(
          message: 'Request was cancelled',
        );

      case DioExceptionType.badCertificate:
        return const NetworkException(
          message: 'Certificate verification failed',
        );

      case DioExceptionType.unknown:
        return ServerException(
          message: error.message ?? 'Unknown error occurred',
        );
    }
  }

  /// Clear stored tokens (for logout)
  Future<void> clearTokens() async {
    await _secureStorage.delete(key: AppConstants.keyFirebaseToken);
    await _secureStorage.delete(key: AppConstants.keyUserId);
    await _secureStorage.delete(key: AppConstants.keyUserRole);
  }
}
