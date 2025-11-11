import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'core/navigation/routes.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations_temp.dart';
import 'features/authentication/presentation/pages/phone_auth_page.dart';
import 'features/authentication/presentation/pages/otp_verification_page.dart';
import 'features/authentication/presentation/pages/role_selection_page.dart';
import 'features/authentication/presentation/pages/registration_page.dart';

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
    return MaterialApp(
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
      initialRoute: AppRoutes.phoneAuth,
      onGenerateRoute: _generateRoute,
    );
  }

  Route<dynamic>? _generateRoute(RouteSettings settings) {
    switch (settings.name) {
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
            firebaseUid: args['firebaseUid'] as String,
            accountType: args['accountType'] as String,
          ),
        );

      case AppRoutes.playerDashboard:
      case AppRoutes.scoutDashboard:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Dashboard')),
            body: Center(
              child: Text('${settings.name} - Coming in Phase 3'),
            ),
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
