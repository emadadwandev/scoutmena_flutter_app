import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/coach_profile.dart';
import '../../domain/entities/coach_team.dart';
import '../../domain/repositories/coach_repository.dart';
import '../datasources/coach_remote_data_source.dart';

/// Coach repository implementation
@LazySingleton(as: CoachRepository)
class CoachRepositoryImpl implements CoachRepository {
  final CoachRemoteDataSource _remoteDataSource;

  CoachRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, CoachProfile>> getCoachProfile(String coachId) async {
    try {
      final profile = await _remoteDataSource.getCoachProfile(coachId);
      return Right(profile);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CoachProfile>> createCoachProfile(
      Map<String, dynamic> profileData) async {
    try {
      final profile = await _remoteDataSource.createCoachProfile(profileData);
      return Right(profile);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CoachProfile>> updateCoachProfile(
      String coachId, Map<String, dynamic> profileData) async {
    try {
      final profile =
          await _remoteDataSource.updateCoachProfile(coachId, profileData);
      return Right(profile);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Team>>> getCoachTeams(String coachId) async {
    try {
      final teams = await _remoteDataSource.getCoachTeams(coachId);
      return Right(teams);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Team>> createTeam(
      String coachId, Map<String, dynamic> teamData) async {
    try {
      final team = await _remoteDataSource.createTeam(coachId, teamData);
      return Right(team);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Team>> updateTeam(
      String coachId, String teamId, Map<String, dynamic> teamData) async {
    try {
      final team =
          await _remoteDataSource.updateTeam(coachId, teamId, teamData);
      return Right(team);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTeam(
      String coachId, String teamId) async {
    try {
      await _remoteDataSource.deleteTeam(coachId, teamId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Team>> addPlayerToTeam(
      String coachId, String teamId, String playerId) async {
    try {
      final team =
          await _remoteDataSource.addPlayerToTeam(coachId, teamId, playerId);
      return Right(team);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Team>> removePlayerFromTeam(
      String coachId, String teamId, String playerId) async {
    try {
      final team = await _remoteDataSource.removePlayerFromTeam(
          coachId, teamId, playerId);
      return Right(team);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
