import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/search_results.dart';
import '../../../player_profile/domain/entities/player_profile.dart';
import '../../../player_profile/data/models/player_profile_model.dart';

part 'search_results_model.g.dart';

/// Search results data model with JSON serialization
@JsonSerializable(explicitToJson: true)
class SearchResultsModel extends SearchResults {
  @override
  @JsonKey(fromJson: _playersFromJson, toJson: _playersToJson)
  final List<PlayerProfile> players;

  const SearchResultsModel({
    required this.players,
    required super.totalResults,
    required super.currentPage,
    required super.totalPages,
    required super.perPage,
    required super.hasMorePages,
  }) : super(players: players);

  static List<PlayerProfile> _playersFromJson(List<dynamic> json) =>
      json.map((e) => PlayerProfileModel.fromJson(e as Map<String, dynamic>)).toList();

  static List<Map<String, dynamic>> _playersToJson(List<PlayerProfile> players) =>
      players.map((p) => PlayerProfileModel.fromEntity(p).toJson()).toList();

  factory SearchResultsModel.fromJson(Map<String, dynamic> json) =>
      _$SearchResultsModelFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResultsModelToJson(this);
}
