import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/player_photo.dart';
part 'player_photo_model.g.dart';

/// Data model for player photo with JSON serialization
@JsonSerializable(explicitToJson: true)
class PlayerPhotoModel extends PlayerPhoto {
  const PlayerPhotoModel({
    required super.id,
    required super.playerId,
    required super.photoUrl,
    super.thumbnailUrl,
    super.caption,
    required super.isPrimary,
    required super.order,
    required super.uploadedAt,
  });

  /// Create model from JSON
  factory PlayerPhotoModel.fromJson(Map<String, dynamic> json) =>
      _$PlayerPhotoModelFromJson(json);

  /// Convert model to JSON
  Map<String, dynamic> toJson() => _$PlayerPhotoModelToJson(this);

  /// Create model from entity
  factory PlayerPhotoModel.fromEntity(PlayerPhoto entity) {
    return PlayerPhotoModel(
      id: entity.id,
      playerId: entity.playerId,
      photoUrl: entity.photoUrl,
      thumbnailUrl: entity.thumbnailUrl,
      caption: entity.caption,
      isPrimary: entity.isPrimary,
      order: entity.order,
      uploadedAt: entity.uploadedAt,
    );
  }

  /// Convert model to entity
  PlayerPhoto toEntity() => this;

  @override
  PlayerPhotoModel copyWith({
    String? id,
    String? playerId,
    String? photoUrl,
    String? thumbnailUrl,
    String? caption,
    bool? isPrimary,
    int? order,
    DateTime? uploadedAt,
  }) {
    return PlayerPhotoModel(
      id: id ?? this.id,
      playerId: playerId ?? this.playerId,
      photoUrl: photoUrl ?? this.photoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      caption: caption ?? this.caption,
      isPrimary: isPrimary ?? this.isPrimary,
      order: order ?? this.order,
      uploadedAt: uploadedAt ?? this.uploadedAt,
    );
  }
}
