import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel?> getCachedUser();
  Future<void> cacheUser(UserModel user);
  Future<void> clearCache();
  Future<String?> getFirebaseToken();
  Future<void> saveFirebaseToken(String token);
  Future<void> saveAuthToken(String token);
  Future<String?> getAuthToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;

  AuthLocalDataSourceImpl({required this.secureStorage});

  static const String _userKey = 'user_data';
  static const String _tokenKey = 'firebase_token';
  static const String _authTokenKey = 'auth_token';

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final userJson = await secureStorage.read(key: _userKey);
      if (userJson == null) return null;

      final Map<String, dynamic> userMap = json.decode(userJson);
      return UserModel.fromJson(userMap);
    } catch (e) {
      throw CacheException(message: 'Failed to get cached user');
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final userJson = json.encode(user.toJson());
      await secureStorage.write(key: _userKey, value: userJson);
    } catch (e) {
      throw CacheException(message: 'Failed to cache user');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await secureStorage.delete(key: _userKey);
      await secureStorage.delete(key: _tokenKey);
      await secureStorage.delete(key: _authTokenKey);
    } catch (e) {
      throw CacheException(message: 'Failed to clear cache');
    }
  }

  @override
  Future<String?> getFirebaseToken() async {
    try {
      return await secureStorage.read(key: _tokenKey);
    } catch (e) {
      throw CacheException(message: 'Failed to get Firebase token');
    }
  }

  @override
  Future<void> saveFirebaseToken(String token) async {
    try {
      await secureStorage.write(key: _tokenKey, value: token);
    } catch (e) {
      throw CacheException(message: 'Failed to save Firebase token');
    }
  }

  @override
  Future<void> saveAuthToken(String token) async {
    try {
      await secureStorage.write(key: _authTokenKey, value: token);
    } catch (e) {
      throw CacheException(message: 'Failed to save auth token');
    }
  }

  @override
  Future<String?> getAuthToken() async {
    try {
      return await secureStorage.read(key: _authTokenKey);
    } catch (e) {
      throw CacheException(message: 'Failed to get auth token');
    }
  }
}
