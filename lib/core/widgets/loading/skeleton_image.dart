import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// A skeleton placeholder for image elements
/// Used during loading states to show where images will appear
class SkeletonImage extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final BoxShape shape;

  const SkeletonImage({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
  });

  /// Creates a circular skeleton (for avatars)
  factory SkeletonImage.circle({
    required double size,
  }) {
    return SkeletonImage(
      width: size,
      height: size,
      shape: BoxShape.circle,
    );
  }

  /// Creates a rectangular skeleton with rounded corners
  factory SkeletonImage.rounded({
    required double width,
    required double height,
    double radius = 8.0,
  }) {
    return SkeletonImage(
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(radius),
    );
  }

  /// Creates a square skeleton
  factory SkeletonImage.square({
    required double size,
    double radius = 8.0,
  }) {
    return SkeletonImage(
      width: size,
      height: size,
      borderRadius: BorderRadius.circular(radius),
    );
  }

  /// Creates a skeleton for a thumbnail (small image)
  factory SkeletonImage.thumbnail({
    double size = 60.0,
  }) {
    return SkeletonImage(
      width: size,
      height: size,
      borderRadius: BorderRadius.circular(8),
    );
  }

  /// Creates a skeleton for a banner/cover image
  factory SkeletonImage.banner({
    double? width,
    double height = 200.0,
  }) {
    return SkeletonImage(
      width: width ?? double.infinity,
      height: height,
      borderRadius: BorderRadius.circular(12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: shape,
          borderRadius: shape == BoxShape.circle ? null : borderRadius,
        ),
        child: shape == BoxShape.circle
            ? null
            : const Icon(
                Icons.image_outlined,
                color: Colors.grey,
                size: 48,
              ),
      ),
    );
  }
}
