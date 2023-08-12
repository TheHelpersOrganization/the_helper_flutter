import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/extension/date_time.dart';
import 'package:the_helper/src/features/news/domain/news.dart';
import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/utils/domain_provider.dart';
import 'package:the_helper/src/utils/image.dart';

class LargeNewsCard extends StatelessWidget {
  final News news;

  const LargeNewsCard({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    final organization = news.organization;

    return SizedBox(
      width: 260,
      child: Card(
        margin: const EdgeInsets.only(right: 12),
        child: InkWell(
          onTap: () {
            context.goNamed(AppRoute.newsDetail.name, pathParameters: {
              AppRouteParameter.newsId: news.id.toString(),
            });
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: SizedBox(
                      height: 150,
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
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.local_fire_department,
                            color: Colors.redAccent,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Popular',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: getBackendImageOrLogoProvider(
                            organization?.logo,
                          ),
                          radius: 12,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          organization?.name ?? 'Unknown organization',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      news.title,
                      style: context.theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
