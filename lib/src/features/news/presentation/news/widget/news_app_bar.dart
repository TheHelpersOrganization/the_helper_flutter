import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/features/change_role/application/role_service.dart';
import 'package:the_helper/src/features/change_role/domain/user_role.dart';
import 'package:the_helper/src/features/news/presentation/common/widget/delete_new_dialog.dart';
import 'package:the_helper/src/router/router.dart';

class NewsAppBar extends ConsumerWidget {
  final int newsId;

  const NewsAppBar({
    super.key,
    required this.newsId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(roleServiceProvider).valueOrNull;

    return SliverAppBar(
      title: const Text('News'),
      floating: true,
      actions: role != Role.moderator
          ? null
          : [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () {
                  context.goNamed(AppRoute.newsUpdate.name, pathParameters: {
                    AppRouteParameter.newsId: newsId.toString(),
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () {
                  showDialog(
                    useRootNavigator: false,
                    context: context,
                    builder: (context) => DeleteNewsDialog(newsId: newsId),
                  );
                },
              ),
              const SizedBox(width: 8),
            ],
    );
  }
}
