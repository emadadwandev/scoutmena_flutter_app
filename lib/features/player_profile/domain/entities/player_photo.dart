import 'package:equatable/equatable.dart';

/// Player photo entity
class PlayerPhoto extends Equatable {
  final String id;
  final String playerId;
  final String photoUrl;
  final String? thumbnailUrl;
  final String? caption;
  final bool isPrimary;
  final int order;
  final DateTime uploadedAt;

  const PlayerPhoto({
    required this.id,
    required this.playerId,
    required this.photoUrl,
    this.thumbnailUrl,
    this.caption,
    required this.isPrimary,
    required this.order,
    required this.uploadedAt,
  });

  PlayerPhoto copyWith({
    String? id,
    String? playerId,
    String? photoUrl,
    String? thumbnailUrl,
    String? caption,
    bool? isPrimary,
    int? order,
    DateTime? uploadedAt,
  }) {
    return PlayerPhoto(
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

  @override
  List<Object?> get props => [
        id,
        playerId,
        photoUrl,
        thumbnailUrl,
        caption,
        isPrimary,
        order,
        uploadedAt,
      ];
}
