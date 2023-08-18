import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/features/activity/domain/minimal_activity.dart';
import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/utils/image.dart';

class NewsActivity extends StatelessWidget {
  final MinimalActivity activity;
  final String? prefix;
  final bool navigateToActivityOnTap;

  const NewsActivity({
    super.key,
    required this.activity,
    this.prefix,
    this.navigateToActivityOnTap = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: !navigateToActivityOnTap
          ? null
          : () {
              context.pushNamed(
                AppRoute.activity.name,
                pathParameters: {
                  AppRouteParameter.activityId: activity.id.toString(),
                },
              );
            },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (prefix != null && prefix!.trim().isNotEmpty) ...[
            Text(prefix!),
            const SizedBox(width: 8)
          ],
          CircleAvatar(
            backgroundImage: getBackendImageOrLogoProvider(
              activity.thumbnail,
            ),
            radius: 12,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              activity.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
