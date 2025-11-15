import 'package:flutter/material.dart';
import '../../domain/entities/player_photo.dart';
import '../../../../core/theme/app_colors.dart';

/// Photo gallery widget displaying player photos in a grid
class PhotoGalleryWidget extends StatelessWidget {
  final List<PlayerPhoto> photos;
  final VoidCallback? onAddPhoto;
  final Function(PlayerPhoto)? onPhotoTap;

  const PhotoGalleryWidget({
    super.key,
    required this.photos,
    this.onAddPhoto,
    this.onPhotoTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.photo_library, color: AppColors.playerPrimary),
                    const SizedBox(width: 8),
                    Text(
                      'Photo Gallery',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                if (onAddPhoto != null)
                  TextButton.icon(
                    onPressed: onAddPhoto,
                    icon: const Icon(Icons.add_a_photo, size: 18),
                    label: const Text('Add'),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            if (photos.isEmpty)
              _buildEmptyState(context)
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: photos.length,
                itemBuilder: (context, index) {
                  final photo = photos[index];
                  return _buildPhotoTile(context, photo);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoTile(BuildContext context, PlayerPhoto photo) {
    return GestureDetector(
      onTap: onPhotoTap != null ? () => onPhotoTap!(photo) : null,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              photo.thumbnailUrl ?? photo.photoUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: Colors.grey[200],
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      strokeWidth: 2,
                    ),
                  ),
                );
              },
            ),
          ),
          if (photo.isPrimary)
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.playerPrimary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.star,
                  size: 12,
                  color: Colors.white,
                ),
              ),
            ),
          if (photo.caption != null && photo.caption!.isNotEmpty)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Text(
                  photo.caption!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.photo_library,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Photos Yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add photos to showcase your football journey',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
