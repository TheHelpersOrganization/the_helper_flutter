import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:the_helper/src/features/organization_manage/presentation/widgets/custom_item_list.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:the_helper/src/features/organization_manage/presentation/controllers/organization_manage_screen_controller.dart';

class PopupButton extends ConsumerWidget {
  const PopupButton({
    super.key,
    this.accountId,
  });
  final int? accountId;

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
            ]);
  }
}
