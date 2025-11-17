import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/navigation/routes.dart';
import '../bloc/player_profile_bloc.dart';
import '../bloc/player_profile_event.dart';
import '../bloc/player_profile_state.dart';
import '../widgets/profile_header_widget.dart';
import '../widgets/profile_info_card.dart';
import '../widgets/stats_summary_widget.dart';
import '../widgets/photo_gallery_widget.dart';
import '../widgets/video_gallery_widget.dart';

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
      child: BlocBuilder<PlayerProfileBloc, PlayerProfileState>(
        builder: (context, state) {
          Widget body;
          Widget? bottomBar;

          if (state is PlayerProfileLoading) {
            body = const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is PlayerProfileError) {
            body = Center(
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
          } else if (state is PlayerProfileLoaded) {
            body = _buildProfileContent(context, state);
            bottomBar = _buildBottomActionBar(context, state.profile);
          } else {
            body = const SizedBox.shrink();
          }

          return Scaffold(
            body: body,
            bottomNavigationBar: bottomBar,
          );
        },
      ),
    );
  }

  Widget _buildBottomActionBar(BuildContext context, dynamic profile) {
    // profile is PlayerProfile but keeping dynamic to match state import
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.playerProfileEdit);
              },
              icon: const Icon(Icons.edit),
              label: const Text('Edit'),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {
                Share.share(
                  'Check out ${profile.fullName} on ScoutMena!\n\n'
                  'Age: ${profile.age}\n'
                  'Position: ${profile.positions.isNotEmpty ? profile.positions.first : ''}\n'
                  '${profile.currentClub != null ? 'Club: ${profile.currentClub}\n' : ''}',
                  subject: '${profile.fullName} - ScoutMena Profile',
                );
              },
              icon: const Icon(Icons.share),
            ),
            const Spacer(),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'report') {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Report Profile'),
                      content: Text('Report ${profile.fullName}?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Report submitted')),
                            );
                          },
                          child: const Text('Report'),
                        ),
                      ],
                    ),
                  );
                } else if (value == 'block') {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Block User'),
                      content: Text('Block ${profile.fullName}?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${profile.fullName} blocked')),
                            );
                          },
                          style: TextButton.styleFrom(foregroundColor: Colors.red),
                          child: const Text('Block'),
                        ),
                      ],
                    ),
                  );
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'report', child: Text('Report')),
                const PopupMenuItem(value: 'block', child: Text('Block')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent(
    BuildContext context,
    PlayerProfileLoaded state,
  ) {
    return CustomScrollView(
      slivers: [
        // Profile Header
        SliverToBoxAdapter(
          child: ProfileHeaderWidget(
            profile: state.profile,
            onEditPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.playerProfileEdit,
              );
            },
          ),
        ),

        // Profile Information Card
        SliverToBoxAdapter(
          child: ProfileInfoCard(profile: state.profile),
        ),

        // Statistics Summary
        if (state.stats != null && state.stats!.isNotEmpty)
          SliverToBoxAdapter(
            child: StatsSummaryWidget(stats: state.stats!),
          ),

        // Photo Gallery
        if (state.photos != null && state.photos!.isNotEmpty)
          SliverToBoxAdapter(
            child: PhotoGalleryWidget(
              photos: state.photos!,
              onAddPhoto: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.photoGallery,
                );
              },
              onPhotoTap: (photo) {
                Navigator.pushNamed(
                  context,
                  AppRoutes.photoViewer,
                  arguments: {
                    'photo': photo,
                    'photoGallery': state.photos,
                    'initialIndex': state.photos!.indexOf(photo),
                  },
                );
              },
            ),
          ),

        // Video Gallery
        if (state.videos != null && state.videos!.isNotEmpty)
          SliverToBoxAdapter(
            child: VideoGalleryWidget(
              videos: state.videos!,
              onAddVideo: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.videoGallery,
                );
              },
              onVideoTap: (video) {
                Navigator.pushNamed(
                  context,
                  AppRoutes.videoPlayer,
                  arguments: video,
                );
              },
            ),
          ),

        // Bottom spacing for scroll
        const SliverToBoxAdapter(
          child: SizedBox(height: 32),
        ),
      ],
    );
  }
}
