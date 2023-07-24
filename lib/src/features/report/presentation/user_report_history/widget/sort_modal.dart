import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/widget/bottom_sheet/custom_modal_botton_sheet.dart';
import 'package:the_helper/src/features/report/presentation/user_report_history/controller/report_history_screen_controller.dart';

class SortOptionModal extends ConsumerWidget {
  final bool byDate;
  final bool byNewest;
  const SortOptionModal({
    super.key,
    required this.byDate,
    required this.byNewest,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomModalBottomSheet(
      titleText: 'Sort by',
      content: Column(
        children: [
          Container(
            color: !byDate && byNewest
                ? Theme.of(context).colorScheme.primary
                : null,
            child: ListTile(
              title: Text('Newest updated date',
                  style: !byDate && byNewest
                      ? const TextStyle(color: Colors.white)
                      : null),
              selected: !byDate && byNewest,
              selectedColor: Colors.white,
              trailing: !byDate && byNewest ? const Icon(Icons.check) : null,
              onTap: () {
                ref.read(sortBySendDateProvider.notifier).state = false;
                ref.read(sortByNewestProvider.notifier).state = true;
                context.pop();
              },
            ),
          ),
          Container(
            color: !byDate && !byNewest
                ? Theme.of(context).colorScheme.primary
                : null,
            child: ListTile(
              title: Text('Oldest updated date',
                  style: !byDate && !byNewest
                      ? const TextStyle(color: Colors.white)
                      : null),
              selected: !byDate && !byNewest,
              selectedColor: Colors.white,
              trailing: !byDate && !byNewest ? const Icon(Icons.check) : null,
              onTap: () {
                ref.read(sortBySendDateProvider.notifier).state = false;
                ref.read(sortByNewestProvider.notifier).state = false;
                context.pop();
              },
            ),
          ),
          Container(
            color: byDate && byNewest
                ? Theme.of(context).colorScheme.primary
                : null,
            child: ListTile(
              title: Text('Newest created date',
                  style: byDate && byNewest
                      ? const TextStyle(color: Colors.white)
                      : null),
              selected: byDate && byNewest,
              selectedColor: Colors.white,
              trailing: byDate && byNewest ? const Icon(Icons.check) : null,
              onTap: () {
                ref.read(sortBySendDateProvider.notifier).state = true;
                ref.read(sortByNewestProvider.notifier).state = true;
                context.pop();
              },
            ),
          ),
          Container(
            color: byDate && !byNewest
                ? Theme.of(context).colorScheme.primary
                : null,
            child: ListTile(
              title: Text('Oldest created date',
                  style: byDate && !byNewest
                      ? const TextStyle(color: Colors.white)
                      : null),
              selected: byDate && !byNewest,
              selectedColor: Colors.white,
              trailing: byDate && !byNewest ? const Icon(Icons.check) : null,
              onTap: () {
                ref.read(sortBySendDateProvider.notifier).state = true;
                ref.read(sortByNewestProvider.notifier).state = false;
                context.pop();
              },
            ),
          )
        ],
      ),
    );
  }
}
