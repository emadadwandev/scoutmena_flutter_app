import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';

/// Widget for uploading profile photo
class PhotoUploadWidget extends StatelessWidget {
  final File? photo;
  final ValueChanged<File?> onPhotoSelected;
  final String? existingPhotoUrl;

  const PhotoUploadWidget({
    super.key,
    required this.photo,
    required this.onPhotoSelected,
    this.existingPhotoUrl,
  });

  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();

    final source = await showModalBottomSheet<ImageSource>(
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

    if (source != null) {
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        onPhotoSelected(File(image.path));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Profile Photo',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => _pickImage(context),
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
              border: Border.all(
                color: AppColors.playerPrimary,
                width: 3,
              ),
            ),
            child: ClipOval(
              child: photo != null
                  ? Image.file(
                      photo!,
                      fit: BoxFit.cover,
                    )
                  : existingPhotoUrl != null
                      ? Image.network(
                          existingPhotoUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildPlaceholder();
                          },
                        )
                      : _buildPlaceholder(),
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: () => _pickImage(context),
          icon: Icon(
            photo != null ? Icons.edit : Icons.add_a_photo,
            size: 20,
          ),
          label: Text(photo != null ? 'Change Photo' : 'Add Photo'),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Icon(
      Icons.person,
      size: 60,
      color: Colors.grey[400],
    );
  }
}
