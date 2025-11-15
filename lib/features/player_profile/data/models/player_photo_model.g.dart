// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_photo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerPhotoModel _$PlayerPhotoModelFromJson(Map<String, dynamic> json) =>
    PlayerPhotoModel(
      id: json['id'] as String,
      playerId: json['playerId'] as String,
      photoUrl: json['photoUrl'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      caption: json['caption'] as String?,
      isPrimary: json['isPrimary'] as bool,
      order: (json['order'] as num).toInt(),
      uploadedAt: DateTime.parse(json['uploadedAt'] as String),
    );

Map<String, dynamic> _$PlayerPhotoModelToJson(PlayerPhotoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'playerId': instance.playerId,
      'photoUrl': instance.photoUrl,
      'thumbnailUrl': instance.thumbnailUrl,
      'caption': instance.caption,
      'isPrimary': instance.isPrimary,
      'order': instance.order,
      'uploadedAt': instance.uploadedAt.toIso8601String(),
    };
