import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/change_role/presentation/widgets/account_ranking_item.dart';
import 'package:the_helper/src/features/change_role/presentation/widgets/activity_ranking_item.dart';
import 'package:the_helper/src/features/change_role/presentation/widgets/admin_data_holder.dart';
import 'package:the_helper/src/features/change_role/presentation/widgets/admin_line_chart.dart';
import 'package:the_helper/src/features/change_role/presentation/widgets/organization_ranking_item.dart';
import 'package:the_helper/src/router/router.dart';

import '../../../../common/screens/error_screen.dart';
import '../../../authentication/application/auth_service.dart';
import '../../../profile/data/profile_repository.dart';
import '../controllers/admin_home_controller.dart';
import '../widgets/admin_data_card.dart';
import '../widgets/home_welcome_section.dart';
import '../widgets/pending_request_data.dart';

class AdminView extends ConsumerWidget {
  const AdminView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = ref.watch(authServiceProvider).value!.account.email;
    final userName = ref.watch(profileProvider);
    final adminData = ref.watch(adminHomeControllerProvider);
    final chartData = ref.watch(chartDataProvider);

    final selectedChartFilter = ref.watch(chartFilterProvider);
    final openRanking = ref.watch(openRankingProvider);
    final segmentValue = ref.watch(segmentValueProvider);

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
                    Row(
                      children: [
                        Expanded(
                          child: HomeWelcomeSection(
                            volunteerName:
                                data.lastName ?? data.username ?? email,
                          ),
                        ),
                        IconButton.filled(
                            isSelected: openRanking,
                            onPressed: () {
                              ref.read(openRankingProvider.notifier).state =
                                  !openRanking;
                            },
                            icon: const Icon(Icons.star_border))
                      ],
                    ),

                    const SizedBox(height: 15),

                    !openRanking
                        ? Column(
                            children: [
                              const Divider(),

                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ChoiceChip(
                                    label: const Text('This year'),
                                    selected: selectedChartFilter == 0,
                                    onSelected: (value) {
                                      ref
                                          .read(chartFilterProvider.notifier)
                                          .state = 0;
                                    },
                                  ),
                                  ChoiceChip(
                                    label: const Text('Last year'),
                                    selected: selectedChartFilter == 1,
                                    onSelected: (value) {
                                      ref
                                          .read(chartFilterProvider.notifier)
                                          .state = 1;
                                    },
                                  ),
                                  ChoiceChip(
                                    label: const Text('All time'),
                                    selected: selectedChartFilter == 2,
                                    onSelected: (value) {
                                      ref
                                          .read(chartFilterProvider.notifier)
                                          .state = 2;
                                    },
                                  )
                                ],
                              ),

                              const SizedBox(
                                height: 15,
                              ),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 5,
                                    width: 20,
                                    color: Colors.blue,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Text('Activity'),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Container(
                                    height: 5,
                                    width: 20,
                                    color: Colors.orange,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Text('Account'),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Container(
                                    height: 5,
                                    width: 20,
                                    color: Colors.redAccent,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Text('Organization'),
                                ],
                              ),

                              const SizedBox(height: 15),
                              // chart data
                              chartData.when(
                                error: (_, __) => const ErrorScreen(),
                                loading: () => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                data: (data) => Container(
                                  height: 300,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: AdminLineChart(
                                    accountData: data.account,
                                    organizationData: data.organization,
                                    activityData: data.activity,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container(
                            color: Theme.of(context).canvasColor,
                            height: 380,
                            child: Column(
                              children: [
                                SegmentedButton(
                                  segments: const [
                                    ButtonSegment(
                                        value: 0, label: Text('Account')),
                                    ButtonSegment(
                                        value: 1, label: Text('Organization')),
                                    ButtonSegment(
                                        value: 2, label: Text('Activity'))
                                  ],
                                  selected: segmentValue,
                                  onSelectionChanged: (p0) {
                                    ref
                                        .read(segmentValueProvider.notifier)
                                        .state = p0;
                                  },
                                ),
                                const SizedBox(height: 15),
                                const Text('Ranking'),
                                const SizedBox(height: 15),
                                const Expanded(child: Column(children: [
                                  AccountRankingItem(),
                                  OrganizationRankingItem(),
                                  ActivityRankingItem()
                                ],))
                              ],
                            ),
                          ),

                    // color line info

                    const SizedBox(
                      height: 15,
                    ),

                    adminData.when(
                      error: (_, __) => const ErrorScreen(),
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
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
                                onTap:() => context.goNamed(AppRoute.accountManage.name),
                              )),
                              const SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                  child: AdminDataCard(
                                data: data.organization,
                                title: 'Total organization',
                                icon: Icons.work,
                                onTap:() => context.goNamed(AppRoute.organizationAdminManage.name),
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
                                onTap:() => context.goNamed(AppRoute.activityManage.name),
                              )),
                              const SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                  child: AdminDataCard(
                                data: data.report,
                                title: 'Pending report',
                                icon: Icons.report_problem,
                                onTap:() => context.goNamed(AppRoute.reportManage.name),
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
                                onTap:() => context.goNamed(AppRoute.accountRequestManage.name),
                              )),
                              const SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                  child: AdminDataCard(
                                data: data.organizationRequest,
                                title: 'Organization request',
                                icon: Icons.assured_workload,
                                onTap:() => context.goNamed(AppRoute.organizationRequestsManage.name),
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
