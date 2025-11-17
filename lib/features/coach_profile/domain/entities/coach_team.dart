/// Team entity representing a coach's team
class Team {
  final String id;
  final String coachId;
  final String teamName;
  final String? clubName;
  final String season;
  final String ageGroup;
  final List<String> playerIds;
  final DateTime createdAt;
  final DateTime updatedAt;

  Team({
    required this.id,
    required this.coachId,
    required this.teamName,
    this.clubName,
    required this.season,
    required this.ageGroup,
    required this.playerIds,
    required this.createdAt,
    required this.updatedAt,
  });

  int get playerCount => playerIds.length;

  Team copyWith({
    String? id,
    String? coachId,
    String? teamName,
    String? clubName,
    String? season,
    String? ageGroup,
    List<String>? playerIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Team(
      id: id ?? this.id,
      coachId: coachId ?? this.coachId,
      teamName: teamName ?? this.teamName,
      clubName: clubName ?? this.clubName,
      season: season ?? this.season,
      ageGroup: ageGroup ?? this.ageGroup,
      playerIds: playerIds ?? this.playerIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'coachId': coachId,
      'teamName': teamName,
      'clubName': clubName,
      'season': season,
      'ageGroup': ageGroup,
      'playerIds': playerIds,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'] as String,
      coachId: json['coachId'] as String,
      teamName: json['teamName'] as String,
      clubName: json['clubName'] as String?,
      season: json['season'] as String,
      ageGroup: json['ageGroup'] as String,
      playerIds: (json['playerIds'] as List<dynamic>).cast<String>(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Team &&
        other.id == id &&
        other.coachId == coachId &&
        other.teamName == teamName &&
        other.clubName == clubName &&
        other.season == season &&
        other.ageGroup == ageGroup;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        coachId.hashCode ^
        teamName.hashCode ^
        clubName.hashCode ^
        season.hashCode ^
        ageGroup.hashCode;
  }

  @override
  String toString() {
    return 'Team(id: $id, teamName: $teamName, clubName: $clubName, season: $season, ageGroup: $ageGroup, playerCount: $playerCount)';
  }
}
