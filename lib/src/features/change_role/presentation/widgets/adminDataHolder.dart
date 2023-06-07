import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class AdminDataHolder extends StatelessWidget {
  final int itemCount;
  final double itemWidth;
  final double itemHeight;

  const AdminDataHolder({
    super.key,
    required this.itemCount,
    required this.itemWidth,
    required this.itemHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        for(int i = 0; i < itemCount; i++)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: SkeletonAvatar(
            style: SkeletonAvatarStyle(
              width: itemWidth,
              height: itemHeight,
            ),
          ),
        ),
      ],
    );
  }
}
