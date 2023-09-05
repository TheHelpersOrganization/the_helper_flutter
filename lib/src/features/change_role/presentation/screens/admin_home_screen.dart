import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/features/change_role/presentation/widgets/admin_home/admin_data_holder.dart';

import 'package:the_helper/src/router/router.dart';

import '../../../../common/screens/error_screen.dart';
import '../../../authentication/application/auth_service.dart';
import '../../../profile/data/profile_repository.dart';
import '../controllers/admin_home_controller.dart';

import '../widgets/admin_home/admin_data_card.dart';
import '../widgets/admin_home/admin_linechart_view.dart';
import '../widgets/admin_home/admin_ranking_view.dart';
import '../widgets/home_welcome_section.dart';

class AdminView extends ConsumerStatefulWidget {
  const AdminView({
    super.key,
  });

  @override
  ConsumerState<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends ConsumerState<AdminView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 2, vsync: this, initialIndex: tabIndex);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final email = ref.watch(authServiceProvider).value!.account.email;
    final userName = ref.watch(profileProvider);
    final adminData = ref.watch(adminHomeDataProvider);

    return userName.when(
        error: (_, __) => const ErrorScreen(),
        loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
        data: (data) => SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Column(
                  children: [
                    // Hello section
                    HomeWelcomeSection(
                      volunteerName: data.lastName ?? data.username ?? email,
                    ),

                    const SizedBox(height: 15),

                    SegmentedButton(
                      segments: const [
                        ButtonSegment(value: 0, label: Text('Overview')),
                        ButtonSegment(value: 1, label: Text('Ranking')),
                      ],
                      selected: {tabIndex},
                      onSelectionChanged: (p0) {
                        int newIndex = p0.first;
                        _tabController.animateTo(newIndex);
                        setState(() {
                          tabIndex = newIndex;
                        });
                      },
                    ),

                    const SizedBox(height: 15),
                    const Divider(),

                    SizedBox(
                      height: 480,
                      child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: _tabController,
                        children: const [
                          AdminLineChartView(),
                          AdminRankingView()
                        ],
                      ),
                    ),

                    // color line info

                    const SizedBox(
                      height: 15,
                    ),

                    adminData.when(
                      error: (_, __) => const CustomErrorWidget(),
                      loading: () => Center(
                        child: Column(
                          children: [
                            for (var i = 0; i < 3; i++)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: AdminDataHolder(
                                    itemCount: 2,
                                    itemWidth:
                                        context.mediaQuery.size.width * 0.38,
                                    itemHeight: 80),
                              )
                          ],
                        ),
                      ),
                      data: (data) => Column(
                        children: [
                          Row(
                            children: [
                              Flexible(
                                  child: AdminDataCard(
                                data: data.account,
                                title: 'Total account',
                                icon: Icons.account_circle,
                                onTap: () => context
                                    .goNamed(AppRoute.accountManage.name),
                              )),
                              const SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                  child: AdminDataCard(
                                data: data.organization,
                                title: 'Total organization',
                                icon: Icons.work,
                                onTap: () => context.goNamed(
                                    AppRoute.organizationAdminManage.name),
                              )),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Flexible(
                                  child: AdminDataCard(
                                data: data.activity,
                                title: 'Total activity',
                                icon: Icons.volunteer_activism,
                                onTap: () => context
                                    .goNamed(AppRoute.activityManage.name),
                              )),
                              const SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                  child: AdminDataCard(
                                data: data.report,
                                title: 'Pending report',
                                icon: Icons.report_problem,
                                onTap: () =>
                                    context.goNamed(AppRoute.reportManage.name),
                              )),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Flexible(
                                  child: AdminDataCard(
                                data: data.accountRequest,
                                title: 'Account request',
                                icon: Icons.verified,
                                onTap: () => context.goNamed(
                                    AppRoute.accountRequestManage.name),
                              )),
                              const SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                  child: AdminDataCard(
                                data: data.organizationRequest,
                                title: 'Organization request',
                                icon: Icons.assured_workload,
                                onTap: () => context.goNamed(
                                    AppRoute.organizationRequestsManage.name),
                              )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}
