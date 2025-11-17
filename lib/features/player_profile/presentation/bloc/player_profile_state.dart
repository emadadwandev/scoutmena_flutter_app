import 'package:equatable/equatable.dart';
import '../../domain/entities/player_profile.dart';
import '../../domain/entities/player_photo.dart';
import '../../domain/entities/player_video.dart';
import '../../domain/entities/player_stat.dart';

/// Base class for all player profile states
abstract class PlayerProfileState extends Equatable {
  const PlayerProfileState();

  @override
  List<Object?> get props => [];
}

// ============================================================================
// Initial State
// ============================================================================

/// Initial state before any operation
class PlayerProfileInitial extends PlayerProfileState {
  const PlayerProfileInitial();
}

// ============================================================================
// Loading States
// ============================================================================

/// State when loading player profile
class PlayerProfileLoading extends PlayerProfileState {
  const PlayerProfileLoading();
}

/// State when uploading profile photo
class ProfilePhotoUploading extends PlayerProfileState {
  final double? progress; // 0.0 to 1.0

  const ProfilePhotoUploading({this.progress});

  @override
  List<Object?> get props => [progress];
}

/// State when uploading photo to gallery
class PhotoUploading extends PlayerProfileState {
  final double? progress; // 0.0 to 1.0

  const PhotoUploading({this.progress});

  @override
  List<Object?> get props => [progress];
}

/// State when uploading video
class VideoUploading extends PlayerProfileState {
  final double? progress; // 0.0 to 1.0

  const VideoUploading({this.progress});

  @override
  List<Object?> get props => [progress];
}

/// State when creating/updating profile
class ProfileUpdating extends PlayerProfileState {
  const ProfileUpdating();
}

/// State when creating/updating statistics
class StatsUpdating extends PlayerProfileState {
  const StatsUpdating();
}

// ============================================================================
// Success States
// ============================================================================

/// State when player profile is loaded successfully
/// This state holds ALL profile-related data (profile, photos, videos, stats)
/// to prevent state replacement issues when loading secondary data
class PlayerProfileLoaded extends PlayerProfileState {
  final PlayerProfile profile;
  final List<PlayerPhoto>? photos;
  final List<PlayerVideo>? videos;
  final List<PlayerStat>? stats;

  const PlayerProfileLoaded({
    required this.profile,
    this.photos,
    this.videos,
    this.stats,
  });

  /// Create a copy with updated data
  PlayerProfileLoaded copyWith({
    PlayerProfile? profile,
    List<PlayerPhoto>? photos,
    List<PlayerVideo>? videos,
    List<PlayerStat>? stats,
  }) {
    return PlayerProfileLoaded(
      profile: profile ?? this.profile,
      photos: photos ?? this.photos,
      videos: videos ?? this.videos,
      stats: stats ?? this.stats,
    );
  }

  @override
  List<Object?> get props => [profile, photos, videos, stats];
}

/// State when player profile is created successfully
class PlayerProfileCreated extends PlayerProfileState {
  final PlayerProfile profile;

  const PlayerProfileCreated({required this.profile});

  @override
  List<Object?> get props => [profile];
}

/// State when player profile is updated successfully
class PlayerProfileUpdated extends PlayerProfileState {
  final PlayerProfile profile;

  const PlayerProfileUpdated({required this.profile});

  @override
  List<Object?> get props => [profile];
}

/// State when profile photo is uploaded successfully
class ProfilePhotoUploaded extends PlayerProfileState {
  final String photoUrl;

  const ProfilePhotoUploaded({required this.photoUrl});

  @override
  List<Object?> get props => [photoUrl];
}

// ============================================================================
// Photo Gallery States
// ============================================================================

/// State when player photos are loaded successfully
/// DEPRECATED: Use PlayerProfileLoaded.copyWith(photos: ...) instead
class PlayerPhotosLoaded extends PlayerProfileState {
  final List<PlayerPhoto> photos;

  const PlayerPhotosLoaded({required this.photos});

