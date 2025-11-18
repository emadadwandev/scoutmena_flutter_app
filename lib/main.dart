import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'core/navigation/routes.dart';
import 'core/services/notification_service.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations_temp.dart';
import 'features/onboarding/presentation/pages/splash_screen.dart';
import 'features/onboarding/presentation/pages/onboarding_page.dart';
import 'features/authentication/presentation/pages/login_page.dart';
import 'features/authentication/presentation/pages/phone_auth_page.dart';
import 'features/authentication/presentation/pages/otp_verification_page.dart';
import 'features/authentication/presentation/pages/role_selection_page.dart';
import 'features/authentication/presentation/pages/registration_page.dart';
import 'features/authentication/presentation/bloc/auth_bloc.dart';
import 'features/authentication/presentation/bloc/auth_event.dart';
import 'features/player_profile/presentation/pages/player_dashboard_page.dart';
import 'features/player_profile/presentation/pages/player_profile_setup_page.dart';
import 'features/player_profile/presentation/pages/player_profile_view_page.dart';
import 'features/player_profile/presentation/pages/player_profile_edit_page.dart';
import 'features/player_profile/presentation/pages/photo_gallery_management_page.dart';
import 'features/player_profile/presentation/pages/video_gallery_management_page.dart';
import 'features/player_profile/presentation/pages/statistics_management_page.dart';
import 'features/player_profile/presentation/pages/profile_analytics_page.dart';
import 'features/player_profile/presentation/pages/photo_viewer_page.dart';
import 'features/player_profile/presentation/pages/video_player_page.dart';
import 'features/player_profile/domain/entities/player_photo.dart';
import 'features/player_profile/domain/entities/player_video.dart';
import 'features/player_profile/presentation/bloc/player_profile_bloc.dart';
import 'features/player_profile/presentation/bloc/player_profile_state.dart';
import 'features/player_profile/presentation/bloc/player_profile_event.dart';
import 'features/authentication/presentation/bloc/auth_state.dart';
import 'features/scout_profile/presentation/pages/scout_dashboard_page.dart';
import 'features/scout_profile/presentation/bloc/scout_profile_bloc.dart';
import 'features/scout_profile/presentation/bloc/saved_searches_bloc.dart';
import 'features/coach_profile/presentation/pages/coach_dashboard_page.dart';
import 'features/coach_profile/presentation/bloc/coach_profile_bloc.dart';
import 'features/settings/presentation/pages/faq_page.dart';
import 'features/settings/presentation/pages/tutorials_page.dart';
import 'features/settings/presentation/pages/blocked_users_page.dart';
import 'features/messaging/presentation/pages/messaging_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize dependency injection
  await configureDependencies();

  // Initialize push notifications
  try {
    final notificationService = getIt<NotificationService>();
    await notificationService.initialize();
  } catch (e) {
    debugPrint('Failed to initialize notifications: $e');
    // Don't block app launch if notifications fail
  }

  runApp(const ScoutMenaApp());
}

class ScoutMenaApp extends StatefulWidget {
  const ScoutMenaApp({super.key});

  @override
  State<ScoutMenaApp> createState() => _ScoutMenaAppState();
}

class _ScoutMenaAppState extends State<ScoutMenaApp> {
  Locale _locale = const Locale('en'); // Default to English
  ThemeMode _themeMode = ThemeMode.system;

  void _changeLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  void _changeThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthBloc>(),
      child: MaterialApp(
        title: 'ScoutMena',
        debugShowCheckedModeBanner: false,

        // Localization
        locale: _locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'), // English
          Locale('ar'), // Arabic
        ],

        // Theme
        theme: AppTheme.getTheme(
          isDark: false,
          languageCode: _locale.languageCode,
        ),
        darkTheme: AppTheme.getTheme(
          isDark: true,
          languageCode: _locale.languageCode,
        ),
        themeMode: _themeMode,

