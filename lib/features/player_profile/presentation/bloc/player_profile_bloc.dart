import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/player_photo.dart';
import '../../domain/entities/player_video.dart';
import '../../domain/entities/player_stat.dart';
import '../../domain/usecases/get_player_profile.dart';
import '../../domain/usecases/create_player_profile.dart' as create_profile_usecase;
import '../../domain/usecases/update_player_profile.dart' as update_profile_usecase;
import '../../domain/usecases/upload_profile_photo.dart' as upload_photo_usecase;
import '../../domain/usecases/get_player_photos.dart';
import '../../domain/usecases/upload_player_photo.dart';
import '../../domain/usecases/delete_player_photo.dart';
import '../../domain/usecases/get_player_videos.dart';
import '../../domain/usecases/upload_player_video.dart';
import '../../domain/usecases/delete_player_video.dart';
import '../../domain/usecases/get_player_stats.dart';
import '../../domain/usecases/create_player_stat.dart';
import '../../domain/usecases/update_player_stat.dart';
import '../../domain/usecases/delete_player_stat.dart';
import 'player_profile_event.dart';
import 'player_profile_state.dart';

@injectable
class PlayerProfileBloc extends Bloc<PlayerProfileEvent, PlayerProfileState> {
  final GetPlayerProfile _getPlayerProfile;
  final create_profile_usecase.CreatePlayerProfile _createPlayerProfile;
  final update_profile_usecase.UpdatePlayerProfile _updatePlayerProfile;
  final upload_photo_usecase.UploadProfilePhoto _uploadProfilePhoto;
  final GetPlayerPhotos _getPlayerPhotos;
  final UploadPlayerPhoto _uploadPlayerPhoto;
  final DeletePlayerPhoto _deletePlayerPhoto;
  final GetPlayerVideos _getPlayerVideos;
  final UploadPlayerVideo _uploadPlayerVideo;
  final DeletePlayerVideo _deletePlayerVideo;
  final GetPlayerStats _getPlayerStats;
  final CreatePlayerStat _createPlayerStat;
  final UpdatePlayerStat _updatePlayerStat;
  final DeletePlayerStat _deletePlayerStat;

  // Cache for photos, videos, and stats
  List<PlayerPhoto> _cachedPhotos = [];
  List<PlayerVideo> _cachedVideos = [];
  List<PlayerStat> _cachedStats = [];

  PlayerProfileBloc(
    this._getPlayerProfile,
    this._createPlayerProfile,
    this._updatePlayerProfile,
    this._uploadProfilePhoto,
    this._getPlayerPhotos,
    this._uploadPlayerPhoto,
    this._deletePlayerPhoto,
    this._getPlayerVideos,
    this._uploadPlayerVideo,
    this._deletePlayerVideo,
    this._getPlayerStats,
    this._createPlayerStat,
    this._updatePlayerStat,
    this._deletePlayerStat,
  ) : super(const PlayerProfileInitial()) {
    // Profile events
    on<LoadPlayerProfile>(_onLoadPlayerProfile);
    on<CreatePlayerProfile>(_onCreatePlayerProfile);
    on<UpdatePlayerProfile>(_onUpdatePlayerProfile);
    on<UploadProfilePhoto>(_onUploadProfilePhoto);

    // Photo events
    on<LoadPlayerPhotos>(_onLoadPlayerPhotos);
    on<UploadPlayerPhotoToGallery>(_onUploadPlayerPhotoToGallery);
    on<DeletePlayerPhotoFromGallery>(_onDeletePlayerPhotoFromGallery);

    // Video events
    on<LoadPlayerVideos>(_onLoadPlayerVideos);
    on<UploadPlayerVideoToGallery>(_onUploadPlayerVideoToGallery);
    on<DeletePlayerVideoFromGallery>(_onDeletePlayerVideoFromGallery);

    // Statistics events
    on<LoadPlayerStats>(_onLoadPlayerStats);
    on<CreatePlayerStatEntry>(_onCreatePlayerStatEntry);
    on<UpdatePlayerStatEntry>(_onUpdatePlayerStatEntry);
    on<DeletePlayerStatEntry>(_onDeletePlayerStatEntry);

    // Utility events
    on<ResetPlayerProfileState>(_onResetPlayerProfileState);
  }

  // ============================================================================
  // Profile Event Handlers
  // ============================================================================

