import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/navigation/routes.dart';
import '../bloc/player_profile_bloc.dart';
import '../bloc/player_profile_event.dart';
import '../bloc/player_profile_state.dart';
import '../widgets/profile_header_widget.dart';
import '../widgets/stats_summary_widget.dart';
import '../widgets/photo_gallery_widget.dart';
import '../widgets/video_gallery_widget.dart';
import '../widgets/profile_info_card.dart';

/// Player profile view page displaying complete profile information
class PlayerProfileViewPage extends StatelessWidget {
  final String playerId;

  const PlayerProfileViewPage({
    super.key,
    required this.playerId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PlayerProfileBloc>()
        ..add(LoadPlayerProfile(playerId: playerId))
        ..add(LoadPlayerPhotos(playerId: playerId))
        ..add(LoadPlayerVideos(playerId: playerId))
        ..add(LoadPlayerStats(playerId: playerId)),
      child: Scaffold(
        body: BlocBuilder<PlayerProfileBloc, PlayerProfileState>(
          builder: (context, state) {
            if (state is PlayerProfileLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is PlayerProfileError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error Loading Profile',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        state.message,
                        style: TextStyle(color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<PlayerProfileBloc>().add(
                              LoadPlayerProfile(playerId: playerId),
                            );
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is PlayerProfileLoaded) {
              return _buildProfileContent(context, state);
            }

            // Handle other states
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildProfileContent(
    BuildContext context,
    PlayerProfileLoaded state,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<PlayerProfileBloc>()
          ..add(LoadPlayerProfile(playerId: playerId))
          ..add(LoadPlayerPhotos(playerId: playerId))
          ..add(LoadPlayerVideos(playerId: playerId))
          ..add(LoadPlayerStats(playerId: playerId));
      },
      child: CustomScrollView(
        slivers: [
          // Profile Header
          SliverToBoxAdapter(
            child: ProfileHeaderWidget(
              profile: state.profile,
              onEditPressed: () {
                // Navigate to edit profile
                Navigator.pushNamed(
                  context,
                  AppRoutes.playerProfileEdit,
                  arguments: state.profile,
                );
              },
            ),
          ),

          // Stats Summary
          SliverToBoxAdapter(
            child: BlocBuilder<PlayerProfileBloc, PlayerProfileState>(
              buildWhen: (previous, current) => current is PlayerStatsLoaded,
              builder: (context, statsState) {
                if (statsState is PlayerStatsLoaded) {
                  return StatsSummaryWidget(stats: statsState.stats);
                }
                return const SizedBox.shrink();
              },
            ),
          ),

          // Photo Gallery
          SliverToBoxAdapter(
            child: BlocBuilder<PlayerProfileBloc, PlayerProfileState>(
              buildWhen: (previous, current) => current is PlayerPhotosLoaded,
              builder: (context, photosState) {
                if (photosState is PlayerPhotosLoaded) {
                  return PhotoGalleryWidget(
                    photos: photosState.photos,
                    onAddPhoto: () {
                      // Navigate to add photo
                      _showAddPhotoDialog(context);
                    },
                    onPhotoTap: (photo) {
                      // Show full screen photo
                      _showPhotoViewer(context, photo.photoUrl);
                    },
                  );
                }
                return PhotoGalleryWidget(
                  photos: const [],
                  onAddPhoto: () => _showAddPhotoDialog(context),
                );
              },
            ),
          ),

          // Video Gallery
          SliverToBoxAdapter(
            child: BlocBuilder<PlayerProfileBloc, PlayerProfileState>(
              buildWhen: (previous, current) => current is PlayerVideosLoaded,
              builder: (context, videosState) {
                if (videosState is PlayerVideosLoaded) {
                  return VideoGalleryWidget(
                    videos: videosState.videos,
                    onAddVideo: () {
                      // Navigate to add video
                      _showAddVideoDialog(context);
                    },
                    onVideoTap: (video) {
                      // Play video
                      _playVideo(context, video.videoUrl);
                    },
                  );
                }
                return VideoGalleryWidget(
                  videos: const [],
                  onAddVideo: () => _showAddVideoDialog(context),
                );
              },
            ),
          ),

          // Profile Info Card
          SliverToBoxAdapter(
            child: ProfileInfoCard(profile: state.profile),
          ),

          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),
        ],
      ),
    );
  }

  void _showAddPhotoDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Photo upload feature coming soon'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showAddVideoDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Video upload feature coming soon'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showPhotoViewer(BuildContext context, String photoUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: InteractiveViewer(
              child: Image.network(photoUrl),
            ),
          ),
        ),
      ),
    );
  }

  void _playVideo(BuildContext context, String videoUrl) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Video player coming in Task 3.8'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
