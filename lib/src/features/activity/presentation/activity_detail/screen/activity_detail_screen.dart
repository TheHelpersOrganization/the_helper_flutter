import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/screens/screen404.dart';
import 'package:the_helper/src/common/widget/app_bar/custom_sliver_app_bar.dart';
import 'package:the_helper/src/common/widget/custom_sliver_scroll_view.dart';
import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/controller/activity_controller.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/widget/activity_overview_view.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/widget/activity_shift_view.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/widget/activity_thumbnail.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/widget/activity_title.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/widget/joined_shift_notification/activity_joined_shift_notification.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/widget/joined_shift_notification/activity_no_joined_shift_notification.dart';
import 'package:the_helper/src/features/shift/domain/shift_volunteer.dart';
import 'package:the_helper/src/utils/async_value_ui.dart';

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
    final tab = ref.watch(currentTabProvider);
    final extendedActivityState =
        ref.watch(getActivityAndShiftsProvider(widget.activityId));
    final shiftVolunteerState = ref.watch(joinShiftControllerProvider);

    ref.listen<AsyncValue>(
      joinShiftControllerProvider,
      (_, state) {
        state.showSnackbarOnError(
          context,
          name: shiftSnackbarName,
        );
        state.showSnackbarOnSuccess(
          context,
          content: const Text('Shift registered successfully'),
          name: shiftSnackbarName,
        );
      },
    );
    ref.listen<AsyncValue>(
      cancelJoinShiftControllerProvider,
      (_, state) {
        state.showSnackbarOnError(
          context,
          name: shiftSnackbarName,
        );
        state.showSnackbarOnSuccess(
          context,
          content: const Text('Shift registration cancelled successfully'),
          name: shiftSnackbarName,
        );
      },
    );
    ref.listen<AsyncValue>(
      leaveShiftControllerProvider,
      (_, state) {
        state.showSnackbarOnError(
          context,
          name: shiftSnackbarName,
        );
        state.showSnackbarOnSuccess(
          context,
          content: const Text('Leave shift successfully'),
          name: shiftSnackbarName,
        );
      },
    );

    return Scaffold(
      drawer: const AppDrawer(),
      body: extendedActivityState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) {
          return CustomErrorWidget(
            onRetry: () => ref.invalidate(getActivityAndShiftsProvider),
          );
        },
        data: (extendedActivity) {
          if (extendedActivity == null) {
            return const DevelopingScreen();
          }
          final activity = extendedActivity.activity;
          final shiftVolunteers = extendedActivity.myShiftVolunteers;
          final pendingShiftVolunteers = shiftVolunteers
              .where(
                  (element) => element.status == ShiftVolunteerStatus.pending)
              .toList();
          final approvedShiftVolunteers = shiftVolunteers
              .where(
                  (element) => element.status == ShiftVolunteerStatus.approved)
              .toList();

          return CustomSliverScrollView(
            appBar: const CustomSliverAppBar(
              showBackButton: true,
              actions: [],
            ),
            body: Padding(
              padding: const EdgeInsets.all(12),
              child: SingleChildScrollView(
                key: const Key('activity_detail_screen_scroll_view'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ActivityThumbnail(
                      activity: activity,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    ActivityTitle(activity: activity),
                    if (pendingShiftVolunteers.isEmpty &&
                        approvedShiftVolunteers.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: ActivityNoJoinedShiftNotification(
                          onSuggestionTap: () => _tabController.animateTo(1),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: ActivityJoinedShiftNotification(
                          pendingShiftsCount: pendingShiftVolunteers.length,
                          approvedShiftsCount: approvedShiftVolunteers.length,
                        ),
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
                    getTabAt(tab, extendedActivity),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget getTabAt(TabType tabType, ExtendedActivity extendedActivity) {
    switch (tabType) {
      case TabType.overview:
        return ActivityOverviewView(activity: extendedActivity.activity);
      case TabType.shifts:
        return ActivityShiftView(
          shifts: extendedActivity.shifts,
          volunteers: extendedActivity.myShiftVolunteers,
        );
    }
  }
}
