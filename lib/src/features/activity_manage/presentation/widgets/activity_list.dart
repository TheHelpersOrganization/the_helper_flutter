import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/activity_manage/domain/activity.dart';
import 'package:the_helper/src/features/activity_manage/presentation/controllers/activity_manage_screen_controller.dart';
import 'package:the_helper/src/features/activity_manage/presentation/widgets/activity_list_item.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class CustomScrollList extends ConsumerWidget {
  const CustomScrollList({
    super.key,
    required this.status,
  });
  final int status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controllerProvider = getController(status);
    final pagingController = ref.watch(controllerProvider);
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          // Searchbar
          Expanded(
              child: PagedListView<int, ActivityModel>(
            pagingController: pagingController,
            builderDelegate: PagedChildBuilderDelegate(
                itemBuilder: (context, item, index) =>
                    ActivityListItem(data: item)),
          )),
        ],
      ),
    );
  }
}

AutoDisposeProvider<PagingController<int, ActivityModel>> getController(
    int status) {
  switch (status) {
    case 0:
      return ongoingPagingControllerProvider;
    case 1:
      return penddingPagingControllerProvider;
    case 2:
      return donePagingControllerProvider;
    case 3:
      return rejectPagingControllerProvider;
  }
  throw 'Missing paging controller';
}
