import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../network/api_client.dart';
import '../network/network_info.dart';
import '../services/firebase_auth_service.dart';
import '../../features/authentication/data/datasources/auth_local_datasource.dart';
import '../../features/authentication/data/datasources/auth_remote_datasource.dart';
import '../../features/authentication/data/repositories/auth_repository_impl.dart';
import '../../features/authentication/domain/repositories/auth_repository.dart';
import '../../features/authentication/domain/usecases/sign_in_with_phone.dart';
import '../../features/authentication/domain/usecases/verify_otp.dart';
import '../../features/authentication/domain/usecases/register_user.dart';
import '../../features/authentication/domain/usecases/login_with_firebase.dart';
import '../../features/authentication/domain/usecases/get_current_user.dart';
import '../../features/authentication/domain/usecases/logout.dart';
import '../../features/authentication/presentation/bloc/auth_bloc.dart';

final getIt = GetIt.instance;

/// Initialize dependency injection
Future<void> configureDependencies() async {
  // Initialize Hive
  await Hive.initFlutter();

  // Register SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // Register Firebase instances
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseAnalytics>(() => FirebaseAnalytics.instance);
  getIt.registerLazySingleton<FirebaseMessaging>(() => FirebaseMessaging.instance);

  // Register Storage
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
    ),
  );

  // Register Connectivity
  getIt.registerLazySingleton<Connectivity>(() => Connectivity());

  // Register Network Info
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfo(connectivity: getIt<Connectivity>()),
  );

  // Register API Client
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(
      secureStorage: getIt<FlutterSecureStorage>(),
      firebaseAuth: getIt<FirebaseAuth>(),
    ),
  );

  // Register Core Services
  getIt.registerLazySingleton<FirebaseAuthService>(
    () => FirebaseAuthService(getIt<FlutterSecureStorage>()),
  );

  // Register Authentication Data Sources
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(secureStorage: getIt<FlutterSecureStorage>()),
  );

  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      apiClient: getIt<ApiClient>(),
      firebaseAuthService: getIt<FirebaseAuthService>(),
    ),
  );

  // Register Authentication Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      localDataSource: getIt<AuthLocalDataSource>(),
      firebaseAuthService: getIt<FirebaseAuthService>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  // Register Authentication Use Cases
  getIt.registerLazySingleton(() => SignInWithPhone(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => VerifyOTP(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => RegisterUser(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => LoginWithFirebase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => GetCurrentUser(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => Logout(getIt<AuthRepository>()));

  // Register Authentication BLoC
  getIt.registerFactory(
    () => AuthBloc(
      signInWithPhone: getIt<SignInWithPhone>(),
      verifyOTP: getIt<VerifyOTP>(),
      registerUser: getIt<RegisterUser>(),
      loginWithFirebase: getIt<LoginWithFirebase>(),
      getCurrentUser: getIt<GetCurrentUser>(),
      logout: getIt<Logout>(),
    ),
  );
}

/// Reset all dependencies (useful for testing)
Future<void> resetDependencies() async {
  await getIt.reset();
}
