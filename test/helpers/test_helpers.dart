import 'package:mockito/annotations.dart';
import 'package:scoutmena_app/features/authentication/domain/repositories/auth_repository.dart';
import 'package:scoutmena_app/features/player_profile/domain/repositories/player_repository.dart';
import 'package:scoutmena_app/features/scout_profile/domain/repositories/scout_repository.dart';
import 'package:scoutmena_app/features/coach_profile/domain/repositories/coach_repository.dart';

/// Generate mocks for all repositories
/// Run: flutter pub run build_runner build --delete-conflicting-outputs
@GenerateMocks([
  AuthRepository,
  PlayerRepository,
  ScoutRepository,
  CoachRepository,
])
void main() {
  // Mock generation entry point
}
