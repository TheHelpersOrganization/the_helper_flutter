import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/widget.dart';
import 'package:the_helper/src/features/news/domain/news.dart';
import 'package:the_helper/src/features/news/presentation/news_list/controller/news_list_mod_controller.dart';

class NewsTypeFilter extends ConsumerWidget {
  const NewsTypeFilter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsTypes = ref.watch(newsTypeFilterProvider);

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Text('Type: '),
        FilterChip(
          label: const Text('General'),
          selected: newsTypes.contains(NewsType.general),
          onSelected: (value) {
            if (value) {
              ref.read(newsTypeFilterProvider.notifier).state = {
                ...newsTypes,
                NewsType.general,
              };
            } else {
              ref.read(newsTypeFilterProvider.notifier).state = {
                ...newsTypes..remove(NewsType.general),
              };
            }
          },
        ),
        FilterChip(
          label: const Text('Activity'),
          selected: newsTypes.contains(NewsType.activity),
          onSelected: (value) {
            if (value) {
              ref.read(newsTypeFilterProvider.notifier).state = {
                ...newsTypes,
                NewsType.activity,
              };
            } else {
              ref.read(newsTypeFilterProvider.notifier).state = {
                ...newsTypes..remove(NewsType.activity),
              };
            }
          },
        ),
      ].sizedBoxSpacing(const SizedBox(width: 8)),
    );
  }
}
