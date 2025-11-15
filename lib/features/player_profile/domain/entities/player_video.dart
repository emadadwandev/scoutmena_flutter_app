import 'package:equatable/equatable.dart';

/// Player video entity
class PlayerVideo extends Equatable {
  final String id;
  final String playerId;
  final String videoUrl;
  final String? thumbnailUrl;
  final String title;
  final String? description;
  final int durationSeconds;
  final String videoType; // 'highlight', 'training', 'match', 'other'
  final int order;
  final int views;
  final DateTime uploadedAt;

  const PlayerVideo({
    required this.id,
    required this.playerId,
    required this.videoUrl,
    this.thumbnailUrl,
    required this.title,
    this.description,
    required this.durationSeconds,
    required this.videoType,
    required this.order,
    required this.views,
    required this.uploadedAt,
  });

  /// Format duration as mm:ss
  String get formattedDuration {
    final minutes = durationSeconds ~/ 60;
    final seconds = durationSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  PlayerVideo copyWith({
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
    return PlayerVideo(
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

  @override
  List<Object?> get props => [
        id,
        playerId,
        videoUrl,
        thumbnailUrl,
        title,
        description,
        durationSeconds,
        videoType,
        order,
        views,
        uploadedAt,
      ];
}
