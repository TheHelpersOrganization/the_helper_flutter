import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/news/data/news_repository.dart';
import 'package:the_helper/src/features/news/presentation/news_list/controller/news_list_mod_controller.dart';
import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/utils/async_value.dart';

class DeleteNewsController extends AutoDisposeAsyncNotifier<void> {
  late NewsRepository _newsRepository;

  @override
  FutureOr<void> build() {
    _newsRepository = ref.watch(newsRepositoryProvider);
  }

  Future<void> deleteNews({
    required int id,
    bool navigateAfterDelete = false,
  }) async {
    state = const AsyncLoading();
    final res = await guardAsyncValue(() => _newsRepository.deleteNews(id: id));
    if (res.hasError) {
      state = AsyncError(res.error!, res.stackTrace!);
      return;
    }
    state = const AsyncData(null);
    ref.invalidate(organizationNewsListPagedNotifierProvider);
    if (navigateAfterDelete) {
      ref.read(routerProvider).goNamed(AppRoute.news.name);
    }
  }
}

final deleteNewsControllerProvider =
    AutoDisposeAsyncNotifierProvider<DeleteNewsController, void>(
  () => DeleteNewsController(),
);
