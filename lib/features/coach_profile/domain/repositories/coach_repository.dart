import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/coach_profile.dart';
import '../entities/coach_team.dart';

/// Coach repository interface
abstract class CoachRepository {
  Future<Either<Failure, CoachProfile>> getCoachProfile(String coachId);
  Future<Either<Failure, CoachProfile>> createCoachProfile(
      Map<String, dynamic> profileData);
  Future<Either<Failure, CoachProfile>> updateCoachProfile(
      String coachId, Map<String, dynamic> profileData);
  Future<Either<Failure, List<Team>>> getCoachTeams(String coachId);
  Future<Either<Failure, Team>> createTeam(
      String coachId, Map<String, dynamic> teamData);
  Future<Either<Failure, Team>> updateTeam(
      String coachId, String teamId, Map<String, dynamic> teamData);
  Future<Either<Failure, void>> deleteTeam(String coachId, String teamId);
  Future<Either<Failure, Team>> addPlayerToTeam(
      String coachId, String teamId, String playerId);
  Future<Either<Failure, Team>> removePlayerFromTeam(
      String coachId, String teamId, String playerId);
}
