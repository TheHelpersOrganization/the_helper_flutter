import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:the_helper/src/common/extension/widget.dart';
import 'package:the_helper/src/common/riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import 'package:the_helper/src/common/widget/dialog/confirmation_dialog.dart';
import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';
import 'package:the_helper/src/common/widget/no_data_found.dart';
import 'package:the_helper/src/common/widget/search_bar/debounce_search_bar.dart';
import 'package:the_helper/src/features/organization/domain/organization_member_role.dart';
import 'package:the_helper/src/features/organization/presentation/switch_organization/switch_organization_controller.dart';
import 'package:the_helper/src/features/organization_member/domain/organization_member.dart';
import 'package:the_helper/src/features/organization_member/domain/organization_member_status.dart';
import 'package:the_helper/src/features/organization_member/presentation/member_mangement/widget/joined_member_card.dart';
import 'package:the_helper/src/features/organization_member/presentation/member_mangement/widget/pending_member_card.dart';
import 'package:the_helper/src/features/organization_member/presentation/member_mangement/widget/rejected_member_card.dart';
import 'package:the_helper/src/features/organization_member/presentation/member_mangement/widget/removed_member_card.dart';
import 'package:the_helper/src/utils/async_value_ui.dart';

import '../controller/organization_member_management_controller.dart';

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
    //noDataSubtitle: 'Look like you haven\'t add any member yet',
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
  TabElement(
    status: OrganizationMemberStatus.removed,
    tabTitle: 'Removed',
    noDataTitle: 'No removed member',
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
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showSearch = ref.watch(showSearchProvider);
    final currentStatus = ref.watch(currentStatusProvider);
    final myMember = ref.watch(myMemberProvider).valueOrNull;
    final organization = ref.watch(currentOrganizationProvider).valueOrNull;
    final searchPattern = ref.watch(searchPatternProvider);
    final selectedRoles = ref.watch(selectedRoleProvider);

    ref.listen<AsyncValue>(
      approveMemberControllerProvider,
      (_, state) {
        state.showSnackbarOnError(context);
        if (state.hasValue && !state.isLoading && !state.hasError) {
          ref.invalidate(organizationMemberListPagedNotifierProvider);
        }
      },
    );
    ref.listen<AsyncValue>(
      rejectMemberControllerProvider,
      (_, state) {
        state.showSnackbarOnError(context);
        if (state.hasValue && !state.isLoading && !state.hasError) {
          ref.invalidate(organizationMemberListPagedNotifierProvider);
        }
      },
    );
    ref.listen<AsyncValue>(
      removeMemberControllerProvider,
      (_, state) {
        state.showSnackbarOnError(context);
        if (state.hasValue && !state.isLoading && !state.hasError) {
          ref.invalidate(organizationMemberListPagedNotifierProvider);
        }
      },
    );

    return DefaultTabController(
      length: tab.length,
      child: Scaffold(
        appBar: AppBar(
          leading: showSearch
              ? BackButton(
                  onPressed: () =>
                      ref.read(showSearchProvider.notifier).state = !showSearch,
                )
              : null,
          title: showSearch
              ? DebounceSearchBar(
                  small: true,
                  initialValue: searchPattern,
                  debounceDuration: const Duration(seconds: 1),
                  onDebounce: (value) => ref
                      .read(searchPatternProvider.notifier)
                      .state = value.trim(),
                  onClear: () =>
                      ref.read(searchPatternProvider.notifier).state = '',
                )
              : const Text('Organization Members'),
          actions: [
            if (!showSearch)
              IconButton(
                onPressed: () {
                  ref.read(showSearchProvider.notifier).state = true;
                },
                icon: const Icon(Icons.search_outlined),
              ),
            if (!showSearch && myMember != null)
              IconButton(
                onPressed: () {
                  if (myMember
                      .hasRole(OrganizationMemberRoleType.organizationOwner)) {
                    showDialog(
                      context: context,
                      builder: (context) => const ConfirmationDialog(
                        titleText: 'Leave organization',
                        contentColumnChildren: [
                          Text(
                            'You are currently the owner of this organization',
                          ),
                          Text(
                            'Please transfer the ownership to another member before leaving the organization',
                          ),
                        ],
                        hideConfirmButton: true,
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => ConfirmationDialog(
                        titleText: 'Leave organization',
                        contentColumnChildren: const [
                          Text(
                            'Do you want to leave this organization?',
                          ),
                        ],
                        onConfirm: () async {
                          context.pop();
                          await ref
                              .read(leaveControllerProvider.notifier)
                              .leave(organization!.id!);
                          if (context.mounted) {
                            //context.go(organizationListManagementPath);
                          }
                        },
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.logout_outlined),
              ),
          ],
          bottom: TabBar(
            isScrollable: true,
            controller: _tabController,
            tabs: tab.map((e) => Tab(text: e.tabTitle)).toList(),
          ),
        ),
        drawer: const AppDrawer(),
        body: organization != null && myMember != null
            ? Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (currentStatus == OrganizationMemberStatus.approved) ...[
                      const SizedBox(
                        height: 8,
                      ),
                      const Text(
                        'Quick filter',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 48,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            FilterChip(
                              label: const Text('Owner'),
                              selected: selectedRoles.contains(
                                OrganizationMemberRoleType.organizationOwner,
                              ),
                              onSelected: (value) {
                                final state = selectedRoles;
                                if (value == true) {
                                  state.add(OrganizationMemberRoleType
                                      .organizationOwner);
                                } else {
                                  state.remove(OrganizationMemberRoleType
                                      .organizationOwner);
                                }
                                ref.read(selectedRoleProvider.notifier).state =
                                    {...state};
                              },
                            ),
                            FilterChip(
                              label: const Text('Manager'),
                              selected: selectedRoles.contains(
                                OrganizationMemberRoleType.organizationManager,
                              ),
                              onSelected: (value) {
                                final state = selectedRoles;
                                if (value == true) {
                                  state.add(OrganizationMemberRoleType
                                      .organizationManager);
                                } else {
                                  state.remove(OrganizationMemberRoleType
                                      .organizationManager);
                                }
                                ref.read(selectedRoleProvider.notifier).state =
                                    {...state};
                              },
                            ),
                            FilterChip(
                              label: const Text('Member Manager'),
                              selected: selectedRoles.contains(
                                OrganizationMemberRoleType
                                    .organizationMemberManager,
                              ),
                              onSelected: (value) {
                                final state = selectedRoles;
                                if (value == true) {
                                  state.add(OrganizationMemberRoleType
                                      .organizationMemberManager);
                                } else {
                                  state.remove(OrganizationMemberRoleType
                                      .organizationMemberManager);
                                }
                                ref.read(selectedRoleProvider.notifier).state =
                                    {...state};
                              },
                            ),
                            FilterChip(
                              label: const Text('Activity Manager'),
                              selected: selectedRoles.contains(
                                OrganizationMemberRoleType
                                    .organizationActivityManager,
                              ),
                              onSelected: (value) {
                                final state = selectedRoles;
                                if (value == true) {
                                  state.add(OrganizationMemberRoleType
                                      .organizationActivityManager);
                                } else {
                                  state.remove(OrganizationMemberRoleType
                                      .organizationActivityManager);
                                }
                                ref.read(selectedRoleProvider.notifier).state =
                                    {...state};
                              },
                            ),
                          ].sizedBoxSpacing(const SizedBox(
                            width: 8,
                          )),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                    ],
                    Expanded(
                      child: RiverPagedBuilder<int,
                          OrganizationMember>.autoDispose(
                        firstPageKey: 0,
                        provider: organizationMemberListPagedNotifierProvider(
                            organization),
                        pagedBuilder: (controller, builder) => PagedListView(
                          pagingController: controller,
                          builderDelegate: builder,
                        ),
                        itemBuilder: (context, item, index) {
                          if (currentStatus ==
                              OrganizationMemberStatus.approved) {
                            return JoinedMemberCard(
                              member: item,
                              myMember: myMember,
                            );
                          } else if (currentStatus ==
                              OrganizationMemberStatus.pending) {
                            return PendingMemberCard(
                              member: item,
                              myMember: myMember,
                            );
                          } else if (currentStatus ==
                              OrganizationMemberStatus.rejected) {
                            return RejectedMemberCard(
                              member: item,
                              myMember: myMember,
                            );
                          }
                          return RemovedMemberCard(
                            member: item,
                            myMember: myMember,
                          );
                        },
                        noItemsFoundIndicatorBuilder: (context, controller) =>
                            Center(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 32,
                              ),
                              NoDataFound(
                                contentTitle:
                                    tab[_tabController.index].noDataTitle,
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
                  ],
                ),
              )
            : null,
      ),
    );
  }
}
