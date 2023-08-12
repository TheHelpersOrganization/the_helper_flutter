import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/features/news/domain/news.dart';
import 'package:the_helper/src/features/news/presentation/common/widget/news_author.dart';
import 'package:the_helper/src/features/news/presentation/news/controller/news_controller.dart';
import 'package:the_helper/src/features/news/presentation/news/widget/news_organization_and_date.dart';
import 'package:the_helper/src/features/news/presentation/news/widget/news_thumbnail.dart';

class NewsScreen extends ConsumerWidget {
  final int newsId;
  final News? cachedNews;

  const NewsScreen({
    super.key,
    required this.newsId,
    this.cachedNews,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final news = ref.watch(newsProvider(newsId));

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          const SliverAppBar(
            title: Text('News'),
            floating: true,
          )
        ],
        body: news.when(
          skipLoadingOnRefresh: false,
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (_, __) => Center(
            child: CustomErrorWidget(
              message: 'Failed to load news',
              onRetry: () {
                ref.invalidate(newsProvider(newsId));
              },
            ),
          ),
          data: (news) {
            return Padding(
              padding: const EdgeInsets.all(12),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NewsThumbnail(news: news),
                    const SizedBox(height: 24),
                    NewsOrganizationAndDate(
                      organization: news.organization!,
                      publishedAt: news.publishedAt,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      news.title,
                      style: context.theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    NewsAuthor(
                      author: news.author!,
                      authorPrefix: 'Author:',
                      navigateToProfileOnTap: true,
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Html(
                      data: news.content,
                      style: {'body': Style(margin: Margins.zero)},
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
