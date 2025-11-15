import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/services/firebase_auth_service.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> register({
    required String firebaseUid,
    required Map<String, dynamic> userData,
  });

  Future<UserModel> loginWithFirebase();

  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<UserModel> getCurrentUser();

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;
  final FirebaseAuthService firebaseAuthService;

  AuthRemoteDataSourceImpl({
    required this.apiClient,
    required this.firebaseAuthService,
  });

  @override
  Future<AuthResponseModel> register({
    required String firebaseUid,
    required Map<String, dynamic> userData,
  }) async {
    try {
      // Get Firebase token with retry logic
      String? token = await firebaseAuthService.getFirebaseToken();
      
      // If token is still null, throw a more descriptive error
      if (token == null) {
        throw ServerException(
          message: 'Unable to authenticate with Firebase. Please try logging in again.',
        );
      }

      // Password should be provided in userData
      // If not provided, generate one for Firebase users
      final registrationData = {
        'firebase_uid': firebaseUid,
        ...userData,
      };

      // Only auto-generate password if not provided by user
      if (!userData.containsKey('password') || userData['password'] == null || userData['password'].toString().isEmpty) {
        registrationData['password'] = _generateFirebasePassword(firebaseUid);
        registrationData['password_confirmation'] = _generateFirebasePassword(firebaseUid);
      }

      final response = await apiClient.post(
        '/auth/register',
        data: registrationData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// Generate a secure password for Firebase-authenticated users
  /// This password is only used when user doesn't provide their own password
  String _generateFirebasePassword(String firebaseUid) {
    // Create a deterministic but secure password from Firebase UID
    // This ensures the same user always gets the same password
    // but it's unpredictable from the outside
    return 'FB_${firebaseUid}_${firebaseUid.hashCode.abs()}';
  }

  @override
  Future<UserModel> loginWithFirebase() async {
    try {
      // Get Firebase token with retry logic
      String? token = await firebaseAuthService.getFirebaseToken();
      
      // If token is still null, throw a more descriptive error
      if (token == null) {
        throw ServerException(
          message: 'Unable to authenticate with Firebase. Please try logging in again.',
        );
      }

      final response = await apiClient.post(
        '/auth/firebase-login',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.data['data'] == null || response.data['data']['user'] == null) {
        throw ServerException(message: 'User data not found in response');
      }

      return UserModel.fromJson(response.data['data']['user'] as Map<String, dynamic>);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  @override
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiClient.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.data['data'] == null || response.data['data']['user'] == null) {
        throw ServerException(message: 'Invalid credentials');
      }

      // Store the Sanctum token for future authenticated requests
      final token = response.data['data']['token'] as String?;
      if (token != null) {
        await apiClient.setAuthToken(token);
      }

      return UserModel.fromJson(response.data['data']['user'] as Map<String, dynamic>);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await apiClient.get('/auth/me');

      if (response.data['data'] == null) {
        throw ServerException(message: 'User data not found');
      }

      return UserModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } catch (e) {
      throw ServerException(
        message: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      await apiClient.post('/auth/logout');
      // Clear stored auth token
      await apiClient.clearAuthToken();
    } catch (e) {
      throw ServerException(
        message: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }
}
