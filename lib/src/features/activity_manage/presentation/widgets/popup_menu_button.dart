import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/account_manage/domain/account.dart';
import 'package:the_helper/src/features/account_manage/presentation/widgets/active_account_list_item.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:the_helper/src/features/account_manage/presentation/controllers/account_manage_screen_controller.dart';

class PopupButton extends ConsumerWidget {
  const PopupButton({
    super.key,
    required this.accountId,
  });
  final int accountId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton(
        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
          const PopupMenuItem(
            child: Text('Detail'),
          ),
          const PopupMenuItem(
            child: Text('Banned'),
          ),
          const PopupMenuItem(
            child: Text('Delete'),
          ),
        ]
    );
  }
}
