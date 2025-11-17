import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/coach_team.dart';

part 'team_model.g.dart';

/// Team data model with JSON serialization
@JsonSerializable(explicitToJson: true)
class TeamModel extends Team {
  TeamModel({
    required super.id,
    required super.coachId,
    required super.teamName,
    required super.ageGroup,
    super.clubName,
    required super.playerIds,
    required super.season,
    required super.createdAt,
    required super.updatedAt,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) =>
      _$TeamModelFromJson(json);

  Map<String, dynamic> toJson() => _$TeamModelToJson(this);

  factory TeamModel.fromEntity(Team team) {
    return TeamModel(
      id: team.id,
      coachId: team.coachId,
      teamName: team.teamName,
      ageGroup: team.ageGroup,
      clubName: team.clubName,
      playerIds: team.playerIds,
      season: team.season,
      createdAt: team.createdAt,
      updatedAt: team.updatedAt,
    );
  }
}