        // Routing
        initialRoute: AppRoutes.splash,
        onGenerateRoute: _generateRoute,
      ),
    );
  }

  Route<dynamic>? _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingPage());

      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case AppRoutes.phoneAuth:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => PhoneAuthPage(
            mode: args?['mode'] as String? ?? 'login',
          ),
        );

      case AppRoutes.otpVerification:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => OTPVerificationPage(
            verificationId: args['verificationId'] as String,
            phoneNumber: args['phoneNumber'] as String,
            mode: args['mode'] as String? ?? 'login',
          ),
        );

      case AppRoutes.roleSelection:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => RoleSelectionPage(
            firebaseUid: args['firebaseUid'] as String,
          ),
        );

      case AppRoutes.registration:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => RegistrationPage(
            // Support both legacy Firebase and new Brevo OTP registration flows
            firebaseUid: args['firebaseUid'] as String?,
            verificationId: args['verificationId'] as String?,
            phoneNumber: args['phoneNumber'] as String,
            accountType: args['accountType'] as String?, // Optional now
          ),
        );

      case AppRoutes.playerProfileSetup:
        return MaterialPageRoute(
          builder: (_) => const PlayerProfileSetupPage(),
        );

      case AppRoutes.playerProfile:
        final playerId = settings.arguments as String? ?? 'current';
        return MaterialPageRoute(
          builder: (_) => PlayerProfileViewPage(playerId: playerId),
        );

      case AppRoutes.playerProfileEdit:
        // Get userId from AuthBloc - this route is accessed from within the app
        final userId = context.read<AuthBloc>().state is AuthAuthenticated 
          ? (context.read<AuthBloc>().state as AuthAuthenticated).user.id 
          : null;

        if (userId == null) {
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Please login to edit your profile'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.login,
                      ),
                      child: const Text('Go to Login'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Fetch profile and display edit page
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<PlayerProfileBloc>()
              ..add(LoadPlayerProfile(playerId: userId)),
            child: BlocBuilder<PlayerProfileBloc, PlayerProfileState>(
              builder: (context, profileState) {
                if (profileState is PlayerProfileLoading) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                } else if (profileState is PlayerProfileLoaded) {
                  return PlayerProfileEditPage(profile: profileState.profile);
                } else if (profileState is PlayerProfileError) {
                  // Profile doesn't exist, redirect to profile setup
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.playerProfileSetup,
                    );
                  });
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                // Initial state or unknown state
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              },
            ),
          ),
        );

      case AppRoutes.photoGallery:
        return MaterialPageRoute(
          builder: (_) => const PhotoGalleryManagementPage(playerId: 'current'),
        );

      case AppRoutes.videoGallery:
        return MaterialPageRoute(
          builder: (_) => const VideoGalleryManagementPage(playerId: 'current'),
        );

      case AppRoutes.statsManagement:
        return MaterialPageRoute(
          builder: (_) => const StatisticsManagementPage(playerId: 'current'),
        );

      case AppRoutes.profileAnalytics:
        return MaterialPageRoute(
          builder: (_) => const ProfileAnalyticsPage(playerId: 'current'),
        );

      case AppRoutes.photoViewer:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => PhotoViewerPage(
            photo: args['photo'] as PlayerPhoto,
            photoGallery: args['photoGallery'] as List<PlayerPhoto>?,
            initialIndex: args['initialIndex'] as int?,
          ),
        );

      case AppRoutes.videoPlayer:
        final video = settings.arguments as PlayerVideo;
        return MaterialPageRoute(
          builder: (_) => VideoPlayerPage(video: video),
        );

      case AppRoutes.playerDashboard:
        return MaterialPageRoute(
          builder: (_) => const PlayerDashboardPage(),
        );

      case AppRoutes.scoutDashboard:
        // Get userId from arguments or fall back to reading from AuthBloc
        final userId = settings.arguments as String? ?? 
          (context.read<AuthBloc>().state is AuthAuthenticated 
            ? (context.read<AuthBloc>().state as AuthAuthenticated).user.id 
            : null);

        if (userId == null) {
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Please login to access scout dashboard'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.login,
                      ),
                      child: const Text('Go to Login'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<ScoutProfileBloc>(
                create: (_) => getIt<ScoutProfileBloc>(),
              ),
              BlocProvider<SavedSearchesBloc>(
                create: (_) => getIt<SavedSearchesBloc>(),
              ),
            ],
            child: ScoutDashboardPage(scoutId: userId),
          ),
        );

      case AppRoutes.coachDashboard:
        // Get userId from arguments or fall back to reading from AuthBloc
        final userId = settings.arguments as String? ?? 
          (context.read<AuthBloc>().state is AuthAuthenticated 
            ? (context.read<AuthBloc>().state as AuthAuthenticated).user.id 
            : null);

        if (userId == null) {
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Please login to access coach dashboard'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.login,
                      ),
                      child: const Text('Go to Login'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return MaterialPageRoute(
          builder: (_) => BlocProvider<CoachProfileBloc>(
            create: (_) => getIt<CoachProfileBloc>(),
            child: CoachDashboardPage(coachId: userId),
          ),
        );

      case AppRoutes.parentDashboard:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(
              title: const Text('Parent Dashboard'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    context.read<AuthBloc>().add(const LogoutRequested());
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.phoneAuth,
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
            body: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.family_restroom,
                    size: 80,
                    color: Colors.green,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Parent Dashboard',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text('Coming in Phase 4'),
                ],
              ),
            ),
          ),
        );

      case AppRoutes.faq:
        return MaterialPageRoute(
          builder: (_) => const FAQPage(),
        );

      case AppRoutes.tutorials:
        return MaterialPageRoute(
          builder: (_) => const TutorialsPage(),
        );

      case AppRoutes.blockedUsers:
        return MaterialPageRoute(
          builder: (_) => const BlockedUsersPage(),
        );

      case AppRoutes.messaging:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => MessagingPage(
            userId: args?['userId'] as String?,
            userName: args?['userName'] as String?,
          ),
        );

      default:
        return MaterialPageRoute(builder: (_) => const PhoneAuthPage());
    }
  }
}

