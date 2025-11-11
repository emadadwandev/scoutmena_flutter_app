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
      final token = await firebaseAuthService.getFirebaseToken();
      if (token == null) {
        throw ServerException(message: 'Firebase token not found');
      }

      final response = await apiClient.post(
        '/auth/register',
        data: {
          'firebase_uid': firebaseUid,
          ...userData,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw ServerException(
        message: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  @override
  Future<UserModel> loginWithFirebase() async {
    try {
      final token = await firebaseAuthService.getFirebaseToken();
      if (token == null) {
        throw ServerException(message: 'Firebase token not found');
      }

      final response = await apiClient.post(
        '/auth/firebase-login',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.data['data'] == null || response.data['data']['user'] == null) {
        throw ServerException(message: 'User data not found in response');
      }

      return UserModel.fromJson(response.data['data']['user'] as Map<String, dynamic>);
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
    } catch (e) {
      throw ServerException(
        message: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }
}
