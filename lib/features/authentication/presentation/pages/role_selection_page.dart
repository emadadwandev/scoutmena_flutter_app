import 'package:flutter/material.dart';
import '../../../../core/navigation/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations_temp.dart';
import '../widgets/primary_button.dart';
import '../widgets/role_selection_card.dart';

class RoleSelectionPage extends StatefulWidget {
  final String firebaseUid;

  const RoleSelectionPage({
    super.key,
    required this.firebaseUid,
  });

  @override
  State<RoleSelectionPage> createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {
  String? _selectedRole;

  void _onContinue() {
    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.pleaseSelectRole),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.pushNamed(
      context,
      AppRoutes.registration,
      arguments: {
        'firebaseUid': widget.firebaseUid,
        'accountType': _selectedRole,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                l10n.selectYourRole,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.chooseAccountType,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      RoleSelectionCard(
                        title: l10n.player,
                        description: l10n.playerRoleDescription,
                        icon: Icons.sports_soccer,
                        color: AppColors.playerPrimary,
                        isSelected: _selectedRole == 'player',
                        onTap: () {
                          setState(() {
                            _selectedRole = 'player';
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      RoleSelectionCard(
                        title: l10n.scout,
                        description: l10n.scoutRoleDescription,
                        icon: Icons.visibility,
                        color: AppColors.scoutPrimary,
                        isSelected: _selectedRole == 'scout',
                        onTap: () {
                          setState(() {
                            _selectedRole = 'scout';
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                text: l10n.continueText,
                onPressed: _onContinue,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