  Future<void> _onLoadPlayerProfile(
    LoadPlayerProfile event,
    Emitter<PlayerProfileState> emit,
  ) async {
    emit(const PlayerProfileLoading());

    final result = await _getPlayerProfile(
      GetPlayerProfileParams(playerId: event.playerId),
    );

    result.fold(
      (failure) => emit(PlayerProfileError(message: failure.message)),
      (profile) => emit(PlayerProfileLoaded(profile: profile)),
    );
  }

  Future<void> _onCreatePlayerProfile(
    CreatePlayerProfile event,
    Emitter<PlayerProfileState> emit,
  ) async {
    emit(const ProfileUpdating());

    final result = await _createPlayerProfile(
      create_profile_usecase.CreatePlayerProfileParams(profileData: event.profileData),
    );

    result.fold(
      (failure) => emit(PlayerProfileError(message: failure.message)),
      (profile) => emit(PlayerProfileCreated(profile: profile)),
    );
  }

  Future<void> _onUpdatePlayerProfile(
    UpdatePlayerProfile event,
    Emitter<PlayerProfileState> emit,
  ) async {
    emit(const ProfileUpdating());

    final result = await _updatePlayerProfile(
      update_profile_usecase.UpdatePlayerProfileParams(
        playerId: event.playerId,
        profileData: event.profileData,
      ),
    );

    result.fold(
      (failure) => emit(PlayerProfileError(message: failure.message)),
      (profile) => emit(PlayerProfileUpdated(profile: profile)),
    );
  }

  Future<void> _onUploadProfilePhoto(
    UploadProfilePhoto event,
    Emitter<PlayerProfileState> emit,
  ) async {
    emit(const ProfilePhotoUploading(progress: 0.0));

    final result = await _uploadProfilePhoto(
      upload_photo_usecase.UploadProfilePhotoParams(
        playerId: event.playerId,
        photoFile: event.photoFile,
      ),
    );

    result.fold(
      (failure) => emit(ProfilePhotoUploadError(message: failure.message)),
      (photoUrl) => emit(ProfilePhotoUploaded(photoUrl: photoUrl)),
    );
  }

  // ============================================================================
  // Photo Event Handlers
  // ============================================================================

  Future<void> _onLoadPlayerPhotos(
    LoadPlayerPhotos event,
    Emitter<PlayerProfileState> emit,
  ) async {
    emit(const PlayerProfileLoading());

    final result = await _getPlayerPhotos(
      GetPlayerPhotosParams(playerId: event.playerId),
    );

    result.fold(
      (failure) => emit(PlayerProfileError(message: failure.message)),
      (photos) {
        _cachedPhotos = photos;
        emit(PlayerPhotosLoaded(photos: photos));
      },
    );
  }

  Future<void> _onUploadPlayerPhotoToGallery(
    UploadPlayerPhotoToGallery event,
    Emitter<PlayerProfileState> emit,
  ) async {
    emit(const PhotoUploading(progress: 0.0));

    final result = await _uploadPlayerPhoto(
      UploadPlayerPhotoParams(
        playerId: event.playerId,
        photoFile: event.photoFile,
        caption: event.caption,
        isPrimary: event.isPrimary,
      ),
    );

    result.fold(
      (failure) => emit(PhotoUploadError(message: failure.message)),
      (photo) {
        _cachedPhotos.add(photo);
        emit(PhotoUploadedToGallery(photo: photo, allPhotos: List.from(_cachedPhotos)));
      },
    );
  }

  Future<void> _onDeletePlayerPhotoFromGallery(
    DeletePlayerPhotoFromGallery event,
    Emitter<PlayerProfileState> emit,
  ) async {
    emit(const PlayerProfileLoading());

    final result = await _deletePlayerPhoto(
      DeletePlayerPhotoParams(
        playerId: event.playerId,
        photoId: event.photoId,
      ),
    );

    result.fold(
      (failure) => emit(PlayerProfileError(message: failure.message)),
      (_) {
        _cachedPhotos.removeWhere((photo) => photo.id == event.photoId);
        emit(PhotoDeletedFromGallery(
          photoId: event.photoId,
          remainingPhotos: List.from(_cachedPhotos),
        ));
      },
    );
  }

  // ============================================================================
  // Video Event Handlers
  // ============================================================================

  Future<void> _onLoadPlayerVideos(
    LoadPlayerVideos event,
    Emitter<PlayerProfileState> emit,
  ) async {
    emit(const PlayerProfileLoading());

    final result = await _getPlayerVideos(
      GetPlayerVideosParams(playerId: event.playerId),
    );

    result.fold(
      (failure) => emit(PlayerProfileError(message: failure.message)),
      (videos) {
        _cachedVideos = videos;
        emit(PlayerVideosLoaded(videos: videos));
      },
    );
  }

