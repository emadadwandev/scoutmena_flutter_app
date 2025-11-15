// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_video_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerVideoModel _$PlayerVideoModelFromJson(Map<String, dynamic> json) =>
    PlayerVideoModel(
      id: json['id'] as String,
      playerId: json['playerId'] as String,
      videoUrl: json['videoUrl'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      durationSeconds: (json['durationSeconds'] as num).toInt(),
      videoType: json['videoType'] as String,
      order: (json['order'] as num).toInt(),
      views: (json['views'] as num).toInt(),
      uploadedAt: DateTime.parse(json['uploadedAt'] as String),
    );

Map<String, dynamic> _$PlayerVideoModelToJson(PlayerVideoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'playerId': instance.playerId,
      'videoUrl': instance.videoUrl,
      'thumbnailUrl': instance.thumbnailUrl,
      'title': instance.title,
      'description': instance.description,
      'durationSeconds': instance.durationSeconds,
      'videoType': instance.videoType,
      'order': instance.order,
      'views': instance.views,
      'uploadedAt': instance.uploadedAt.toIso8601String(),
    };
