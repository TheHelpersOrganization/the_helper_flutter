import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class ActivityListPlaceholder extends StatelessWidget {
  final int itemCount;
  final double itemWidth;
  final double itemHeight;

  const ActivityListPlaceholder({
    super.key,
    required this.itemCount,
    required this.itemWidth,
    required this.itemHeight,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: SkeletonAvatar(
          style: SkeletonAvatarStyle(
            width: itemWidth,
            height: itemHeight,
          ),
        ),
      ),
      itemCount: itemCount,
    );
  }
}
