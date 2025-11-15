import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/player_photo.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/player_profile_bloc.dart';
import '../bloc/player_profile_event.dart';
import '../bloc/player_profile_state.dart';

/// Photo gallery management page for uploading and managing player photos
class PhotoGalleryManagementPage extends StatefulWidget {
  final String playerId;

  const PhotoGalleryManagementPage({
    super.key,
    required this.playerId,
  });

  @override
  State<PhotoGalleryManagementPage> createState() =>
      _PhotoGalleryManagementPageState();
}

class _PhotoGalleryManagementPageState
    extends State<PhotoGalleryManagementPage> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickAndUploadPhoto() async {
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Take Photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source != null && mounted) {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 85,
      );

      if (image != null && mounted) {
        _showCaptionDialog(File(image.path));
      }
    }
  }

  void _showCaptionDialog(File photoFile) {
    final captionController = TextEditingController();
    bool isPrimary = false;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Photo Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: captionController,
                decoration: const InputDecoration(
                  labelText: 'Caption (Optional)',
                  hintText: 'Describe this photo',
                  border: OutlineInputBorder(),
                ),
                maxLength: 100,
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Set as Primary Photo'),
                subtitle: const Text('This will be your main profile photo'),
                value: isPrimary,
                onChanged: (value) {
                  setState(() {
                    isPrimary = value ?? false;
                  });
                },
              ),
            ],
          ),
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
                        UploadPlayerPhotoToGallery(
                          playerId: widget.playerId,
                          photoFile: photoFile,
                          caption: captionController.text.isEmpty
                              ? null
                              : captionController.text,
                          isPrimary: isPrimary,
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

  void _confirmDelete(PlayerPhoto photo) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Photo'),
        content: const Text('Are you sure you want to delete this photo?'),
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
                      DeletePlayerPhotoFromGallery(
                        playerId: widget.playerId,
                        photoId: photo.id,
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PlayerProfileBloc>()
        ..add(LoadPlayerPhotos(playerId: widget.playerId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Photo Gallery'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add_a_photo),
              onPressed: _pickAndUploadPhoto,
              tooltip: 'Add Photo',
            ),
          ],
        ),
        body: BlocConsumer<PlayerProfileBloc, PlayerProfileState>(
          listener: (context, state) {
            if (state is PhotoUploadedToGallery) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Photo uploaded successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is PhotoDeletedFromGallery) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Photo deleted'),
                  backgroundColor: Colors.orange,
                ),
              );
            } else if (state is PhotoUploadError) {
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

            if (state is PhotoUploading) {
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
                  ],
                ),
              );
            }

            if (state is PlayerPhotosLoaded ||
                state is PhotoUploadedToGallery ||
                state is PhotoDeletedFromGallery) {
              final photos = state is PlayerPhotosLoaded
                  ? state.photos
                  : state is PhotoUploadedToGallery
                      ? state.allPhotos
                      : (state as PhotoDeletedFromGallery).remainingPhotos;

              if (photos.isEmpty) {
                return _buildEmptyState();
              }

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: photos.length,
                itemBuilder: (context, index) {
                  return _buildPhotoCard(photos[index]);
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _pickAndUploadPhoto,
          icon: const Icon(Icons.add_a_photo),
          label: const Text('Add Photo'),
          backgroundColor: AppColors.playerPrimary,
        ),
      ),
    );
  }

  Widget _buildPhotoCard(PlayerPhoto photo) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Photo
          Image.network(
            photo.photoUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image, size: 50),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
          ),

          // Gradient overlay at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (photo.caption != null && photo.caption!.isNotEmpty)
                    Text(
                      photo.caption!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (photo.isPrimary)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.playerPrimary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, size: 12, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            'Primary',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Delete button
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.white,
              style: IconButton.styleFrom(
                backgroundColor: Colors.red.withOpacity(0.8),
                padding: const EdgeInsets.all(8),
              ),
              onPressed: () => _confirmDelete(photo),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Photos Yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Start building your gallery by adding photos',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _pickAndUploadPhoto,
            icon: const Icon(Icons.add_a_photo),
            label: const Text('Add Your First Photo'),
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
