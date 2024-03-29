import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/screens/error_screen.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/widget/activity_overview_view.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/widget/activity_thumbnail.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/widget/activity_title.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_management/controller/mod_activity_management_controller.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_management/widget/delete_activity_dialog.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_management/widget/mod_activity_shift_management_screen.dart';
import 'package:the_helper/src/features/organization/domain/organization_member_role.dart';
import 'package:the_helper/src/features/organization_member/domain/organization_member.dart';
import 'package:the_helper/src/features/profile/domain/profile.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift/controller/shift_controller.dart';
import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/utils/async_value_ui.dart';

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
    final activityId = widget.activityId;
    final tab = ref.watch(currentTabProvider);
    final extendedActivity =
        ref.watch(getActivityAndShiftsProvider(widget.activityId));
    final myMember = ref.watch(myMemberProvider).valueOrNull;
    final canManageActivity = myMember?.hasRole(
                OrganizationMemberRoleType.organizationActivityManager) ==
            true ||
        extendedActivity.valueOrNull?.activity.activityManagerIds
                ?.contains(myMember?.accountId) ==
            true;

    ref.listen<AsyncValue>(
      deleteShiftControllerProvider,
      (_, state) {
        state.showSnackbarOnError(context);
      },
    );

    ref.listen<AsyncValue>(
      deleteActivityControllerProvider,
      (_, state) {
        state.showSnackbarOnError(context);
      },
    );

    return Scaffold(
      // drawer: const AppDrawer(),
      floatingActionButton: extendedActivity.maybeWhen(
        data: (data) => tab == TabType.overview || !canManageActivity
            ? null
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
      body: extendedActivity.when(
        skipLoadingOnRefresh: false,
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
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.goNamed(
                          AppRoute.organizationActivityListManagement.name);
                    }
                  },
                ),
                floating: true,
                actions: canManageActivity
                    ? [
                        PopupMenuButton(
                          tooltip: 'Edit activity content',
                          position: PopupMenuPosition.under,
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                value: 'edit',
                                child: const Text('Edit basic info'),
                                onTap: () => context.pushNamed(
                                  AppRoute.activityEdit.name,
                                  pathParameters: {
                                    'activityId': activityId.toString()
                                  },
                                ),
                              ),
                              PopupMenuItem(
                                value: 'edit',
                                child: const Text('Edit location'),
                                onTap: () => context.pushNamed(
                                  AppRoute.activityEditLocation.name,
                                  pathParameters: {
                                    'activityId': activityId.toString()
                                  },
                                ),
                              ),
                              PopupMenuItem(
                                value: 'edit',
                                child: const Text('Edit contacts'),
                                onTap: () => context.pushNamed(
                                  AppRoute.activityEditContact.name,
                                  pathParameters: {
                                    'activityId': activityId.toString()
                                  },
                                ),
                              ),
                              PopupMenuItem(
                                value: 'edit',
                                child: const Text('Edit managers'),
                                onTap: () => context.pushNamed(
                                  AppRoute.activityEditManager.name,
                                  pathParameters: {
                                    'activityId': activityId.toString()
                                  },
                                ),
                              ),
                            ];
                          },
                          icon: const Icon(Icons.edit_outlined),
                        ),
                        IconButton(
                          tooltip: 'Delete activity',
                          onPressed: () {
                            showDialog(
                              context: context,
                              useRootNavigator: false,
                              builder: (context) => DeleteActivityDialog(
                                activityId: activityId,
                              ),
                            );
                          },
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ]
                    : null,
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
                        Tab(text: 'Shifts'),
                        Tab(text: 'Overview'),
                      ],
                      indicatorSize: TabBarIndicatorSize.tab,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    getTabAt(
                      tab,
                      data.activity,
                      data.shifts,
                      data.managerProfiles,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget getTabAt(
    TabType tabType,
    Activity activity,
    List<Shift> shifts,
    List<Profile> managerProfiles,
  ) {
    switch (tabType) {
      case TabType.overview:
        return ActivityOverviewView(
          activity: activity,
          hasShift: shifts.isNotEmpty,
          managerProfiles: managerProfiles,
        );
      case TabType.shift:
        return ModActivityShiftManagementView(
          shifts: shifts,
        );
    }
  }
}
