import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/activity/presentation/search/controller/activity_controller.dart';
import 'package:the_helper/src/features/activity/presentation/search/widget/activity_list.dart';

class SearchActivityView extends ConsumerWidget {
  const SearchActivityView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchPattern = ref.watch(searchPatternProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Search results for "$searchPattern"',
          style: context.theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        const Expanded(
          child: Center(child: ActivityList()),
        ),
      ],
    );
  }
}
