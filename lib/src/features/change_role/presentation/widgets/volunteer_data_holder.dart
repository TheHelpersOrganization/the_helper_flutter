import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class VolunteerDataHolder extends StatelessWidget {
  final double itemWidth;
  final double itemHeight;
  final int itemCount;

  const VolunteerDataHolder({
    super.key,
    required this.itemWidth,
    required this.itemHeight,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for(int i = 0; i < itemCount; i++)
          SkeletonAvatar(
            style: SkeletonAvatarStyle(
              height: itemHeight,
              width: itemWidth,
            ),
        ),
      ],
    );
  }
}
