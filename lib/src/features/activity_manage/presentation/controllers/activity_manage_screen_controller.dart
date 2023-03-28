import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:the_helper/src/features/activity_manage/data/activity_reposity.dart';
import 'package:the_helper/src/features/activity_manage/domain/activity.dart';

class ActivityManageScreenController
    extends AutoDisposeAsyncNotifier<List<ActivityModel>> {
  @override
  FutureOr<List<ActivityModel>> build() {
    return ref.watch(activityRepositoryProvider).getAll();
  }
}

final ongoingPagingControllerProvider = Provider.autoDispose(
  (ref) {
    final activityRepository = ref.watch(activityRepositoryProvider);
    final controller =
        PagingController<int, ActivityModel>(firstPageKey: 0);
    controller.addPageRequestListener((pageKey) async {
      try {
        final items = await activityRepository.getAll(
          offset: pageKey * 100,
          status: 0,
        );
        final isLastPage = items.length < 100;
        if (isLastPage) {
          controller.appendLastPage(items);
        } else {
          controller.appendPage(items, pageKey + 1);
        }
      } catch (err) {
        controller.error = err;
      }
    });
    
    return controller;
  },
);

final penddingPagingControllerProvider = Provider.autoDispose(
  (ref) {
    final activityRepository = ref.watch(activityRepositoryProvider);
    final controller =
        PagingController<int, ActivityModel>(firstPageKey: 0);
    controller.addPageRequestListener((pageKey) async {
      try {
        final items = await activityRepository.getAll(
          offset: pageKey * 100,
          status: 1,
        );
        final isLastPage = items.length < 100;
        if (isLastPage) {
          controller.appendLastPage(items);
        } else {
          controller.appendPage(items, pageKey + 1);
        }
      } catch (err) {
        controller.error = err;
      }
    });
    
    return controller;
  },
);

final donePagingControllerProvider = Provider.autoDispose(
  (ref) {
    final activityRepository = ref.watch(activityRepositoryProvider);
    final controller =
        PagingController<int, ActivityModel>(firstPageKey: 0);
    controller.addPageRequestListener((pageKey) async {
      try {
        final items = await activityRepository.getAll(
          offset: pageKey * 100,
          status: 2,
        );
        final isLastPage = items.length < 100;
        if (isLastPage) {
          controller.appendLastPage(items);
        } else {
          controller.appendPage(items, pageKey + 1);
        }
      } catch (err) {
        controller.error = err;
      }
    });
    
    return controller;
  },
);

final rejectPagingControllerProvider = Provider.autoDispose(
  (ref) {
    final activityRepository = ref.watch(activityRepositoryProvider);
    final controller =
        PagingController<int, ActivityModel>(firstPageKey: 0);
    controller.addPageRequestListener((pageKey) async {
      try {
        final items = await activityRepository.getAll(
          offset: pageKey * 100,
          status: 1,
        );
        final isLastPage = items.length < 100;
        if (isLastPage) {
          controller.appendLastPage(items);
        } else {
          controller.appendPage(items, pageKey + 1);
        }
      } catch (err) {
        controller.error = err;
      }
    });
    
    return controller;
  },
);
