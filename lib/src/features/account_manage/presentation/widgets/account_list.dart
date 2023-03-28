import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/account_manage/domain/account.dart';
import 'package:the_helper/src/features/account_manage/presentation/widgets/account_list_item.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:the_helper/src/features/account_manage/presentation/controllers/account_manage_screen_controller.dart';

class CustomScrollList extends ConsumerWidget {
  const CustomScrollList({
    super.key,
    required this.isBanned,
  });
  final bool isBanned;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pagingController = ref.watch(
        isBanned ? bannedPagingControllerProvider : pagingControllerProvider);
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          // Searchbar
          Expanded(
              child: PagedListView<int, AccountModel>(
            pagingController: pagingController,
            builderDelegate: PagedChildBuilderDelegate(
                itemBuilder: (context, item, index) =>
                    AccountListItem(data: item)),
          )),
        ],
      ),
    );
  }
}
