import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/widget/custom_sliver_scroll_view.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_management/controller/mod_activity_management_controller.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_management/screen/mod_activity_shift_management_screen.dart';

class ModActivityManagementScreen extends ConsumerWidget {
  final int activityId;

  const ModActivityManagementScreen({
    super.key,
    required this.activityId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(currentTabProvider);

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        body: CustomSliverScrollView(
          appBar: SliverAppBar(
            title: const Text('Activity Management'),
            bottom: TabBar(
              tabs: tabs.map((e) => Tab(text: e.tabTitle)).toList(),
              onTap: (value) {
                ref.read(currentTabProvider.notifier).state = tabs[value].type;
              },
            ),
          ),
          body: TabBarView(
            children: [
              const Text('Overview'),
              ModActivityShiftManagementScreen(
                activityId: activityId,
              ),
            ],
          ),
        ),
        floatingActionButton: currentTab == TabType.overview
            ? FloatingActionButton.extended(
                onPressed: () {},
                icon: const Icon(Icons.edit),
                label: const Text('Edit Activity'),
              )
            : FloatingActionButton.extended(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Shift'),
              ),
      ),
    );
  }
}
