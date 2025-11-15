import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'skeleton_image.dart';
import 'skeleton_text.dart';

/// A skeleton placeholder for list tile elements
/// Used during loading states for lists of items
class SkeletonListTile extends StatelessWidget {
  final bool hasLeading;
  final bool hasTrailing;
  final bool hasSubtitle;
  final EdgeInsetsGeometry? padding;

  const SkeletonListTile({
    super.key,
    this.hasLeading = true,
    this.hasTrailing = false,
    this.hasSubtitle = true,
    this.padding,
  });

  /// Creates a skeleton for a player list item
  factory SkeletonListTile.player() {
    return const SkeletonListTile(
      hasLeading: true,
      hasTrailing: true,
      hasSubtitle: true,
    );
  }

  /// Creates a skeleton for a scout list item
  factory SkeletonListTile.scout() {
    return const SkeletonListTile(
      hasLeading: true,
      hasTrailing: false,
      hasSubtitle: true,
    );
  }

  /// Creates a skeleton for a notification list item
  factory SkeletonListTile.notification() {
    return const SkeletonListTile(
      hasLeading: true,
      hasTrailing: false,
      hasSubtitle: true,
    );
  }

  /// Creates a skeleton for a message list item
  factory SkeletonListTile.message() {
    return const SkeletonListTile(
      hasLeading: true,
      hasTrailing: true,
      hasSubtitle: true,
    );
  }

  /// Creates a skeleton for a simple list item (no avatar)
  factory SkeletonListTile.simple() {
    return const SkeletonListTile(
      hasLeading: false,
      hasTrailing: false,
      hasSubtitle: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Leading (avatar or icon)
          if (hasLeading) ...[
            SkeletonImage.circle(size: 48),
            const SizedBox(width: 16),
          ],
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SkeletonText.singleLine(width: 150, height: 16),
                if (hasSubtitle) ...[
                  const SizedBox(height: 8),
                  SkeletonText.subtitle(width: 200, height: 14),
                ],
              ],
            ),
          ),
          // Trailing (icon or timestamp)
          if (hasTrailing) ...[
            const SizedBox(width: 16),
            SkeletonText.subtitle(width: 40, height: 14),
          ],
        ],
      ),
    );
  }
}

/// A skeleton placeholder for a vertical list
class SkeletonList extends StatelessWidget {
  final int itemCount;
  final bool hasLeading;
  final bool hasTrailing;
  final bool hasSubtitle;
  final bool showDivider;

  const SkeletonList({
    super.key,
    this.itemCount = 5,
    this.hasLeading = true,
    this.hasTrailing = false,
    this.hasSubtitle = true,
    this.showDivider = true,
  });

  /// Creates a skeleton list for players
  factory SkeletonList.players({int itemCount = 5}) {
    return SkeletonList(
      itemCount: itemCount,
      hasLeading: true,
      hasTrailing: true,
      hasSubtitle: true,
    );
  }

  /// Creates a skeleton list for scouts
  factory SkeletonList.scouts({int itemCount = 5}) {
    return SkeletonList(
      itemCount: itemCount,
      hasLeading: true,
      hasTrailing: false,
      hasSubtitle: true,
    );
  }

  /// Creates a skeleton list for notifications
  factory SkeletonList.notifications({int itemCount = 5}) {
    return SkeletonList(
      itemCount: itemCount,
      hasLeading: true,
      hasTrailing: false,
      hasSubtitle: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.separated(
        itemCount: itemCount,
        separatorBuilder: (context, index) =>
            showDivider ? const Divider(height: 1) : const SizedBox.shrink(),
        itemBuilder: (context, index) {
          return SkeletonListTile(
            hasLeading: hasLeading,
            hasTrailing: hasTrailing,
            hasSubtitle: hasSubtitle,
          );
        },
      ),
    );
  }
}
