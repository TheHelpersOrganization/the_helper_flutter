import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/change_role/presentation/widgets/admin_data_holder.dart';
import 'package:the_helper/src/features/change_role/presentation/widgets/admin_line_chart.dart';
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
    final requestData = ref.watch(adminRequestProvider);
    final chartData = ref.watch(chartDataProvider);

    return userName.when(
        error: (_, __) => const ErrorScreen(),
        loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
        data: (data) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Column(
                children: [
                  // Hello section
                  HomeWelcomeSection(
                    volunteerName: data.lastName ?? data.username ?? email,
                  ),

                  const SizedBox(height: 15),
                  adminData.when(
                    loading: () => AdminDataHolder(
                      itemCount: 2,
                      itemWidth: context.mediaQuery.size.width * 0.3,
                      itemHeight: 80,
                    ),
                    error: (_, __) => const ErrorScreen(),
                    data: (data) => Row(children: [
                      Expanded(
                        flex: 1,
                        child: AdminDataCard(
                          title: 'Accounts',
                          icon: Icons.account_circle_outlined,
                          data: data.account,
                          onTap: () =>
                              context.goNamed(AppRoute.accountManage.name),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        flex: 1,
                        child: AdminDataCard(
                          title: 'Organization',
                          icon: Icons.work_outline_outlined,
                          data: data.organization,
                          onTap: () =>
                              context.goNamed(AppRoute.organizationAdminManage.name),
                        ),
                      ),
                    ]),
                  ),

                  const SizedBox(height: 15),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        requestData.when(
                          loading: () => AdminDataHolder(
                            itemCount: 2,
                            itemWidth: context.mediaQuery.size.width * 0.3,
                            itemHeight: 100,
                          ),
                          error: (_, __) {
                            return const Center(
                                child: Text(
                              'There\'s a problem while loading data',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ));
                          },
                          data: (data) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 1,
                                child: PenddingRequestData(
                                    name: 'User',
                                    icon: Icons.verified_user,
                                    count: data.account,
                                    height: 100,
                                    width: 100,
                                    onTap: () => context.goNamed(
                                        AppRoute.accountRequestManage.name)),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 1,
                                child: PenddingRequestData(
                                    name: 'Report',
                                    icon: Icons.verified_user,
                                    count: data.report,
                                    height: 100,
                                    width: 100,
                                    onTap: () => context
                                        .goNamed(AppRoute.reportManage.name)),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text('Pending request',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Activities data',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: chartData.when(
                      loading: () => AdminDataHolder(
                        itemCount: 1,
                        itemWidth: context.mediaQuery.size.width * 0.9,
                        itemHeight: 250,
                      ),
                      error: (_, __) => const ErrorScreen(),
                    data: (data) => AdminLineChart(data: data,))
                    ,
                  )),
                ],
              ),
            ));
  }
}
