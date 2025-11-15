import 'dart:io';
import 'package:equatable/equatable.dart';

/// Base class for all player profile events
abstract class PlayerProfileEvent extends Equatable {
  const PlayerProfileEvent();

  @override
  List<Object?> get props => [];
}

// ============================================================================
// Profile Events
// ============================================================================

/// Event to load player profile
class LoadPlayerProfile extends PlayerProfileEvent {
  final String playerId;

  const LoadPlayerProfile({required this.playerId});

  @override
  List<Object?> get props => [playerId];
}

/// Event to create player profile
class CreatePlayerProfile extends PlayerProfileEvent {
  final Map<String, dynamic> profileData;

  const CreatePlayerProfile({required this.profileData});

  @override
  List<Object?> get props => [profileData];
}

/// Event to update player profile
class UpdatePlayerProfile extends PlayerProfileEvent {
  final String playerId;
  final Map<String, dynamic> profileData;

  const UpdatePlayerProfile({
    required this.playerId,
    required this.profileData,
  });

  @override
  List<Object?> get props => [playerId, profileData];
}

/// Event to upload profile photo (main profile picture)
class UploadProfilePhoto extends PlayerProfileEvent {
  final String playerId;
  final File photoFile;

  const UploadProfilePhoto({
    required this.playerId,
    required this.photoFile,
  });

  @override
  List<Object?> get props => [playerId, photoFile];
}

// ============================================================================
// Photo Gallery Events
// ============================================================================

/// Event to load player photos
class LoadPlayerPhotos extends PlayerProfileEvent {
  final String playerId;

  const LoadPlayerPhotos({required this.playerId});

  @override
  List<Object?> get props => [playerId];
}

/// Event to upload photo to gallery
class UploadPlayerPhotoToGallery extends PlayerProfileEvent {
  final String playerId;
  final File photoFile;
  final String? caption;
  final bool isPrimary;

  const UploadPlayerPhotoToGallery({
    required this.playerId,
    required this.photoFile,
    this.caption,
    this.isPrimary = false,
  });

  @override
  List<Object?> get props => [playerId, photoFile, caption, isPrimary];
}

/// Event to delete player photo
class DeletePlayerPhotoFromGallery extends PlayerProfileEvent {
  final String playerId;
  final String photoId;

  const DeletePlayerPhotoFromGallery({
    required this.playerId,
    required this.photoId,
  });

  @override
  List<Object?> get props => [playerId, photoId];
}

// ============================================================================
// Video Events
// ============================================================================

/// Event to load player videos
class LoadPlayerVideos extends PlayerProfileEvent {
  final String playerId;

  const LoadPlayerVideos({required this.playerId});

  @override
  List<Object?> get props => [playerId];
}

/// Event to upload player video
class UploadPlayerVideoToGallery extends PlayerProfileEvent {
  final String playerId;
  final File videoFile;
  final String title;
  final String? description;
  final String videoType;
  final File? thumbnailFile;

  const UploadPlayerVideoToGallery({
    required this.playerId,
    required this.videoFile,
    required this.title,
    this.description,
    this.videoType = 'highlight',
    this.thumbnailFile,
  });

  @override
  List<Object?> get props => [
        playerId,
        videoFile,
        title,
        description,
        videoType,
        thumbnailFile,
      ];
}

/// Event to delete player video
class DeletePlayerVideoFromGallery extends PlayerProfileEvent {
  final String playerId;
  final String videoId;

  const DeletePlayerVideoFromGallery({
    required this.playerId,
    required this.videoId,
  });

  @override
  List<Object?> get props => [playerId, videoId];
}

// ============================================================================
// Statistics Events
// ============================================================================

/// Event to load player statistics
class LoadPlayerStats extends PlayerProfileEvent {
  final String playerId;

  const LoadPlayerStats({required this.playerId});

  @override
  List<Object?> get props => [playerId];
}

/// Event to create player statistics
class CreatePlayerStatEntry extends PlayerProfileEvent {
  final String playerId;
  final Map<String, dynamic> statData;

  const CreatePlayerStatEntry({
    required this.playerId,
    required this.statData,
  });

  @override
  List<Object?> get props => [playerId, statData];
}

/// Event to update player statistics
class UpdatePlayerStatEntry extends PlayerProfileEvent {
  final String playerId;
  final String statId;
  final Map<String, dynamic> statData;

  const UpdatePlayerStatEntry({
    required this.playerId,
    required this.statId,
    required this.statData,
  });

  @override
  List<Object?> get props => [playerId, statId, statData];
}

/// Event to delete player statistics
class DeletePlayerStatEntry extends PlayerProfileEvent {
  final String playerId;
  final String statId;

  const DeletePlayerStatEntry({
    required this.playerId,
    required this.statId,
  });

  @override
  List<Object?> get props => [playerId, statId];
}

// ============================================================================
// Utility Events
// ============================================================================

/// Event to reset player profile state
class ResetPlayerProfileState extends PlayerProfileEvent {
  const ResetPlayerProfileState();
}
