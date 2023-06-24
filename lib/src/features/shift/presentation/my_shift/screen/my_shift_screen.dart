import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';
import 'package:the_helper/src/common/widget/no_data_found.dart';
import 'package:the_helper/src/common/widget/search_bar/debounce_search_bar.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/features/shift/domain/shift_volunteer.dart';
import 'package:the_helper/src/features/shift/presentation/my_shift/controller/my_shift_controller.dart';
import 'package:the_helper/src/features/shift/presentation/my_shift/widget/my_shift_card.dart';
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
    noDataTitle: 'No shift found',
  ),
  const TabElement(
    type: TabType.upcoming,
    tabTitle: 'Upcoming',
    noDataTitle: 'No shift found',
  ),
  const TabElement(
    type: TabType.completed,
    tabTitle: 'Completed',
    noDataTitle: 'No shift found',
  ),
];

class MyShiftScreen extends ConsumerWidget {
  const MyShiftScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSearching = ref.watch(isSearchingProvider);
    final searchPattern = ref.watch(searchPatternProvider);
    final pagingController = ref.watch(myActivityPagingControllerProvider);
    final tabType = ref.watch(tabTypeProvider);
    final selectedStatuses = ref.watch(selectedStatusesProvider);

    ref.listen<AsyncValue>(
      cancelShiftRegistrationControllerProvider,
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
                if (tabType == TabType.upcoming)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 12,
                          ),
                          const Row(
                            children: [
                              // const Icon(Icons.auto_awesome_outlined),
                              // const SizedBox(
                              //   width: 8,
                              // ),
                              Text(
                                'Quick filter',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            children: [
                              FilterChip(
                                label: const Text('Approved'),
                                selected: selectedStatuses
                                    .contains(ShiftVolunteerStatus.approved),
                                onSelected: (value) {
                                  if (value) {
                                    ref
                                        .read(selectedStatusesProvider.notifier)
                                        .state = {
                                      ...selectedStatuses
                                        ..add(ShiftVolunteerStatus.approved)
                                    };
                                  } else {
                                    ref
                                        .read(selectedStatusesProvider.notifier)
                                        .state = {
                                      ...selectedStatuses
                                        ..remove(ShiftVolunteerStatus.approved)
                                    };
                                  }
                                },
                              ),
                              FilterChip(
                                label: const Text('Waiting for approval'),
                                selected: selectedStatuses
                                    .contains(ShiftVolunteerStatus.pending),
                                onSelected: (value) {
                                  if (value) {
                                    ref
                                        .read(selectedStatusesProvider.notifier)
                                        .state = {
                                      ...selectedStatuses
                                        ..add(ShiftVolunteerStatus.pending)
                                    };
                                  } else {
                                    ref
                                        .read(selectedStatusesProvider.notifier)
                                        .state = {
                                      ...selectedStatuses
                                        ..remove(ShiftVolunteerStatus.pending)
                                    };
                                  }
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Divider(),
                        ],
                      ),
                    ),
                  ),
                SliverPadding(
                  padding: const EdgeInsets.all(12),
                  sliver: PagedSliverList<int, Shift>(
                    pagingController: pagingController,
                    builderDelegate: PagedChildBuilderDelegate(
                      itemBuilder: (context, shift, index) {
                        return MyShiftCard(shift: shift);
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
