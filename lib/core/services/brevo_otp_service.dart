import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../error/failures.dart';
import '../network/api_client.dart';
import '../constants/app_constants.dart';

/// Service for handling OTP authentication using Brevo SMS API
/// Replaces Firebase Phone Auth for OTP-based authentication
class BrevoOtpService {
  final ApiClient _apiClient;

  BrevoOtpService(this._apiClient);

  /// Send OTP to phone number via SMS or WhatsApp
  /// 
  /// [phoneNumber] - Phone in E.164 format (e.g., +966501234567)
  /// [method] - 'sms' or 'whatsapp' (default: sms)
  /// 
  /// Returns verification ID to be used for OTP verification
  Future<Either<Failure, String>> sendOtp({
    required String phoneNumber,
    String method = 'sms',
  }) async {
    try {
      // UI TESTING MODE: Return mock verification ID if bypass is enabled
      if (AppConstants.enableUITestingMode && AppConstants.bypassOTPVerification) {
        await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
        return const Right('mock-verification-id-for-testing');
      }

      final response = await _apiClient.post(
        '/auth/send-otp',
        data: {
          'phone': phoneNumber,
          'method': method,
        },
      );

      if (response.data['success'] == true) {
        final verificationId = response.data['data']['verification_id'] as String;
        return Right(verificationId);
      } else {
        return Left(ServerFailure(
          message: response.data['message'] ?? 'Failed to send OTP',
        ));
      }
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred: $e'));
    }
  }

  /// Verify OTP code
  /// 
  /// [verificationId] - UUID from sendOtp response
  /// [otp] - 6-digit OTP code entered by user
  /// 
  /// Returns phone number if verification successful
  Future<Either<Failure, String>> verifyOtp({
    required String verificationId,
    required String otp,
  }) async {
    try {
      // UI TESTING MODE: Always return success with mock phone if bypass enabled
      if (AppConstants.enableUITestingMode && AppConstants.bypassOTPVerification) {
        await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
        
        // Accept the test OTP or any 6-digit code in test mode
        if (otp == AppConstants.testOTP || otp.length == 6) {
          return const Right('+966501234567'); // Mock phone number
        } else {
          return Left(ServerFailure(message: 'Invalid OTP code'));
        }
      }

      final response = await _apiClient.post(
        '/auth/verify-otp',
        data: {
          'verification_id': verificationId,
          'otp': otp,
        },
      );

      if (response.data['success'] == true) {
        final phone = response.data['data']['phone'] as String;
        return Right(phone);
      } else {
        return Left(ServerFailure(
          message: response.data['message'] ?? 'OTP verification failed',
        ));
      }
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred: $e'));
    }
  }

  /// Resend OTP for existing verification
  /// 
  /// [verificationId] - UUID from previous sendOtp response
  /// 
  /// Returns new verification ID
  Future<Either<Failure, String>> resendOtp({
    required String verificationId,
  }) async {
    try {
      // UI TESTING MODE: Return same mock verification ID
      if (AppConstants.enableUITestingMode && AppConstants.bypassOTPVerification) {
        await Future.delayed(const Duration(milliseconds: 500));
        return const Right('mock-verification-id-for-testing');
      }

      final response = await _apiClient.post(
        '/auth/resend-otp',
        data: {
          'verification_id': verificationId,
        },
      );

      if (response.data['success'] == true) {
        final newVerificationId = response.data['data']['verification_id'] as String;
        return Right(newVerificationId);
      } else {
        return Left(ServerFailure(
          message: response.data['message'] ?? 'Failed to resend OTP',
        ));
      }
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred: $e'));
    }
  }

  /// Register user with verified OTP
  /// 
  /// [verificationId] - Verified verification ID
  /// [userData] - User registration data (firstName, lastName, accountType, etc.)
  /// 
  /// Returns user data and auth token
  Future<Either<Failure, Map<String, dynamic>>> registerWithOtp({
    required String verificationId,
    required Map<String, dynamic> userData,
  }) async {
    try {
      final response = await _apiClient.post(
        '/auth/register-with-otp',
        data: {
          'verification_id': verificationId,
          ...userData,
        },
      );

      if (response.data['success'] == true) {
        return Right(response.data['data'] as Map<String, dynamic>);
      } else {
        return Left(ServerFailure(
          message: response.data['message'] ?? 'Registration failed',
        ));
      }
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred: $e'));
    }
  }

  /// Login with verified OTP
  /// 
  /// [verificationId] - Verified verification ID
  /// [accountType] - 'player', 'scout', 'parent', or 'coach'
  /// 
  /// Returns user data and auth token
  Future<Either<Failure, Map<String, dynamic>>> loginWithOtp({
    required String verificationId,
    required String accountType,
  }) async {
    try {
      final response = await _apiClient.post(
        '/auth/login-with-otp',
        data: {
          'verification_id': verificationId,
          'account_type': accountType,
        },
      );

      if (response.data['success'] == true) {
        return Right(response.data['data'] as Map<String, dynamic>);
      } else {
        // Check if user not found (needs registration)
        final errorCode = response.data['error_code'];
        if (errorCode == 'USER_NOT_FOUND') {
          return Left(UserNotFoundFailure(
            message: response.data['message'] ?? 'User not found',
            requiresRegistration: response.data['data']?['requires_registration'] ?? true,
          ));
        }
        
        return Left(ServerFailure(
          message: response.data['message'] ?? 'Login failed',
        ));
      }
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred: $e'));
    }
  }

  /// Handle Dio errors and convert to Failures
  Failure _handleDioError(DioException error) {
    if (error.response != null) {
      final statusCode = error.response!.statusCode;
      final data = error.response!.data;
      
      String message = 'An error occurred';
      if (data is Map && data.containsKey('message')) {
        message = data['message'];
      }

      switch (statusCode) {
        case 400:
          return ServerFailure(message: message);
        case 401:
          return AuthenticationFailure(message: message);
        case 403:
          return AuthenticationFailure(message: message);
        case 404:
          return UserNotFoundFailure(message: message);
        case 422:
          return ValidationFailure(
            message: message,
            errors: data is Map ? data['errors'] : null,
          );
        case 429:
          return RateLimitFailure(
            message: message.isEmpty ? 'Too many requests. Please try again later.' : message,
          );
        default:
          return ServerFailure(message: message);
      }
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return NetworkFailure(message: 'Connection timeout. Please check your internet connection.');
    } else if (error.type == DioExceptionType.connectionError) {
      return NetworkFailure(message: 'No internet connection. Please check your network settings.');
    } else {
      return ServerFailure(message: 'An unexpected error occurred');
    }
  }
}

/// Custom failure for user not found (requires registration)
class UserNotFoundFailure extends Failure {
  final bool requiresRegistration;

  UserNotFoundFailure({
    required String message,
    this.requiresRegistration = true,
  }) : super(message: message);

  @override
  List<Object?> get props => [message, requiresRegistration];
}

/// Rate limit failure
class RateLimitFailure extends Failure {
  RateLimitFailure({required String message}) : super(message: message);
}
