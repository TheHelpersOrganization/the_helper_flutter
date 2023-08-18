import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/screens/error_screen.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/features/change_role/application/role_service.dart';
import 'package:the_helper/src/features/change_role/domain/user_role.dart';
import 'package:the_helper/src/features/news/presentation/common/controller/news_common_controller.dart';
import 'package:the_helper/src/features/news/presentation/news_list/screen/news_list_mod_screen.dart';
import 'package:the_helper/src/features/news/presentation/news_list/screen/news_list_volunteer_screen.dart';
import 'package:the_helper/src/utils/async_value_ui.dart';

class NewsListScreen extends ConsumerWidget {
  const NewsListScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roleState = ref.watch(roleServiceProvider);

    ref.listen(deleteNewsControllerProvider, (previous, next) {
      next.showSnackbarOnSuccess(
        context,
        content: const Text('Delete news successfully'),
        name: deleteNewsSnackbarName,
      );
      next.showSnackbarOnError(
        context,
        name: deleteNewsSnackbarName,
      );
    });

    return roleState.when(
      skipLoadingOnRefresh: false,
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (_, __) => Scaffold(
        body: Center(
          child: CustomErrorWidget(
            message: 'Invalid account',
            onRetry: () => ref.invalidate(roleServiceProvider),
          ),
        ),
      ),
      data: (role) {
        if (role == Role.volunteer) {
          return const NewsListVolunteerScreen();
        } else if (role == Role.moderator) {
          return const NewsListModScreen();
        } else {
          return const ErrorScreen();
        }
      },
    );
  }
}