/// Temporary home page for Phase 1 completion
class HomePage extends StatelessWidget {
  final Function(Locale) onLocaleChange;
  final Function(ThemeMode) onThemeModeChange;
  final Locale currentLocale;
  final ThemeMode currentThemeMode;

  const HomePage({
    super.key,
    required this.onLocaleChange,
    required this.onThemeModeChange,
    required this.currentLocale,
    required this.currentThemeMode,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = currentLocale.languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.appName),
          actions: [
            // Language Toggle
            PopupMenuButton<Locale>(
              icon: const Icon(Icons.language),
              onSelected: onLocaleChange,
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: const Locale('en'),
                  child: Row(
                    children: [
                      if (currentLocale.languageCode == 'en')
                        const Icon(Icons.check, size: 20),
                      if (currentLocale.languageCode == 'en')
                        const SizedBox(width: 8),
                      Text(l10n.english),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: const Locale('ar'),
                  child: Row(
                    children: [
                      if (currentLocale.languageCode == 'ar')
                        const Icon(Icons.check, size: 20),
                      if (currentLocale.languageCode == 'ar')
                        const SizedBox(width: 8),
                      Text(l10n.arabic),
                    ],
                  ),
                ),
              ],
            ),

            // Theme Toggle
            PopupMenuButton<ThemeMode>(
              icon: Icon(
                currentThemeMode == ThemeMode.dark
                    ? Icons.dark_mode
                    : Icons.light_mode,
              ),
              onSelected: onThemeModeChange,
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: ThemeMode.light,
                  child: Row(
                    children: [
                      if (currentThemeMode == ThemeMode.light)
                        const Icon(Icons.check, size: 20),
                      if (currentThemeMode == ThemeMode.light)
                        const SizedBox(width: 8),
                      const Icon(Icons.light_mode, size: 20),
                      const SizedBox(width: 8),
                      Text(l10n.lightMode),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: ThemeMode.dark,
                  child: Row(
                    children: [
                      if (currentThemeMode == ThemeMode.dark)
                        const Icon(Icons.check, size: 20),
                      if (currentThemeMode == ThemeMode.dark)
                        const SizedBox(width: 8),
                      const Icon(Icons.dark_mode, size: 20),
                      const SizedBox(width: 8),
                      Text(l10n.darkMode),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: ThemeMode.system,
                  child: Row(
                    children: [
                      if (currentThemeMode == ThemeMode.system)
                        const Icon(Icons.check, size: 20),
                      if (currentThemeMode == ThemeMode.system)
                        const SizedBox(width: 8),
                      const Icon(Icons.brightness_auto, size: 20),
                      const SizedBox(width: 8),
                      Text(l10n.systemMode),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Icon/Logo placeholder
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    Icons.sports_soccer,
                    size: 64,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 32),

                // Welcome Text
                Text(
                  l10n.welcome,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Description
                Text(
                  isArabic
                      ? 'منصة اكتشاف المواهب الكروية في منطقة الشرق الأوسط وشمال أفريقيا'
                      : 'Football talent scouting platform across MENA',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // Phase 1 Complete Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 48,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Phase 1 Complete',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '✓ Project Setup\n✓ Dependencies\n✓ Clean Architecture\n✓ Design System\n✓ Bilingual Support\n✓ API Client\n✓ Dependency Injection',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Info Text
                Text(
                  isArabic
                      ? 'المرحلة التالية: إعداد Firebase والمصادقة'
                      : 'Next: Firebase Setup & Authentication',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
