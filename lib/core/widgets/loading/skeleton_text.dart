import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// A skeleton placeholder for text elements
/// Used during loading states to show where text will appear
class SkeletonText extends StatelessWidget {
  final double? width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonText({
    super.key,
    this.width,
    this.height = 16.0,
    this.borderRadius,
  });

  /// Creates a skeleton for a single line of text
  factory SkeletonText.singleLine({
    double? width,
    double height = 16.0,
  }) {
    return SkeletonText(
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(4),
    );
  }

  /// Creates a skeleton for a heading (larger text)
  factory SkeletonText.heading({
    double? width,
    double height = 24.0,
  }) {
    return SkeletonText(
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(4),
    );
  }

  /// Creates a skeleton for a subtitle (medium text)
  factory SkeletonText.subtitle({
    double? width,
    double height = 14.0,
  }) {
    return SkeletonText(
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(4),
    );
  }

  /// Creates a skeleton for a paragraph (multiple lines)
  factory SkeletonText.paragraph({
    int lines = 3,
    double? width,
  }) {
    return SkeletonText(
      width: width,
      height: (16.0 * lines) + (8.0 * (lines - 1)), // line height + spacing
      borderRadius: BorderRadius.circular(4),
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
          borderRadius: borderRadius ?? BorderRadius.circular(4),
        ),
      ),
    );
  }
}
