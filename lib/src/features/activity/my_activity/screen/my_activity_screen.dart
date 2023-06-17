import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/extension/date_time.dart';
import 'package:the_helper/src/common/extension/widget.dart';
import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';
import 'package:the_helper/src/common/widget/no_data_found.dart';
import 'package:the_helper/src/features/activity/my_activity/controller/my_activity_controller.dart';
import 'package:the_helper/src/features/activity/my_activity/widget/label.dart';
import 'package:the_helper/src/features/activity/my_activity/widget/shift_volunteer_bottom_sheet.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/controller/activity_controller.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/features/shift_volunteer/domain/shift_volunteer.dart';
import 'package:the_helper/src/utils/async_value_ui.dart';

enum TabType {
  ongoing,
  upcoming,
  completed,
  other,
}

class TabElement {
  final TabType type;
  final String tabTitle;
  final String? noDataTitle;
  final String? noDataSubtitle;

  const TabElement({
    required this.type,
    required this.tabTitle,
    this.noDataTitle,
    this.noDataSubtitle,
  });
}

final List<TabElement> tabElements = [
  const TabElement(
    type: TabType.ongoing,
    tabTitle: 'Ongoing',
    noDataTitle: 'No organization found',
    noDataSubtitle: 'Look like you haven\'t joined any organization yet',
  ),
  const TabElement(
    type: TabType.upcoming,
    tabTitle: 'Upcoming',
    noDataTitle: 'No pending join request',
  ),
  const TabElement(
    type: TabType.completed,
    tabTitle: 'Completed',
    noDataTitle: 'No pending join request',
  ),
  // const TabElement(
  //   type: TabType.other,
  //   tabTitle: 'Others',
  //   noDataTitle: 'No rejected join request',
  // ),
];

class MyActivityScreen extends ConsumerWidget {
  const MyActivityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pagingController = ref.watch(myActivityPagingControllerProvider);
    final tabType = ref.watch(tabTypeProvider);

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

    return DefaultTabController(
      length: tabElements.length,
      child: Builder(
        builder: (context) {
          final TabController tabController = DefaultTabController.of(context);
          tabController.addListener(() {
            if (tabController.indexIsChanging) {
              ref.read(tabTypeProvider.notifier).state =
                  tabElements[tabController.index].type;
              ref.read(hasChangedProvider.notifier).state = true;
            }
          });

          return Scaffold(
            drawer: const AppDrawer(),
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  title: const Text('My Activities'),
                  floating: true,
                  bottom: TabBar(
                    //isScrollable: true,
                    tabs: tabElements
                        .map(
                          (e) => Tab(
                            text: e.tabTitle,
                          ),
                        )
                        .toList(),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {},
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.filter_list),
                    ),
                  ],
                ),
                PagedSliverList<int, Shift>(
                  pagingController: pagingController,
                  builderDelegate: PagedChildBuilderDelegate(
                    itemBuilder: (context, shift, index) {
                      final volunteer = shift.myShiftVolunteer!;
                      final volunteerStatus = volunteer.status;
                      String updatedAtHead = '';
                      if (volunteerStatus == ShiftVolunteerStatus.approved) {
                        updatedAtHead = 'Approved at';
                      } else if (volunteerStatus ==
                          ShiftVolunteerStatus.pending) {
                        updatedAtHead = 'Registered at';
                      } else if (volunteerStatus ==
                          ShiftVolunteerStatus.rejected) {
                        updatedAtHead = 'Rejected at';
                      }
                      Widget leading;
                      if (volunteerStatus == ShiftVolunteerStatus.approved) {
                        leading = const Icon(
                          Icons.check_circle_outline_outlined,
                        );
                      } else if (volunteerStatus ==
                          ShiftVolunteerStatus.pending) {
                        leading = const Icon(
                          Icons.pending_outlined,
                        );
                      } else if (volunteerStatus ==
                          ShiftVolunteerStatus.rejected) {
                        leading = const Icon(
                          Icons.cancel_outlined,
                        );
                      } else {
                        leading = const Icon(
                          Icons.error_outline_outlined,
                        );
                      }
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        //leading: leading,
                        title: Text(shift.name),
                        subtitle: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_month_outlined,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Start at ${shift.startTime.formatDayMonthYearBulletHourSecond()}',
                                  style: TextStyle(
                                      color: context
                                          .theme.colorScheme.onSurfaceVariant),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                if (DateTime.now().microsecondsSinceEpoch -
                                            shift.startTime
                                                .microsecondsSinceEpoch >
                                        0 &&
                                    DateTime.now().microsecondsSinceEpoch -
                                            shift.startTime
                                                .microsecondsSinceEpoch <
                                        1000 * 60 * 60 * 24)
                                  const Label(
                                    labelText: 'Starting soon',
                                    color: Colors.amber,
                                  ),
                                if (volunteerStatus ==
                                    ShiftVolunteerStatus.approved)
                                  const Label(labelText: 'Approved'),
                                if (volunteerStatus ==
                                    ShiftVolunteerStatus.pending)
                                  const Label(
                                    labelText: 'Waiting for approval',
                                    color: Colors.grey,
                                  ),
                                if (shift.status == ShiftStatus.completed &&
                                    volunteer.completion > 0)
                                  const Label(
                                    labelText: 'Reviewed',
                                    color: Colors.green,
                                  ),
                              ].sizedBoxSpacing(const SizedBox(
                                width: 4,
                              )),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.more_vert_outlined),
                          onPressed: () {
                            showModalBottomSheet(
                              showDragHandle: true,
                              context: context,
                              builder: (context) => ShiftVolunteerBottomSheet(
                                volunteer: volunteer,
                                shift: shift,
                              ),
                            );
                          },
                        ),
                        onTap: () {
                          showModalBottomSheet(
                            showDragHandle: true,
                            context: context,
                            builder: (context) => ShiftVolunteerBottomSheet(
                              volunteer: volunteer,
                              shift: shift,
                            ),
                          );
                        },
                      );
                    },
                    noItemsFoundIndicatorBuilder: (context) => const Center(
                      child: NoDataFound(
                        contentTitle: 'Your list is empty',
                        contentSubtitle: 'No work need to be done for now',
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
