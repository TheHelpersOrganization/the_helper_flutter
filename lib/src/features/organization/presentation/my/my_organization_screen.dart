import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:the_helper/src/common/widget/no_data_found.dart';
import 'package:the_helper/src/features/organization/presentation/my/my_organization_controller.dart';
import 'package:the_helper/src/features/organization/presentation/my/rejected_org_card.dart';
import 'package:the_helper/src/utils/async_value_ui.dart';

import '../../../../common/widget/drawer/app_drawer.dart';
import '../../../organization_member/domain/organization_member_status.dart';
import '../../domain/organization.dart';
import 'org_card.dart';
import 'pending_org_card.dart';

class MyOrganizationScreen extends ConsumerStatefulWidget {
  const MyOrganizationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MyOrganizationScreen> createState() =>
      _MyOrganizationScreenState();
}

class TabElement {
  final OrganizationMemberStatus status;
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

const List<TabElement> tab = [
  TabElement(
    status: OrganizationMemberStatus.approved,
    tabTitle: 'Joined',
    noDataTitle: 'No organization found',
    noDataSubtitle: 'Look like you haven\'t joined any organization yet',
  ),
  TabElement(
    status: OrganizationMemberStatus.pending,
    tabTitle: 'Pending',
    noDataTitle: 'No pending join request',
  ),
  TabElement(
    status: OrganizationMemberStatus.rejected,
    tabTitle: 'Rejected',
    noDataTitle: 'No rejected join request',
  ),
];

class _MyOrganizationScreenState extends ConsumerState<MyOrganizationScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tab.length, vsync: this);
    _tabController.addListener(() {
      final index = _tabController.index;
      ref.read(currentStatusProvider.notifier).state = tab[index].status;
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
    final pagingController = ref.watch(myPagingControllerProvider);
    final currentStatus = ref.watch(currentStatusProvider);
    ref.listen<AsyncValue>(
      cancelJoinControllerProvider,
      (_, state) {
        state.showSnackbarOnError(context);
        if (state.hasValue && !state.isLoading && !state.hasError) {
          pagingController.refresh();
        }
      },
    );

    return DefaultTabController(
      length: tab.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Organizations'),
          centerTitle: true,
          // actions: [
          //   IconButton(
          //     onPressed: () => context.pushNamed(
          //       AppRoute.organizationRegistration.name
          //     ), 
          //     icon: const Icon(Icons.group_add)
          //   )
          // ],
          bottom: TabBar(
            controller: _tabController,
            tabs: tab.map((e) => Tab(text: e.tabTitle)).toList(),
          ),
        ),
        drawer: const AppDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Expanded(
                child: PagedListView<int, Organization>(
                  pagingController: pagingController,
                  builderDelegate: PagedChildBuilderDelegate(
                    itemBuilder: (context, item, index) {
                      if (currentStatus == OrganizationMemberStatus.pending) {
                        return PendingOrgCard(organization: item);
                      } else if (currentStatus ==
                          OrganizationMemberStatus.rejected) {
                        return RejectedOrgCard(
                          organization: item,
                        );
                      } else {
                        return OrgCard(organization: item);
                      }
                    },
                    noItemsFoundIndicatorBuilder: (context) => Center(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 32,
                          ),
                          NoDataFound(
                            contentTitle: tab[_tabController.index].noDataTitle,
                            contentSubtitle:
                                tab[_tabController.index].noDataSubtitle,
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
            ],
          ),
        ),
      ),
    );
  }
}
