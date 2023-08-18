import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/news/domain/news.dart';
import 'package:the_helper/src/features/news/presentation/common/widget/delete_new_dialog.dart';
import 'package:the_helper/src/router/router.dart';

class NewsCardBottomSheet extends StatelessWidget {
  final News news;

  const NewsCardBottomSheet({
    super.key,
    required this.news,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            news.title,
            style: context.theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.newspaper_outlined),
          title: const Text('View news'),
          onTap: () {
            context.pop();
            context.goNamed(
              AppRoute.newsDetail.name,
              pathParameters: {
                AppRouteParameter.newsId: news.id.toString(),
              },
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.edit_outlined),
          title: const Text('Edit news'),
          onTap: () {
            context.pop();
            context.goNamed(
              AppRoute.newsUpdate.name,
              pathParameters: {
                AppRouteParameter.newsId: news.id.toString(),
              },
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.delete_outline),
          title: const Text('Delete news'),
          iconColor: Colors.red,
          textColor: Colors.red,
          onTap: () {
            context.pop();
            showDialog(
              useRootNavigator: false,
              context: context,
              builder: (context) => DeleteNewsDialog(newsId: news.id),
            );
          },
        ),
      ],
    );
  }
}
