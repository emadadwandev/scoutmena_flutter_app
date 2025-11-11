/// Application-wide constants
class AppConstants {
  // App Info
  static const String appName = 'ScoutMena';
  static const String appVersion = '1.0.0';

  // API
  static const String baseUrl = 'https://scoutmena.com/api/v1';
  static const int apiTimeoutSeconds = 30;

  // Storage Keys
  static const String keyFirebaseToken = 'firebase_token';
  static const String keyUserId = 'user_id';
  static const String keyUserRole = 'user_role';
  static const String keyLanguage = 'app_language';
  static const String keyThemeMode = 'theme_mode';

  // Languages
  static const String languageEnglish = 'en';
  static const String languageArabic = 'ar';

  // User Roles
  static const String rolePlayer = 'player';
  static const String roleScout = 'scout';
  static const String roleCoach = 'coach';
  static const String roleParent = 'parent';
  static const String roleAdmin = 'admin';

  // Media Limits
  static const int maxPhotos = 10;
  static const int maxVideos = 5;
  static const int maxPhotoSizeMB = 10;
  static const int maxVideoSizeMB = 500;

  // COPPA Compliance
  static const int minimumAge = 13;
  static const int adultAge = 18;

  // Pagination
  static const int defaultPageSize = 20;
  static const int searchPageSize = 20;

  // Timeouts
  static const int videoProcessingPollIntervalSeconds = 3;
  static const int splashScreenDurationSeconds = 2;

  // Performance Targets
  static const int targetAppLaunchMilliseconds = 2000;
  static const int targetScreenTransitionMilliseconds = 300;

  AppConstants._();
}
