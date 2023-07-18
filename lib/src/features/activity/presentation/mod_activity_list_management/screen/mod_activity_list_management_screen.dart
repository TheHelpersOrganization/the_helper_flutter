import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:the_helper/src/common/screens/error_screen.dart';
import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';
import 'package:the_helper/src/common/widget/no_data_found.dart';
import 'package:the_helper/src/common/widget/search_bar/debounce_search_bar.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/activity/domain/activity_status.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_list_management/controller/mod_activity_list_management_controller.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_list_management/widget/activity_card.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_management/controller/mod_activity_management_controller.dart';
import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/utils/async_value_ui.dart';

class TabElement {
  final ActivityStatus status;
  final String tabTitle;
  final String? noDataTitle;
  final String? noDataSubtitle;

  const TabElement({
    required this.status,
    required this.tabTitle,
    this.noDataTitle,
    this.noDataSubtitle,
  });
}

const List<TabElement> tabs = [
  TabElement(
    status: ActivityStatus.ongoing,
    tabTitle: 'Ongoing',
    noDataTitle: 'No activity found',
  ),
  TabElement(
    status: ActivityStatus.pending,
    tabTitle: 'Upcoming',
    noDataTitle: 'No upcoming activity found',
  ),
  TabElement(
    status: ActivityStatus.completed,
    tabTitle: 'Completed',
    noDataTitle: 'No completed activity found',
  ),
];

class ModActivityListManagementScreen extends ConsumerWidget {
  const ModActivityListManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSearching = ref.watch(isSearchingProvider);
    final pagingController = ref.watch(pagingControllerProvider);
    final isManager = ref.watch(isManagerProvider);
    final isShiftManager = ref.watch(isShiftManagerProvider);
    final searchPattern = ref.watch(searchPatternProvider);

    ref.listen<AsyncValue>(
      deleteActivityControllerProvider,
      (_, state) {
        state.showSnackbarOnError(context);
        state.showSnackbarOnSuccess(
          context,
          content: const Text('Activity deleted'),
        );
      },
    );

    return DefaultTabController(
      length: tabs.length,
      child: Builder(builder: (context) {
        final tabController = DefaultTabController.of(context);
        final tabIndex = tabController.index;
        tabController.addListener(() {
          if (!tabController.indexIsChanging) {
            ref.read(currentStatusProvider.notifier).state =
                tabs[tabController.index].status;
          }
        });

        return Scaffold(
          drawer: const AppDrawer(),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              ref
                  .read(routerProvider)
                  .pushNamed(AppRoute.organizationActivityCreation.name);
            },
            icon: const Icon(Icons.add),
            label: const Text('Activity'),
          ),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                leading: isSearching
                    ? BackButton(
                        onPressed: () => ref
                            .read(isSearchingProvider.notifier)
                            .state = false,
                      )
                    : null,
                title: isSearching
                    ? DebounceSearchBar(
                        small: true,
                        hintText: 'Enter activity name',
                        initialValue: searchPattern,
                        onDebounce: (value) {
                          ref.read(searchPatternProvider.notifier).state =
                              value;
                        },
                        onClear: () => ref
                            .read(searchPatternProvider.notifier)
                            .state = null,
                        debounceDuration: const Duration(seconds: 1),
                      )
                    : const Text('Activity Management'),
                actions: [
                  if (!isSearching)
                    IconButton(
                      onPressed: () {
                        ref.read(isSearchingProvider.notifier).state =
                            !isSearching;
                      },
                      icon: const Icon(Icons.search_outlined),
                    ),
                  const SizedBox(
                    width: 12,
                  ),
                ],
                bottom: TabBar(
                  tabs: tabs.map((e) => Tab(text: e.tabTitle)).toList(),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Quick filter',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          FilterChip(
                            label: const Text('Activity manager'),
                            onSelected: (value) {
                              ref.read(isManagerProvider.notifier).state =
                                  value;
                            },
                            selected: isManager,
                          ),
                          const SizedBox(width: 12),
                          FilterChip(
                            label: const Text('Shift manager'),
                            onSelected: (value) {
                              ref.read(isShiftManagerProvider.notifier).state =
                                  value;
                            },
                            selected: isShiftManager,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(
                        height: 0,
                      ),
                    ],
                  ),
                ),
              ),
              pagingController.when(
                data: (pc) => SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  sliver: PagedSliverList<int, Activity>(
                    pagingController: pc,
                    builderDelegate: PagedChildBuilderDelegate(
                      itemBuilder: (context, activity, index) {
                        return ActivityCard(activity: activity);
                      },
                      noItemsFoundIndicatorBuilder: (context) => Center(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 32,
                            ),
                            NoDataFound(
                              contentTitle: tabs[tabIndex].noDataTitle,
                              contentSubtitle: tabs[tabIndex].noDataSubtitle,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                error: (_, __) =>
                    const SliverToBoxAdapter(child: ErrorScreen()),
                loading: () => const SliverToBoxAdapter(child: SizedBox()),
              ),
            ],
          ),
        );
      }),
    );
  }
}
