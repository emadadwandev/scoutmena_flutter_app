import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/player_video.dart';

part 'player_video_model.g.dart';

/// Data model for player video with JSON serialization
@JsonSerializable(explicitToJson: true)
class PlayerVideoModel extends PlayerVideo {
  const PlayerVideoModel({
    required super.id,
    required super.playerId,
    required super.videoUrl,
    super.thumbnailUrl,
    required super.title,
    super.description,
    required super.durationSeconds,
    required super.videoType,
    required super.order,
    required super.views,
    required super.uploadedAt,
  });

  /// Create model from JSON
  factory PlayerVideoModel.fromJson(Map<String, dynamic> json) =>
      _$PlayerVideoModelFromJson(json);

  /// Convert model to JSON
  Map<String, dynamic> toJson() => _$PlayerVideoModelToJson(this);

  /// Create model from entity
  factory PlayerVideoModel.fromEntity(PlayerVideo entity) {
    return PlayerVideoModel(
      id: entity.id,
      playerId: entity.playerId,
      videoUrl: entity.videoUrl,
      thumbnailUrl: entity.thumbnailUrl,
      title: entity.title,
      description: entity.description,
      durationSeconds: entity.durationSeconds,
      videoType: entity.videoType,
      order: entity.order,
      views: entity.views,
      uploadedAt: entity.uploadedAt,
    );
  }

  /// Convert model to entity
  PlayerVideo toEntity() => this;

  @override
  PlayerVideoModel copyWith({
    String? id,
    String? playerId,
    String? videoUrl,
    String? thumbnailUrl,
    String? title,
    String? description,
    int? durationSeconds,
    String? videoType,
    int? order,
    int? views,
    DateTime? uploadedAt,
  }) {
    return PlayerVideoModel(
      id: id ?? this.id,
      playerId: playerId ?? this.playerId,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      title: title ?? this.title,
      description: description ?? this.description,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      videoType: videoType ?? this.videoType,
      order: order ?? this.order,
      views: views ?? this.views,
      uploadedAt: uploadedAt ?? this.uploadedAt,
    );
  }
}
