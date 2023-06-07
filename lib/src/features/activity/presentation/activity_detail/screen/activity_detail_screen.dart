import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/screens/error_screen.dart';
import 'package:the_helper/src/common/widget/app_bar/custom_sliver_app_bar.dart';
import 'package:the_helper/src/common/widget/custom_sliver_scroll_view.dart';
import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/controller/activity_controller.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/widget/activity_overview_view.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/widget/activity_thumbnail.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/widget/activity_title.dart';

enum TabType {
  overview,
  shifts,
}

class ActivityDetailScreen extends ConsumerStatefulWidget {
  const ActivityDetailScreen({super.key, required this.activityId});

  final int activityId;

  @override
  ConsumerState<ActivityDetailScreen> createState() =>
      _ActivityDetailScreenState();
}

class _ActivityDetailScreenState extends ConsumerState<ActivityDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: TabType.values.length, vsync: this);
    _tabController.addListener(() {
      final index = _tabController.index;
      ref.read(currentTabProvider.notifier).state = TabType.values[index];
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activity = ref.watch(getActivityProvider(widget.activityId));
    final tab = ref.watch(currentTabProvider);

    return Scaffold(
      drawer: const AppDrawer(),
      body: activity.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) {
          return const ErrorScreen();
        },
        data: (activity) {
          if (activity == null) {
            return const ErrorScreen();
          }

          return CustomSliverScrollView(
            appBar: const CustomSliverAppBar(
              showBackButton: true,
              actions: [],
            ),
            body: Padding(
              padding: const EdgeInsets.all(12),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ActivityThumbnail(
                      activity: activity,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    ActivityTitle(activity: activity),
                    const SizedBox(
                      height: 16,
                    ),
                    TabBar(
                      controller: _tabController,
                      tabs: const [
                        Tab(text: 'Overview'),
                        Tab(text: 'Shifts'),
                      ],
                      indicatorSize: TabBarIndicatorSize.tab,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    getTabAt(tab, activity),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget getTabAt(TabType tabType, Activity activity) {
    switch (tabType) {
      case TabType.overview:
        return ActivityOverviewView(activity: activity);
      case TabType.shifts:
        return const Text('Shifts');
    }
  }
}
