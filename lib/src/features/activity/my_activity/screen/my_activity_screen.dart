import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';
import 'package:the_helper/src/common/widget/no_data_found.dart';
import 'package:the_helper/src/common/widget/search_bar/debounce_search_bar.dart';
import 'package:the_helper/src/features/activity/my_activity/controller/my_activity_controller.dart';
import 'package:the_helper/src/features/activity/my_activity/widget/my_shift_card.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/controller/activity_controller.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
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
    noDataTitle: 'No activity found',
  ),
  const TabElement(
    type: TabType.upcoming,
    tabTitle: 'Upcoming',
    noDataTitle: 'No activity found',
  ),
  const TabElement(
    type: TabType.completed,
    tabTitle: 'Completed',
    noDataTitle: 'No activity found',
  ),
];

class MyActivityScreen extends ConsumerWidget {
  const MyActivityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSearching = ref.watch(isSearchingProvider);
    final searchPattern = ref.watch(searchPatternProvider);
    final pagingController = ref.watch(myActivityPagingControllerProvider);
    final tabType = ref.watch(tabTypeProvider);

    ref.listen<AsyncValue>(
      cancelJoinShiftControllerProvider,
      (_, state) {
        state.showSnackbarOnError(
          context,
          name: myShiftSnackbarName,
        );
        state.showSnackbarOnSuccess(
          context,
          content: const Text('Shift registration cancelled successfully'),
          name: myShiftSnackbarName,
        );
      },
    );
    ref.listen<AsyncValue>(
      leaveShiftControllerProvider,
      (_, state) {
        state.showSnackbarOnError(
          context,
          name: myShiftSnackbarName,
        );
        state.showSnackbarOnSuccess(
          context,
          content: const Text('Leave shift successfully'),
          name: myShiftSnackbarName,
        );
      },
    );
    ref.listen<AsyncValue>(
      checkInControllerProvider,
      (_, state) {
        state.showSnackbarOnError(
          context,
          name: myShiftSnackbarName,
        );
      },
    );
    ref.listen<AsyncValue>(
      checkOutControllerProvider,
      (_, state) {
        state.showSnackbarOnError(
          context,
          name: myShiftSnackbarName,
        );
      },
    );

    return DefaultTabController(
      length: tabElements.length,
      child: Builder(
        builder: (context) {
          final TabController tabController = DefaultTabController.of(context);
          final tabIndex = tabController.index;
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
                  title: isSearching
                      ? DebounceSearchBar(
                          small: true,
                          hintText: 'Find shift or activity',
                          initialValue: searchPattern,
                          onDebounce: (value) {
                            ref.read(searchPatternProvider.notifier).state =
                                value;
                            ref.read(hasChangedProvider.notifier).state = true;
                          },
                          onClear: () {
                            ref.read(searchPatternProvider.notifier).state =
                                null;
                            ref.read(hasChangedProvider.notifier).state = true;
                          },
                          debounceDuration: const Duration(seconds: 1),
                        )
                      : const Text('My Shifts'),
                  floating: true,
                  leading: isSearching
                      ? BackButton(
                          onPressed: () => ref
                              .read(isSearchingProvider.notifier)
                              .state = false,
                        )
                      : null,
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
                    if (!isSearching)
                      IconButton(
                        onPressed: () {
                          ref.read(isSearchingProvider.notifier).state =
                              !isSearching;
                        },
                        icon: const Icon(Icons.search_outlined),
                      ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.filter_list),
                    ),
                  ],
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(12),
                  sliver: PagedSliverList<int, Shift>(
                    pagingController: pagingController,
                    builderDelegate: PagedChildBuilderDelegate(
                      itemBuilder: (context, shift, index) {
                        return MyShiftCard(shift: shift);
                        // return ListTile(
                        //   contentPadding: const EdgeInsets.symmetric(
                        //     horizontal: 16,
                        //     vertical: 8,
                        //   ),
                        //   //leading: leading,
                        //   title: Text(shift.name),
                        //   subtitle: Column(
                        //     mainAxisSize: MainAxisSize.min,
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Text('Activity ${shift.activity.name}}'),
                        //       Row(
                        //         children: [
                        //           const Icon(
                        //             Icons.calendar_month_outlined,
                        //             size: 16,
                        //           ),
                        //           const SizedBox(width: 4),
                        //           Text(
                        //             'Start at ${shift.startTime.formatDayMonthYearBulletHourSecond()}',
                        //             style: TextStyle(
                        //                 color: context
                        //                     .theme.colorScheme.onSurfaceVariant),
                        //           ),
                        //         ],
                        //       ),
                        //       const SizedBox(height: 4),
                        //       Row(
                        //         children: [
                        //           if (DateTime.now().microsecondsSinceEpoch -
                        //                       shift.startTime
                        //                           .microsecondsSinceEpoch >
                        //                   0 &&
                        //               DateTime.now().microsecondsSinceEpoch -
                        //                       shift.startTime
                        //                           .microsecondsSinceEpoch <
                        //                   1000 * 60 * 60 * 24)
                        //             const Label(
                        //               labelText: 'Starting soon',
                        //               color: Colors.amber,
                        //             ),
                        //           if (volunteerStatus ==
                        //               ShiftVolunteerStatus.approved)
                        //             const Label(labelText: 'Approved'),
                        //           if (volunteerStatus ==
                        //               ShiftVolunteerStatus.pending)
                        //             const Label(
                        //               labelText: 'Waiting for approval',
                        //               color: Colors.grey,
                        //             ),
                        //           if (shift.status == ShiftStatus.completed &&
                        //               volunteer.completion > 0)
                        //             const Label(
                        //               labelText: 'Reviewed',
                        //               color: Colors.green,
                        //             ),
                        //         ].sizedBoxSpacing(const SizedBox(
                        //           width: 4,
                        //         )),
                        //       ),
                        //     ],
                        //   ),
                        //   trailing: IconButton(
                        //     icon: const Icon(Icons.more_vert_outlined),
                        //     onPressed: () {
                        //       showModalBottomSheet(
                        //         showDragHandle: true,
                        //         context: context,
                        //         builder: (context) => ShiftVolunteerBottomSheet(
                        //           volunteer: volunteer,
                        //           shift: shift,
                        //         ),
                        //       );
                        //     },
                        //   ),
                        //   onTap: () {
                        //     showModalBottomSheet(
                        //       showDragHandle: true,
                        //       context: context,
                        //       builder: (context) => ShiftVolunteerBottomSheet(
                        //         volunteer: volunteer,
                        //         shift: shift,
                        //       ),
                        //     );
                        //   },
                        // );
                      },
                      noItemsFoundIndicatorBuilder: (context) => Center(
                        child: NoDataFound(
                          contentTitle: tabElements[tabIndex].noDataTitle,
                          contentSubtitle: tabElements[tabIndex].noDataSubtitle,
                        ),
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
