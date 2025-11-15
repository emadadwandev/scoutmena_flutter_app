import 'package:flutter/material.dart';
import '../../../../core/navigation/routes.dart';
import '../../../../core/theme/app_colors.dart';

/// Player Profile Setup - Multi-step profile creation
/// TODO: Implement full multi-step profile creation in Phase 3
class PlayerProfileSetupPage extends StatelessWidget {
  const PlayerProfileSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Your Profile'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.account_circle,
                size: 100,
                color: AppColors.playerPrimary,
              ),
              const SizedBox(height: 32),
              Text(
                'Profile Setup',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                'Multi-step profile creation will be implemented in Phase 3',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () {
                  // For now, go directly to dashboard
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.playerDashboard,
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.playerPrimary,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Skip to Dashboard',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
