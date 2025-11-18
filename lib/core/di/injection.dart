import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../network/api_client.dart';
import '../network/network_info.dart';
import '../services/firebase_auth_service.dart';
import '../services/notification_service.dart';
import '../../features/authentication/data/datasources/auth_local_datasource.dart';
import '../../features/authentication/data/datasources/auth_remote_datasource.dart';
import '../../features/authentication/data/repositories/auth_repository_impl.dart';
import '../../features/authentication/domain/repositories/auth_repository.dart';
import '../../features/authentication/domain/usecases/sign_in_with_phone.dart';
import '../../features/authentication/domain/usecases/verify_otp.dart';
import '../../features/authentication/domain/usecases/register_user.dart';
import '../../features/authentication/domain/usecases/login_with_firebase.dart';
import '../../features/authentication/domain/usecases/login_with_email_password.dart';
import '../../features/authentication/domain/usecases/get_current_user.dart';
import '../../features/authentication/domain/usecases/logout.dart';
import '../../features/authentication/domain/usecases/send_brevo_otp.dart';
import '../../features/authentication/domain/usecases/verify_brevo_otp.dart';
import '../../features/authentication/domain/usecases/register_with_brevo_otp.dart';
import '../../features/authentication/domain/usecases/login_with_brevo_otp.dart';
import '../../features/authentication/presentation/bloc/auth_bloc.dart';
import '../services/brevo_otp_service.dart';
import '../../features/player_profile/data/datasources/player_remote_data_source.dart';
import '../../features/player_profile/data/repositories/player_repository_impl.dart';
import '../../features/player_profile/domain/repositories/player_repository.dart';
import '../../features/player_profile/domain/usecases/get_player_profile.dart';
import '../../features/player_profile/domain/usecases/create_player_profile.dart';
import '../../features/player_profile/domain/usecases/update_player_profile.dart';
import '../../features/player_profile/domain/usecases/upload_profile_photo.dart';
import '../../features/player_profile/domain/usecases/get_player_photos.dart';
import '../../features/player_profile/domain/usecases/upload_player_photo.dart';
import '../../features/player_profile/domain/usecases/delete_player_photo.dart';
import '../../features/player_profile/domain/usecases/get_player_videos.dart';
import '../../features/player_profile/domain/usecases/upload_player_video.dart';
import '../../features/player_profile/domain/usecases/delete_player_video.dart';
import '../../features/player_profile/domain/usecases/get_player_stats.dart';
import '../../features/player_profile/domain/usecases/create_player_stat.dart';
import '../../features/player_profile/domain/usecases/update_player_stat.dart';
import '../../features/player_profile/domain/usecases/delete_player_stat.dart';
import '../../features/player_profile/presentation/bloc/player_profile_bloc.dart';
import '../../features/scout_profile/data/datasources/scout_remote_data_source.dart';
import '../../features/scout_profile/data/repositories/scout_repository_impl.dart';
import '../../features/scout_profile/domain/repositories/scout_repository.dart';
import '../../features/scout_profile/domain/usecases/get_scout_profile.dart';
import '../../features/scout_profile/domain/usecases/create_scout_profile.dart';
import '../../features/scout_profile/domain/usecases/update_scout_profile.dart';
import '../../features/scout_profile/domain/usecases/search_players.dart';
import '../../features/scout_profile/domain/usecases/get_saved_searches.dart';
import '../../features/scout_profile/domain/usecases/save_search.dart';
import '../../features/scout_profile/domain/usecases/delete_saved_search.dart';
import '../../features/scout_profile/domain/usecases/execute_saved_search.dart';
import '../../features/scout_profile/presentation/bloc/scout_profile_bloc.dart';
import '../../features/scout_profile/presentation/bloc/saved_searches_bloc.dart';
import '../../features/scout_profile/presentation/bloc/player_search_bloc.dart';
import '../../features/coach_profile/data/datasources/coach_remote_data_source.dart';
import '../../features/coach_profile/data/repositories/coach_repository_impl.dart';
import '../../features/coach_profile/domain/repositories/coach_repository.dart';
import '../../features/coach_profile/domain/usecases/get_coach_profile.dart';
import '../../features/coach_profile/domain/usecases/create_coach_profile.dart';
import '../../features/coach_profile/domain/usecases/update_coach_profile.dart';
import '../../features/coach_profile/domain/usecases/get_coach_teams.dart';
import '../../features/coach_profile/domain/usecases/create_team.dart';
import '../../features/coach_profile/domain/usecases/manage_team_players.dart';
import '../../features/coach_profile/presentation/bloc/coach_profile_bloc.dart';

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

  // Register Brevo OTP Service
  getIt.registerLazySingleton<BrevoOtpService>(
    () => BrevoOtpService(getIt<ApiClient>()),
  );

  // Register FlutterLocalNotificationsPlugin
  getIt.registerLazySingleton<FlutterLocalNotificationsPlugin>(
    () => FlutterLocalNotificationsPlugin(),
  );

  // Register Notification Service
  getIt.registerLazySingleton<NotificationService>(
    () => NotificationService(
      getIt<FirebaseMessaging>(),
      getIt<FlutterLocalNotificationsPlugin>(),
      getIt<ApiClient>().dio,
    ),
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
      brevoOtpService: getIt<BrevoOtpService>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  // Register Authentication Use Cases (Legacy Firebase)
  getIt.registerLazySingleton(() => SignInWithPhone(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => VerifyOTP(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => RegisterUser(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => LoginWithFirebase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => LoginWithEmailPassword(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => GetCurrentUser(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => Logout(getIt<AuthRepository>()));

  // Register Brevo OTP Use Cases
  getIt.registerLazySingleton(() => SendBrevoOtp(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => VerifyBrevoOtp(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => RegisterWithBrevoOtp(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => LoginWithBrevoOtp(getIt<AuthRepository>()));

  // Register Authentication BLoC
  getIt.registerFactory(
    () => AuthBloc(
      signInWithPhone: getIt<SignInWithPhone>(),
      verifyOTP: getIt<VerifyOTP>(),
      registerUser: getIt<RegisterUser>(),
      loginWithFirebase: getIt<LoginWithFirebase>(),
      loginWithEmailPassword: getIt<LoginWithEmailPassword>(),
      getCurrentUser: getIt<GetCurrentUser>(),
      logout: getIt<Logout>(),
      sendBrevoOtp: getIt<SendBrevoOtp>(),
      verifyBrevoOtp: getIt<VerifyBrevoOtp>(),
      registerWithBrevoOtp: getIt<RegisterWithBrevoOtp>(),
      loginWithBrevoOtp: getIt<LoginWithBrevoOtp>(),
    ),
  );

  // ========== Player Profile Module ==========
  
  // Register Player Profile Data Source
  getIt.registerLazySingleton<PlayerRemoteDataSource>(
    () => PlayerRemoteDataSourceImpl(getIt<ApiClient>().dio),
  );

  // Register Player Profile Repository
  getIt.registerLazySingleton<PlayerRepository>(
    () => PlayerRepositoryImpl(getIt<PlayerRemoteDataSource>()),
  );

  // Register Player Profile Use Cases
  getIt.registerLazySingleton(() => GetPlayerProfile(getIt<PlayerRepository>()));
  getIt.registerLazySingleton(() => CreatePlayerProfile(getIt<PlayerRepository>()));
  getIt.registerLazySingleton(() => UpdatePlayerProfile(getIt<PlayerRepository>()));
  getIt.registerLazySingleton(() => UploadProfilePhoto(getIt<PlayerRepository>()));
  getIt.registerLazySingleton(() => GetPlayerPhotos(getIt<PlayerRepository>()));
  getIt.registerLazySingleton(() => UploadPlayerPhoto(getIt<PlayerRepository>()));
  getIt.registerLazySingleton(() => DeletePlayerPhoto(getIt<PlayerRepository>()));
  getIt.registerLazySingleton(() => GetPlayerVideos(getIt<PlayerRepository>()));
  getIt.registerLazySingleton(() => UploadPlayerVideo(getIt<PlayerRepository>()));
  getIt.registerLazySingleton(() => DeletePlayerVideo(getIt<PlayerRepository>()));
  getIt.registerLazySingleton(() => GetPlayerStats(getIt<PlayerRepository>()));
  getIt.registerLazySingleton(() => CreatePlayerStat(getIt<PlayerRepository>()));
  getIt.registerLazySingleton(() => UpdatePlayerStat(getIt<PlayerRepository>()));
  getIt.registerLazySingleton(() => DeletePlayerStat(getIt<PlayerRepository>()));

  // Register Player Profile BLoC
  getIt.registerFactory(
    () => PlayerProfileBloc(
      getIt<GetPlayerProfile>(),
      getIt<CreatePlayerProfile>(),
      getIt<UpdatePlayerProfile>(),
      getIt<UploadProfilePhoto>(),
      getIt<GetPlayerPhotos>(),
      getIt<UploadPlayerPhoto>(),
      getIt<DeletePlayerPhoto>(),
      getIt<GetPlayerVideos>(),
      getIt<UploadPlayerVideo>(),
      getIt<DeletePlayerVideo>(),
      getIt<GetPlayerStats>(),
      getIt<CreatePlayerStat>(),
      getIt<UpdatePlayerStat>(),
      getIt<DeletePlayerStat>(),
    ),
  );

  // ========== Scout Profile Module ==========
  
  // Register Scout Profile Data Source
  getIt.registerLazySingleton<ScoutRemoteDataSource>(
    () => ScoutRemoteDataSourceImpl(getIt<ApiClient>().dio),
  );

  // Register Scout Profile Repository
  getIt.registerLazySingleton<ScoutRepository>(
    () => ScoutRepositoryImpl(getIt<ScoutRemoteDataSource>()),
  );

  // Register Scout Profile Use Cases
  getIt.registerLazySingleton(() => GetScoutProfile(getIt<ScoutRepository>()));
  getIt.registerLazySingleton(() => CreateScoutProfile(getIt<ScoutRepository>()));
  getIt.registerLazySingleton(() => UpdateScoutProfile(getIt<ScoutRepository>()));
  getIt.registerLazySingleton(() => SearchPlayers(getIt<ScoutRepository>()));
  getIt.registerLazySingleton(() => GetSavedSearches(getIt<ScoutRepository>()));
  getIt.registerLazySingleton(() => SaveSearch(getIt<ScoutRepository>()));
  getIt.registerLazySingleton(() => DeleteSavedSearch(getIt<ScoutRepository>()));
  getIt.registerLazySingleton(() => ExecuteSavedSearch(getIt<ScoutRepository>()));

  // Register Scout Profile BLoCs
  getIt.registerFactory(
    () => ScoutProfileBloc(
      getIt<GetScoutProfile>(),
      getIt<CreateScoutProfile>(),
      getIt<UpdateScoutProfile>(),
    ),
  );

  getIt.registerFactory(
    () => SavedSearchesBloc(
      getIt<GetSavedSearches>(),
      getIt<SaveSearch>(),
      getIt<DeleteSavedSearch>(),
      getIt<ExecuteSavedSearch>(),
    ),
  );

  getIt.registerFactory(
    () => PlayerSearchBloc(
      getIt<SearchPlayers>(),
    ),
  );

  // ========== Coach Profile Module ==========
  
  // Register Coach Profile Data Source
  getIt.registerLazySingleton<CoachRemoteDataSource>(
    () => CoachRemoteDataSource(getIt<ApiClient>().dio),
  );

  // Register Coach Profile Repository
  getIt.registerLazySingleton<CoachRepository>(
    () => CoachRepositoryImpl(getIt<CoachRemoteDataSource>()),
  );

  // Register Coach Profile Use Cases
  getIt.registerLazySingleton(() => GetCoachProfile(getIt<CoachRepository>()));
  getIt.registerLazySingleton(() => CreateCoachProfile(getIt<CoachRepository>()));
  getIt.registerLazySingleton(() => UpdateCoachProfile(getIt<CoachRepository>()));
  getIt.registerLazySingleton(() => GetCoachTeams(getIt<CoachRepository>()));
  getIt.registerLazySingleton(() => CreateTeam(getIt<CoachRepository>()));
  getIt.registerLazySingleton(() => AddPlayerToTeam(getIt<CoachRepository>()));
  getIt.registerLazySingleton(() => RemovePlayerFromTeam(getIt<CoachRepository>()));

  // Register Coach Profile BLoC
  getIt.registerFactory(
    () => CoachProfileBloc(
      getIt<GetCoachProfile>(),
      getIt<CreateCoachProfile>(),
      getIt<UpdateCoachProfile>(),
      getIt<GetCoachTeams>(),
      getIt<CreateTeam>(),
      getIt<AddPlayerToTeam>(),
      getIt<RemovePlayerFromTeam>(),
    ),
  );
}

/// Reset all dependencies (useful for testing)
Future<void> resetDependencies() async {
  await getIt.reset();
}
