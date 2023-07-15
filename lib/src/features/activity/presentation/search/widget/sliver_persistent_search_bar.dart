import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/search_bar/debounce_search_bar.dart';
import 'package:the_helper/src/features/activity/presentation/search/controller/activity_controller.dart';

class SliverPersistentSearchBar extends SliverPersistentHeaderDelegate {
  const SliverPersistentSearchBar({Key? key}) : super();

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Align(
      child: Consumer(
        builder: (context, ref, _) => Container(
          color: context.theme.colorScheme.background,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: DebounceSearchBar(
                    debounceDuration: const Duration(seconds: 1),
                    onDebounce: (value) {
                      ref.read(searchPatternProvider.notifier).state = value;
                      ref.read(hasUsedSearchProvider.notifier).state = true;
                    },
                    onClear: () {
                      ref.read(searchPatternProvider.notifier).state = '';
                      ref.read(hasUsedSearchProvider.notifier).state = true;
                    },
                  ),
                ),
                IconButton(
                  padding: const EdgeInsets.only(left: 12),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  icon: const Icon(Icons.filter_list_outlined),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 84;

  @override
  double get minExtent => 84;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
