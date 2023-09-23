import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/widget/bottom_sheet/custom_modal_botton_sheet.dart';

import '../../controllers/admin_home_controller.dart';

class SortOptionModal extends ConsumerWidget {
  final int filterValue;
  final Function callBackFunction;
  const SortOptionModal({
    super.key,
    required this.filterValue,
    required this.callBackFunction,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomModalBottomSheet(
      titleText: 'Sort by',
      content: Column(
        children: [
          Container(
            color:
                filterValue == 2 ? Theme.of(context).colorScheme.primary : null,
            child: ListTile(
              title: Text('Most participated',
                  style: filterValue == 2
                      ? const TextStyle(color: Colors.white)
                      : null),
              selected: filterValue == 2,
              selectedColor: Colors.white,
              trailing: filterValue == 2 ? const Icon(Icons.check) : null,
              onTap: () {
                callBackFunction(2);
                context.pop();
              },
            ),
          ),
          Container(
            color:
                filterValue == 3 ? Theme.of(context).colorScheme.primary : null,
            child: ListTile(
              title: Text('Highest rating',
                  style: filterValue == 3
                      ? const TextStyle(color: Colors.white)
                      : null),
              selected: filterValue == 3,
              selectedColor: Colors.white,
              trailing: filterValue == 3 ? const Icon(Icons.check) : null,
              onTap: () {
                callBackFunction(3);
                context.pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
