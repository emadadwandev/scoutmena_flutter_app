import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../bloc/player_profile_bloc.dart';
import '../bloc/player_profile_event.dart';
import '../bloc/player_profile_state.dart';
import '../widgets/profile_hero_header.dart';
import '../widgets/key_stats_widget.dart';
import '../widgets/about_section_widget.dart';
import '../widgets/skills_attributes_widget.dart';
import '../widgets/video_highlights_section.dart';
import '../widgets/career_history_widget.dart';

/// Redesigned Player Profile Page matching new UI design
class PlayerProfileRedesignedPage extends StatelessWidget {
  final String playerId;

  const PlayerProfileRedesignedPage({
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
        backgroundColor: Colors.grey[100],
        body: BlocBuilder<PlayerProfileBloc, PlayerProfileState>(
          builder: (context, state) {
            if (state is PlayerProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is PlayerProfileError) {
              return _buildErrorState(context, state.message);
            }

            if (state is PlayerProfileLoaded) {
              return _buildProfileContent(context, state);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
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
              message,
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent(
    BuildContext context,
    PlayerProfileLoaded state,
  ) {
    // Get primary photo safely
    String? primaryPhotoUrl;
    if (state.photos != null && state.photos!.isNotEmpty) {
      try {
        final primaryPhoto = state.photos!.firstWhere(
          (photo) => photo.isPrimary,
          orElse: () => state.photos!.first,
        );
        primaryPhotoUrl = primaryPhoto.photoUrl;
      } catch (e) {
        // If no photos available, primaryPhotoUrl remains null
        print('DEBUG: No primary photo available');
      }
    }

    return CustomScrollView(
      slivers: [
        // Hero Header with Profile Photo Overlay
        SliverToBoxAdapter(
          child: ProfileHeroHeader(
            profile: state.profile,
            primaryPhotoUrl: primaryPhotoUrl,
          ),
        ),

        // Key Stats Section
        SliverToBoxAdapter(
          child: KeyStatsWidget(
            profile: state.profile,
            stats: state.stats ?? [],
          ),
        ),

        // About Section
        SliverToBoxAdapter(
          child: AboutSectionWidget(profile: state.profile),
        ),

        // Skills & Attributes
        SliverToBoxAdapter(
          child: SkillsAttributesWidget(profile: state.profile),
        ),

        // Video Highlights
        SliverToBoxAdapter(
          child: VideoHighlightsSection(videos: state.videos ?? []),
        ),

        // Career History
        SliverToBoxAdapter(
          child: CareerHistoryWidget(profile: state.profile),
        ),

        // Bottom Action Buttons
        SliverToBoxAdapter(
          child: _buildBottomActions(context, state.profile),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Widget _buildBottomActions(BuildContext context, profile) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Favorite Button
          Expanded(
            flex: 1,
            child: OutlinedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Added to favorites')),
                );
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: const BorderSide(color: Colors.blue, width: 2),
              ),
              child: const Icon(Icons.star_border, color: Colors.blue, size: 28),
            ),
          ),
          const SizedBox(width: 16),
          
          // Contact Button
          Expanded(
            flex: 3,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Contact feature coming soon')),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                'CONTACT PLAYER',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Share Button
          Expanded(
            flex: 1,
            child: OutlinedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Share profile')),
                );
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: const BorderSide(color: Colors.blue, width: 2),
              ),
              child: const Icon(Icons.share, color: Colors.blue, size: 28),
            ),
          ),
        ],
      ),
    );
  }
}
