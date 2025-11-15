import 'package:equatable/equatable.dart';

/// Team entity for coach management
class Team extends Equatable {
  final String id;
  final String coachId;
  final String teamName;
  final String ageGroup; // 'U12', 'U15', 'U18', 'Senior'
  final String? clubName;
  final int playerCount;
  final List<String> playerIds;
  final String season; // '2024/2025'
  final DateTime createdAt;
  final DateTime updatedAt;

  const Team({
    required this.id,
    required this.coachId,
    required this.teamName,
    required this.ageGroup,
    this.clubName,
    required this.playerCount,
    required this.playerIds,
    required this.season,
    required this.createdAt,
    required this.updatedAt,
  });

  Team copyWith({
    String? id,
    String? coachId,
    String? teamName,
    String? ageGroup,
    String? clubName,
    int? playerCount,
    List<String>? playerIds,
    String? season,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Team(
      id: id ?? this.id,
      coachId: coachId ?? this.coachId,
      teamName: teamName ?? this.teamName,
      ageGroup: ageGroup ?? this.ageGroup,
      clubName: clubName ?? this.clubName,
      playerCount: playerCount ?? this.playerCount,
      playerIds: playerIds ?? this.playerIds,
      season: season ?? this.season,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        coachId,
        teamName,
        ageGroup,
        clubName,
        playerCount,
        playerIds,
        season,
        createdAt,
        updatedAt,
      ];
}
