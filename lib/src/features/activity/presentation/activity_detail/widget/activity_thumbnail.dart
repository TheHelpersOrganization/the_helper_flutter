import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/utils/domain_provider.dart';

class ActivityThumbnail extends StatelessWidget {
  final Activity activity;

  const ActivityThumbnail({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: activity.thumbnail == null
          ? SvgPicture.asset('assets/images/role_volunteer.svg')
          : CachedNetworkImage(
              imageUrl: getImageUrl(activity.thumbnail!),
              width: context.mediaQuery.size.width,
              height: 240,
              fit: BoxFit.fitWidth,
            ),
    );
  }
}
