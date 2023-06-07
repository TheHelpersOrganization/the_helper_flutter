import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/screens/error_screen.dart';
import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/widget/activity_overview_view.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/widget/activity_thumbnail.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/widget/activity_title.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_management/controller/mod_activity_management_controller.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_management/widget/mod_activity_shift_management_screen.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/router/router.dart';

class ModActivityManagementScreen extends ConsumerStatefulWidget {
  const ModActivityManagementScreen({super.key, required this.activityId});

  final int activityId;

  @override
  ConsumerState<ModActivityManagementScreen> createState() =>
      _ModActivityManagementState();
}

class _ModActivityManagementState
    extends ConsumerState<ModActivityManagementScreen>
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
    final tab = ref.watch(currentTabProvider);
    final activityAndShifts =
        ref.watch(getActivityAndShiftsProvider(widget.activityId));

    return Scaffold(
      drawer: const AppDrawer(),
      floatingActionButton: activityAndShifts.maybeWhen(
        data: (data) => tab == TabType.overview
            ? FloatingActionButton.extended(
                onPressed: () {},
                icon: const Icon(Icons.edit),
                label: const Text('Edit Activity'),
              )
            : FloatingActionButton.extended(
                onPressed: () {
                  context.goNamed(
                    AppRoute.shiftCreation.name,
                    pathParameters: {
                      'activityId': data!.activity.id.toString()
                    },
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Shift'),
              ),
        orElse: () => null,
      ),
      body: activityAndShifts.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) {
          return const ErrorScreen();
        },
        data: (data) {
          if (data == null) {
            return const ErrorScreen();
          }

          return NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                floating: true,
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.delete_outline),
                  ),
                ],
              ),
            ],
            body: Padding(
              padding: const EdgeInsets.all(12),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ActivityThumbnail(
                      activity: data.activity,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    ActivityTitle(activity: data.activity),
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
                    getTabAt(tab, data.activity, data.shifts),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget getTabAt(TabType tabType, Activity activity, List<Shift> shifts) {
    switch (tabType) {
      case TabType.overview:
        return ActivityOverviewView(
          activity: activity,
          hasShift: shifts.isNotEmpty,
        );
      case TabType.shift:
        return ModActivityShiftManagementView(
          shifts: shifts,
        );
    }
  }
}
