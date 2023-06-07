import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:the_helper/src/common/screens/error_screen.dart';
import 'package:the_helper/src/common/widget/app_bar/custom_sliver_app_bar.dart';
import 'package:the_helper/src/common/widget/custom_sliver_scroll_view.dart';
import 'package:the_helper/src/common/widget/no_data_found.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/activity/domain/activity_status.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_list_management/controller/mod_activity_list_management_controller.dart';
import 'package:the_helper/src/features/activity/presentation/search/widget/activity_card/activity_card.dart';
import 'package:the_helper/src/router/router.dart';

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
    noDataTitle: 'No organization found',
    noDataSubtitle: 'Look like you haven\'t joined any organization yet',
  ),
  TabElement(
    status: ActivityStatus.pending,
    tabTitle: 'Pending',
    noDataTitle: 'No pending join request',
  ),
  TabElement(
    status: ActivityStatus.completed,
    tabTitle: 'Completed',
    noDataTitle: 'No rejected join request',
  ),
  TabElement(
    status: ActivityStatus.cancelled,
    tabTitle: 'Cancelled',
    noDataTitle: 'No rejected join request',
  ),
];

class ModActivityListManagementScreen extends ConsumerStatefulWidget {
  const ModActivityListManagementScreen({super.key});

  @override
  ConsumerState<ModActivityListManagementScreen> createState() =>
      _ModActivityListManagementScreenState();
}

class _ModActivityListManagementScreenState
    extends ConsumerState<ModActivityListManagementScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(() {
      final index = _tabController.index;
      ref.read(currentStatusProvider.notifier).state = tabs[index].status;
      ref.read(hasChangedStatusProvider.notifier).state = true;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pagingController = ref.watch(pagingControllerProvider);

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            ref
                .read(routerProvider)
                .goNamed(AppRoute.organizationActivityCreation.name);
          },
          icon: const Icon(Icons.add),
          label: const Text('Activity'),
        ),
        body: CustomSliverScrollView(
          appBar: CustomSliverAppBar(
            titleText: 'Activity Management',
            showBackButton: true,
            onBackFallback: () => context.goNamed(AppRoute.home.name),
            bottom: TabBar(
              isScrollable: true,
              tabs: tabs.map((e) => Tab(text: e.tabTitle)).toList(),
            ),
          ),
          body: pagingController.when(
            data: (pc) => Padding(
              padding: const EdgeInsets.all(12),
              child: PagedListView<int, Activity>(
                pagingController: pc,
                builderDelegate: PagedChildBuilderDelegate(
                  itemBuilder: (context, item, index) {
                    return ActivityCard(
                      activity: item,
                      onTap: () => context.goNamed(
                        AppRoute.organizationActivityManagement.name,
                        pathParameters: {
                          'activityId': item.id.toString(),
                        },
                      ),
                    );
                  },
                  noItemsFoundIndicatorBuilder: (context) => Center(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 32,
                        ),
                        NoDataFound(
                          contentTitle: tabs[_tabController.index].noDataTitle,
                          contentSubtitle:
                              tabs[_tabController.index].noDataSubtitle,
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
            error: (_, __) => const ErrorScreen(),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }
}
