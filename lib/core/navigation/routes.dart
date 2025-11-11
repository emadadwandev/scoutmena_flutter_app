/// Application route constants
class AppRoutes {
  // Auth Routes
  static const String splash = '/';
  static const String phoneAuth = '/phone-auth';
  static const String otpVerification = '/otp-verification';
  static const String roleSelection = '/role-selection';
  static const String registration = '/registration';

  // Player Routes
  static const String playerDashboard = '/player/dashboard';
  static const String playerProfile = '/player/profile';
  static const String playerProfileSetup = '/player/profile-setup';
  static const String playerProfileEdit = '/player/profile-edit';
  static const String photoUpload = '/player/photos/upload';
  static const String photoGallery = '/player/photos/gallery';
  static const String videoUpload = '/player/videos/upload';
  static const String videoGallery = '/player/videos/gallery';
  static const String statistics = '/player/statistics';
  static const String analytics = '/player/analytics';

  // Scout Routes
  static const String scoutDashboard = '/scout/dashboard';
  static const String scoutProfile = '/scout/profile';
  static const String scoutProfileSetup = '/scout/profile-setup';
  static const String playerSearch = '/scout/search';
  static const String playerDetail = '/scout/player-detail';
  static const String savedSearches = '/scout/saved-searches';

  // Parent Routes
  static const String parentDashboard = '/parent/dashboard';
  static const String parentConsent = '/parent/consent';
  static const String childDetail = '/parent/child-detail';

  // Shared Routes
  static const String settings = '/settings';
  static const String privacySettings = '/settings/privacy';
  static const String notificationSettings = '/settings/notifications';
  static const String languageSettings = '/settings/language';
  static const String about = '/settings/about';
  static const String helpSupport = '/settings/help-support';
  static const String termsOfService = '/terms-of-service';
  static const String privacyPolicy = '/privacy-policy';

  AppRoutes._();
}
