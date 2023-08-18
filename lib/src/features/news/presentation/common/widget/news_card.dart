import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/extension/date_time.dart';
import 'package:the_helper/src/common/extension/string.dart';
import 'package:the_helper/src/common/widget/label.dart';
import 'package:the_helper/src/features/change_role/domain/user_role.dart';
import 'package:the_helper/src/features/news/domain/news.dart';
import 'package:the_helper/src/features/news/presentation/common/widget/news_author.dart';
import 'package:the_helper/src/features/news/presentation/common/widget/news_card_bottom_sheet.dart';
import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/utils/domain_provider.dart';
import 'package:the_helper/src/utils/image.dart';

class NewsCard extends StatelessWidget {
  final News news;
  final Role viewMode;

  const NewsCard({
    super.key,
    required this.news,
    this.viewMode = Role.volunteer,
  });

  @override
  Widget build(BuildContext context) {
    final organization = news.organization;

    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 0,
      ),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 170,
        child: InkWell(
          onTap: () {
            if (viewMode.isModerator) {
              showModalBottomSheet(
                context: context,
                showDragHandle: true,
                builder: (context) => NewsCardBottomSheet(
                  news: news,
                ),
              );
            } else {
              context.pushNamed(AppRoute.newsDetail.name, pathParameters: {
                AppRouteParameter.newsId: news.id.toString(),
              });
            }
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                clipBehavior: Clip.antiAlias,
                width: 130,
                height: double.infinity,
                child: news.thumbnail != null
                    ? CachedNetworkImage(
                        imageUrl: getImageUrl(news.thumbnail!),
                        fit: BoxFit.cover,
                        errorWidget: (context, error, stackTrace) =>
                            SvgPicture.asset(
                          'assets/images/news_placeholder.svg',
                        ),
                      )
                    : SvgPicture.asset(
                        'assets/images/news_placeholder.svg',
                        fit: BoxFit.cover,
                      ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (viewMode.isVolunteer)
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: getBackendImageOrLogoProvider(
                                organization?.logo,
                              ),
                              radius: 12,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                organization?.name ?? 'Unknown organization',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 8),
                      Text(
                        news.title,
                        style: context.theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      if (viewMode.isModerator) ...[
                        NewsAuthor(
                          author: news.author!,
                        ),
                        const SizedBox(height: 8),
                      ],
                      Row(
                        children: [
                          Text(
                            news.publishedAt.timeAgo(),
                            style: TextStyle(
                              color: context.theme.colorScheme.secondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(width: 4),
                          const Text('•'),
                          const SizedBox(width: 4),
                          const Icon(Icons.visibility_outlined, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${news.views} views',
                            style: TextStyle(
                              color: context.theme.colorScheme.secondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Label(labelText: news.type.name.capitalize()),
                            if (viewMode.isModerator) ...[
                              const SizedBox(width: 4),
                              if (news.isPublished)
                                const Label(
                                  labelText: 'Published',
                                  color: Colors.green,
                                )
                              else
                                Label(
                                  labelText: 'Draft',
                                  color: Colors.grey.shade600,
                                ),
                            ]
                          ],
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
