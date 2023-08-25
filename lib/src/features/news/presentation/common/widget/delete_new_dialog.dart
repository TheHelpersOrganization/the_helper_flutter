import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/widget/dialog/confirmation_dialog.dart';
import 'package:the_helper/src/features/news/presentation/common/controller/news_common_controller.dart';

class DeleteNewsDialog extends ConsumerWidget {
  final int newsId;

  const DeleteNewsDialog({super.key, required this.newsId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConfirmationDialog(
      titleText: 'Delete news',
      content: const Text(
        'Are you sure you want to delete this news?',
      ),
      showActionCanNotBeUndoneText: true,
      onConfirm: () {
        context.pop();
        ref
            .read(deleteNewsControllerProvider.notifier)
            .deleteNews(id: newsId, navigateAfterDelete: true);
      },
    );
  }
}
