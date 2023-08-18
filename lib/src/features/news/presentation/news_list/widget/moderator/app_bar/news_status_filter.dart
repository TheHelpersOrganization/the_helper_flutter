import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/widget.dart';
import 'package:the_helper/src/features/news/presentation/news_list/controller/news_list_mod_controller.dart';

class NewsStatusFilter extends ConsumerWidget {
  const NewsStatusFilter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPublished = ref.watch(isPublishedFilterProvider);

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Text('Status: '),
        FilterChip(
          label: const Text('All'),
          selected: isPublished == null,
          onSelected: (value) {
            if (value) {
              ref.read(isPublishedFilterProvider.notifier).state = null;
            }
          },
        ),
        FilterChip(
          label: const Text('Published'),
          selected: isPublished == true,
          onSelected: (value) {
            if (value) {
              ref.read(isPublishedFilterProvider.notifier).state = true;
            }
          },
        ),
        FilterChip(
          label: const Text('Draft'),
          selected: isPublished == false,
          onSelected: (value) {
            if (value) {
              ref.read(isPublishedFilterProvider.notifier).state = false;
            }
          },
        ),
      ].sizedBoxSpacing(const SizedBox(width: 8)),
    );
  }
}
