import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'skeleton_image.dart';
import 'skeleton_text.dart';

/// A skeleton placeholder for card elements
/// Used during loading states for player cards, scout cards, etc.
class SkeletonCard extends StatelessWidget {
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const SkeletonCard({
    super.key,
    this.width,
    this.height,
    this.padding,
    this.margin,
  });

  /// Creates a skeleton for a player profile card
  factory SkeletonCard.playerProfile() {
    return const SkeletonCard(
      height: 280,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  /// Creates a skeleton for a scout profile card
  factory SkeletonCard.scoutProfile() {
    return const SkeletonCard(
      height: 200,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  /// Creates a skeleton for a video card
  factory SkeletonCard.video() {
    return const SkeletonCard(
      height: 240,
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  /// Creates a skeleton for a stats card
  factory SkeletonCard.stats() {
    return const SkeletonCard(
      height: 120,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover/Banner image
          SkeletonImage.banner(
            width: double.infinity,
            height: 120,
          ),
          const SizedBox(height: 16),
          // Avatar
          Row(
            children: [
              SkeletonImage.circle(size: 60),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonText.heading(width: 150),
                    const SizedBox(height: 8),
                    SkeletonText.subtitle(width: 100),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Description
          SkeletonText.singleLine(width: double.infinity),
          const SizedBox(height: 8),
          SkeletonText.singleLine(width: 200),
        ],
      ),
    );
  }
}

/// A skeleton placeholder for a horizontal scrolling card list
class SkeletonCardList extends StatelessWidget {
  final int itemCount;
  final double itemWidth;
  final double itemHeight;

  const SkeletonCardList({
    super.key,
    this.itemCount = 3,
    this.itemWidth = 280,
    this.itemHeight = 200,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: itemHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: itemWidth,
              height: itemHeight,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
      ),
    );
  }
}
