import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';
import 'package:the_helper/src/common/widget/no_data_found.dart';
import 'package:the_helper/src/features/organization/presentation/switch_organization/switch_organization_controller.dart';
import 'package:the_helper/src/features/organization_member/domain/organization_member.dart';
import 'package:the_helper/src/features/organization_member/domain/organization_member_status.dart';
import 'package:the_helper/src/features/organization_member/presentation/member_mangement/joined_member_card.dart';
import 'package:the_helper/src/features/organization_member/presentation/member_mangement/pending_member_card.dart';
import 'package:the_helper/src/features/organization_member/presentation/member_mangement/rejected_member_card.dart';
import 'package:the_helper/src/utils/async_value_ui.dart';

import 'organization_member_management_controller.dart';

class OrganizationMembersManagementScreen extends ConsumerStatefulWidget {
  const OrganizationMembersManagementScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<OrganizationMembersManagementScreen> createState() =>
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
    tabTitle: 'Members',
    noDataTitle: 'No member found',
    noDataSubtitle: 'Look like you haven\'t add any member yet',
  ),
  TabElement(
    status: OrganizationMemberStatus.pending,
    tabTitle: 'Applicants',
    noDataTitle: 'No pending join request',
  ),
  TabElement(
    status: OrganizationMemberStatus.rejected,
    tabTitle: 'Rejected',
    noDataTitle: 'No rejected join request',
  ),
];

class _MyOrganizationScreenState
    extends ConsumerState<OrganizationMembersManagementScreen>
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
    final pagingController = ref.watch(pagingControllerProvider);
    final currentStatus = ref.watch(currentStatusProvider);
    final currentOrganization = ref.watch(currentOrganizationProvider);

    ref.listen<AsyncValue>(
      approveMemberControllerProvider,
      (_, state) {
        state.showSnackbarOnError(context);
        if (state.hasValue && !state.isLoading && !state.hasError) {
          pagingController.refresh();
        }
      },
    );
    ref.listen<AsyncValue>(
      rejectMemberControllerProvider,
      (_, state) {
        state.showSnackbarOnError(context);
        if (state.hasValue && !state.isLoading && !state.hasError) {
          pagingController.refresh();
        }
      },
    );
    ref.listen<AsyncValue>(
      removeMemberControllerProvider,
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
          title: const Text('Organization Members'),
          centerTitle: true,
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
                child: PagedListView<int, OrganizationMember>(
                  pagingController: pagingController,
                  builderDelegate: PagedChildBuilderDelegate(
                    itemBuilder: (context, item, index) {
                      if (currentStatus == OrganizationMemberStatus.approved) {
                        return JoinedMemberCard(member: item);
                      } else if (currentStatus ==
                          OrganizationMemberStatus.pending) {
                        return PendingMemberCard(member: item);
                      }
                      return RejectedMemberCard(member: item);
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