  @override
  List<Object?> get props => [photos];
}

/// State when photo is uploaded to gallery successfully
class PhotoUploadedToGallery extends PlayerProfileState {
  final PlayerPhoto photo;
  final List<PlayerPhoto> allPhotos;

  const PhotoUploadedToGallery({
    required this.photo,
    required this.allPhotos,
  });

  @override
  List<Object?> get props => [photo, allPhotos];
}

/// State when photo is deleted successfully
class PhotoDeletedFromGallery extends PlayerProfileState {
  final String photoId;
  final List<PlayerPhoto> remainingPhotos;

  const PhotoDeletedFromGallery({
    required this.photoId,
    required this.remainingPhotos,
  });

  @override
  List<Object?> get props => [photoId, remainingPhotos];
}

// ============================================================================
// Video States
// ============================================================================

/// State when player videos are loaded successfully
/// DEPRECATED: Use PlayerProfileLoaded.copyWith(videos: ...) instead
class PlayerVideosLoaded extends PlayerProfileState {
  final List<PlayerVideo> videos;

  const PlayerVideosLoaded({required this.videos});

  @override
  List<Object?> get props => [videos];
}

/// State when video is uploaded successfully
class VideoUploadedToGallery extends PlayerProfileState {
  final PlayerVideo video;
  final List<PlayerVideo> allVideos;

  const VideoUploadedToGallery({
    required this.video,
    required this.allVideos,
  });

  @override
  List<Object?> get props => [video, allVideos];
}

/// State when video is deleted successfully
class VideoDeletedFromGallery extends PlayerProfileState {
  final String videoId;
  final List<PlayerVideo> remainingVideos;

  const VideoDeletedFromGallery({
    required this.videoId,
    required this.remainingVideos,
  });

  @override
  List<Object?> get props => [videoId, remainingVideos];
}

// ============================================================================
// Statistics States
// ============================================================================

/// State when player statistics are loaded successfully
/// DEPRECATED: Use PlayerProfileLoaded.copyWith(stats: ...) instead
class PlayerStatsLoaded extends PlayerProfileState {
  final List<PlayerStat> stats;

  const PlayerStatsLoaded({required this.stats});

  @override
  List<Object?> get props => [stats];
}

/// State when statistics entry is created successfully
class PlayerStatCreated extends PlayerProfileState {
  final PlayerStat stat;
  final List<PlayerStat> allStats;

  const PlayerStatCreated({
    required this.stat,
    required this.allStats,
  });

  @override
  List<Object?> get props => [stat, allStats];
}

/// State when statistics entry is updated successfully
class PlayerStatUpdated extends PlayerProfileState {
  final PlayerStat stat;
  final List<PlayerStat> allStats;

  const PlayerStatUpdated({
    required this.stat,
    required this.allStats,
  });

  @override
  List<Object?> get props => [stat, allStats];
}

/// State when statistics entry is deleted successfully
class PlayerStatDeleted extends PlayerProfileState {
  final String statId;
  final List<PlayerStat> remainingStats;

  const PlayerStatDeleted({
    required this.statId,
    required this.remainingStats,
  });

  @override
  List<Object?> get props => [statId, remainingStats];
}

// ============================================================================
// Error States
// ============================================================================

/// State when an error occurs
class PlayerProfileError extends PlayerProfileState {
  final String message;

  const PlayerProfileError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// State when profile photo upload fails
class ProfilePhotoUploadError extends PlayerProfileState {
  final String message;

  const ProfilePhotoUploadError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// State when photo upload to gallery fails
class PhotoUploadError extends PlayerProfileState {
  final String message;

  const PhotoUploadError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// State when video upload fails
class VideoUploadError extends PlayerProfileState {
  final String message;

  const VideoUploadError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// State when statistics operation fails
class StatsOperationError extends PlayerProfileState {
  final String message;

  const StatsOperationError({required this.message});

  @override
  List<Object?> get props => [message];
}