  Future<void> _onUploadPlayerVideoToGallery(
    UploadPlayerVideoToGallery event,
    Emitter<PlayerProfileState> emit,
  ) async {
    emit(const VideoUploading(progress: 0.0));

    final result = await _uploadPlayerVideo(
      UploadPlayerVideoParams(
        playerId: event.playerId,
        videoFile: event.videoFile,
        title: event.title,
        description: event.description,
        videoType: event.videoType,
        thumbnailFile: event.thumbnailFile,
      ),
    );

    result.fold(
      (failure) => emit(VideoUploadError(message: failure.message)),
      (video) {
        _cachedVideos.add(video);
        emit(VideoUploadedToGallery(video: video, allVideos: List.from(_cachedVideos)));
      },
    );
  }

  Future<void> _onDeletePlayerVideoFromGallery(
    DeletePlayerVideoFromGallery event,
    Emitter<PlayerProfileState> emit,
  ) async {
    emit(const PlayerProfileLoading());

    final result = await _deletePlayerVideo(
      DeletePlayerVideoParams(
        playerId: event.playerId,
        videoId: event.videoId,
      ),
    );

    result.fold(
      (failure) => emit(PlayerProfileError(message: failure.message)),
      (_) {
        _cachedVideos.removeWhere((video) => video.id == event.videoId);
        emit(VideoDeletedFromGallery(
          videoId: event.videoId,
          remainingVideos: List.from(_cachedVideos),
        ));
      },
    );
  }

  // ============================================================================
  // Statistics Event Handlers
  // ============================================================================

  Future<void> _onLoadPlayerStats(
    LoadPlayerStats event,
    Emitter<PlayerProfileState> emit,
  ) async {
    emit(const PlayerProfileLoading());

    final result = await _getPlayerStats(
      GetPlayerStatsParams(playerId: event.playerId),
    );

    result.fold(
      (failure) => emit(PlayerProfileError(message: failure.message)),
      (stats) {
        _cachedStats = stats;
        emit(PlayerStatsLoaded(stats: stats));
      },
    );
  }

  Future<void> _onCreatePlayerStatEntry(
    CreatePlayerStatEntry event,
    Emitter<PlayerProfileState> emit,
  ) async {
    emit(const StatsUpdating());

    final result = await _createPlayerStat(
      CreatePlayerStatParams(
        playerId: event.playerId,
        statData: event.statData,
      ),
    );

    result.fold(
      (failure) => emit(StatsOperationError(message: failure.message)),
      (stat) {
        _cachedStats.add(stat);
        emit(PlayerStatCreated(stat: stat, allStats: List.from(_cachedStats)));
      },
    );
  }

  Future<void> _onUpdatePlayerStatEntry(
    UpdatePlayerStatEntry event,
    Emitter<PlayerProfileState> emit,
  ) async {
    emit(const StatsUpdating());

    final result = await _updatePlayerStat(
      UpdatePlayerStatParams(
        playerId: event.playerId,
        statId: event.statId,
        statData: event.statData,
      ),
    );

    result.fold(
      (failure) => emit(StatsOperationError(message: failure.message)),
      (stat) {
        final index = _cachedStats.indexWhere((s) => s.id == event.statId);
        if (index != -1) {
          _cachedStats[index] = stat;
        }
        emit(PlayerStatUpdated(stat: stat, allStats: List.from(_cachedStats)));
      },
    );
  }

  Future<void> _onDeletePlayerStatEntry(
    DeletePlayerStatEntry event,
    Emitter<PlayerProfileState> emit,
  ) async {
    emit(const StatsUpdating());

    final result = await _deletePlayerStat(
      DeletePlayerStatParams(
        playerId: event.playerId,
        statId: event.statId,
      ),
    );

    result.fold(
      (failure) => emit(StatsOperationError(message: failure.message)),
      (_) {
        _cachedStats.removeWhere((stat) => stat.id == event.statId);
        emit(PlayerStatDeleted(
          statId: event.statId,
          remainingStats: List.from(_cachedStats),
        ));
      },
    );
  }

  // ============================================================================
  // Utility Event Handlers
  // ============================================================================

  Future<void> _onResetPlayerProfileState(
    ResetPlayerProfileState event,
    Emitter<PlayerProfileState> emit,
  ) async {
    _cachedPhotos = [];
    _cachedVideos = [];
    _cachedStats = [];
    emit(const PlayerProfileInitial());
  }
}
