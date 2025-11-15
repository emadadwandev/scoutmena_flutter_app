import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/player_video.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/player_profile_bloc.dart';
import '../bloc/player_profile_event.dart';
import '../bloc/player_profile_state.dart';
import 'video_player_page.dart';

/// Video gallery management page for uploading and managing player videos
class VideoGalleryManagementPage extends StatefulWidget {
  final String playerId;

  const VideoGalleryManagementPage({
    super.key,
    required this.playerId,
  });

  @override
  State<VideoGalleryManagementPage> createState() =>
      _VideoGalleryManagementPageState();
}

class _VideoGalleryManagementPageState
    extends State<VideoGalleryManagementPage> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickAndUploadVideo() async {
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.videocam),
              title: const Text('Record Video'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.video_library),
              title: const Text('Choose from Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source != null && mounted) {
      final XFile? video = await _picker.pickVideo(
        source: source,
        maxDuration: const Duration(minutes: 5), // 5 minute max
      );

      if (video != null && mounted) {
        _showVideoDetailsDialog(File(video.path));
      }
    }
  }

  void _showVideoDetailsDialog(File videoFile) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedType = 'highlight';

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Video Details'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title *',
                    hintText: 'e.g., Match Highlights vs Team X',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 100,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (Optional)',
                    hintText: 'Describe what\'s shown in the video',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  maxLength: 500,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Video Type',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'highlight',
                      child: Text('Highlights'),
                    ),
                    DropdownMenuItem(
                      value: 'training',
                      child: Text('Training Session'),
                    ),
                    DropdownMenuItem(
                      value: 'match',
                      child: Text('Full Match'),
                    ),
                    DropdownMenuItem(
                      value: 'skill',
                      child: Text('Skills Showcase'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedType = value ?? 'highlight';
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a title'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }

                Navigator.pop(dialogContext);
                if (mounted) {
                  context.read<PlayerProfileBloc>().add(
                        UploadPlayerVideoToGallery(
                          playerId: widget.playerId,
                          videoFile: videoFile,
                          title: titleController.text.trim(),
                          description: descriptionController.text.isEmpty
                              ? null
                              : descriptionController.text.trim(),
                          videoType: selectedType,
                        ),
                      );
                }
              },
              child: const Text('Upload'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(PlayerVideo video) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Video'),
        content: Text('Are you sure you want to delete "${video.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              if (mounted) {
                context.read<PlayerProfileBloc>().add(
                      DeletePlayerVideoFromGallery(
                        playerId: widget.playerId,
                        videoId: video.id,
                      ),
                    );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _playVideo(PlayerVideo video) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerPage(video: video),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PlayerProfileBloc>()
        ..add(LoadPlayerVideos(playerId: widget.playerId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Video Gallery'),
          actions: [
            IconButton(
              icon: const Icon(Icons.video_call),
              onPressed: _pickAndUploadVideo,
              tooltip: 'Add Video',
            ),
          ],
        ),
        body: BlocConsumer<PlayerProfileBloc, PlayerProfileState>(
          listener: (context, state) {
            if (state is VideoUploadedToGallery) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Video uploaded successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is VideoDeletedFromGallery) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Video deleted'),
                  backgroundColor: Colors.orange,
                ),
              );
            } else if (state is VideoUploadError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is PlayerProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is VideoUploading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: state.progress,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.progress != null
                          ? 'Uploading... ${(state.progress! * 100).toInt()}%'
                          : 'Uploading...',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This may take a few minutes',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              );
            }

            if (state is PlayerVideosLoaded ||
                state is VideoUploadedToGallery ||
                state is VideoDeletedFromGallery) {
              final videos = state is PlayerVideosLoaded
                  ? state.videos
                  : state is VideoUploadedToGallery
                      ? state.allVideos
                      : (state as VideoDeletedFromGallery).remainingVideos;

              if (videos.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: videos.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return _buildVideoCard(videos[index]);
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _pickAndUploadVideo,
          icon: const Icon(Icons.video_call),
          label: const Text('Add Video'),
          backgroundColor: AppColors.playerPrimary,
        ),
      ),
    );
  }

  Widget _buildVideoCard(PlayerVideo video) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: InkWell(
        onTap: () => _playVideo(video),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: video.thumbnailUrl != null
                      ? Image.network(
                          video.thumbnailUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.videocam,
                                size: 64,
                                color: Colors.grey,
                              ),
                            );
                          },
                        )
                      : Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.videocam,
                            size: 64,
                            color: Colors.grey,
                          ),
                        ),
                ),
                Positioned.fill(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      video.formattedDuration,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Video Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          video.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDelete(video),
                        tooltip: 'Delete Video',
                      ),
                    ],
                  ),
                  if (video.description != null &&
                      video.description!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      video.description!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildVideoTag(video.videoType),
                      const Spacer(),
                      Icon(
                        Icons.visibility,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${video.views} views',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoTag(String type) {
    Color tagColor;
    String label;

    switch (type.toLowerCase()) {
      case 'highlight':
        tagColor = Colors.orange;
        label = 'Highlights';
        break;
      case 'training':
        tagColor = Colors.blue;
        label = 'Training';
        break;
      case 'match':
        tagColor = Colors.green;
        label = 'Match';
        break;
      case 'skill':
        tagColor = Colors.purple;
        label = 'Skills';
        break;
      default:
        tagColor = Colors.grey;
        label = type;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: tagColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: tagColor.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: tagColor,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.videocam,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Videos Yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Upload highlights, training sessions, or match videos to showcase your skills',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _pickAndUploadVideo,
            icon: const Icon(Icons.video_call),
            label: const Text('Add Your First Video'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.playerPrimary,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
