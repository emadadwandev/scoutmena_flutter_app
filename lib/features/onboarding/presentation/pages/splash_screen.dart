import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/navigation/routes.dart';
import '../../../authentication/presentation/bloc/auth_bloc.dart';
import '../../../authentication/presentation/bloc/auth_event.dart';
import '../../../authentication/presentation/bloc/auth_state.dart';

/// Splash Screen - Initial loading screen with app logo
/// Shows for 2 seconds then navigates to onboarding or login
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Setup fade animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _animationController.forward();

    // Check authentication
    context.read<AuthBloc>().add(const AuthCheckRequested());

    // Navigate after delay
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Check if user has seen onboarding
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    final hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;

    // Don't navigate here - let the BlocListener handle it
    // Just mark onboarding as seen if needed
    if (!hasSeenOnboarding) {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthAuthenticated) {
          // User is logged in - navigate to appropriate dashboard
          if (!mounted) return;
          
          if (state.user.isPlayer) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.playerDashboard);
          } else if (state.user.isScout) {
            Navigator.of(context).pushReplacementNamed(
              AppRoutes.scoutDashboard,
              arguments: state.user.id,
            );
          } else if (state.user.isCoach) {
            Navigator.of(context).pushReplacementNamed(
              AppRoutes.coachDashboard,
              arguments: state.user.id,
            );
          } else if (state.user.isParent) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.parentDashboard);
          } else {
            // Default fallback
            Navigator.of(context).pushReplacementNamed(AppRoutes.playerDashboard);
          }
        } else if (state is AuthUnauthenticated) {
          // User is not logged in - check onboarding
          final prefs = await SharedPreferences.getInstance();
          final hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;
          
          if (!mounted) return;
          
          if (hasSeenOnboarding) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.phoneAuth);
          } else {
            Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo Placeholder
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.sports_soccer,
                    size: 80,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 24),
                // App Name
                const Text(
                  'ScoutMena',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Discover Football Talent',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 48),
                // Loading Indicator
                const SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
