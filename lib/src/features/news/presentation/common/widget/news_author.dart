import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/features/profile/domain/profile.dart';
import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/utils/image.dart';
import 'package:the_helper/src/utils/profile.dart';

class NewsAuthor extends StatelessWidget {
  final Profile author;
  final String? authorPrefix;
  final bool navigateToProfileOnTap;

  const NewsAuthor({
    super.key,
    required this.author,
    this.authorPrefix,
    this.navigateToProfileOnTap = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: !navigateToProfileOnTap
          ? null
          : () {
              context.pushNamed(
                AppRoute.otherProfile.name,
                pathParameters: {
                  AppRouteParameter.profileId: author.id.toString(),
                },
              );
            },
      child: Row(
        children: [
          if (authorPrefix != null && authorPrefix!.trim().isNotEmpty) ...[
            Text(authorPrefix!),
            const SizedBox(width: 8)
          ],
          CircleAvatar(
            backgroundImage: getBackendImageOrLogoProvider(
              author.avatarId,
            ),
            radius: 12,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              getProfileName(author),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
