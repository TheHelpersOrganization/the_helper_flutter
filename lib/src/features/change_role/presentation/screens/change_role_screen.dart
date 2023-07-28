import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/features/change_role/domain/user_role.dart';
import 'package:the_helper/src/features/change_role/presentation/controllers/change_role_controller.dart';
import 'package:the_helper/src/features/change_role/presentation/controllers/role_controller.dart';
import 'package:the_helper/src/features/change_role/presentation/widgets/role_option.dart';
import 'package:the_helper/src/features/organization/presentation/switch_organization/switch_organization_dialog.dart';
import 'package:the_helper/src/router/router.dart';

class ChangeRoleScreen extends ConsumerWidget {
  const ChangeRoleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.goNamed(AppRoute.home.name);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      drawer: const AppDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Choose your role',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'Don\'t worry. You can change it later',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const Expanded(child: RoleChoice()),
            // Padding(
            //     padding: EdgeInsets.only(
            //       bottom: context.mediaQuery.size.height * 0.1,
            //     ),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Text(
            //           'Not sure what to do?',
            //           style: Theme.of(context).textTheme.bodyMedium,
            //         ),
            //         TextButton(
            //           onPressed: () {},
            //           child: const Text(
            //             'See here',
            //             style: TextStyle(color: Colors.blue),
            //           ),
            //         ),
            //       ],
            //     )),
          ],
        ),
      ),
    );
  }
}

class RoleChoice extends ConsumerWidget {
  const RoleChoice({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final changeRoleDataState = ref.watch(changeRoleDataProvider);

    return changeRoleDataState.when(
      skipLoadingOnRefresh: false,
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (_, __) => CustomErrorWidget(
        onRetry: () => ref.invalidate(changeRoleDataProvider),
      ),
      data: (data) {
        final roles = data.roles;
        final currentRole = data.currentRole;
        final joinedOrganizations = data.joinedOrganizations;
        final currentOrganization = data.currentOrganization;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            currentRole != Role.volunteer
                ? RoleOption(
                    optionColor: Colors.purple,
                    title: 'Volunteer',
                    description:
                        'Join thousands of activities, by trusted organizations',
                    role: Role.volunteer,
                    image: SvgPicture.asset(
                      'assets/images/role_volunteer.svg',
                      fit: BoxFit.fitWidth,
                    ),
                  )
                : const SizedBox(),

            //Second Option
            joinedOrganizations.isNotEmpty && currentRole != Role.moderator
                ? RoleOption(
                    optionColor: Colors.red,
                    title: 'Organization',
                    description:
                        'Manage your organization activities, members and more',
                    role: Role.moderator,
                    image: SvgPicture.asset(
                      'assets/images/role_mod.svg',
                      fit: BoxFit.fitWidth,
                    ),
                    onTap: () async {
                      if (currentOrganization == null) {
                        await showDialog(
                          context: context,
                          useRootNavigator: false,
                          builder: (context) =>
                              const SwitchOrganizationDialog(),
                        );
                        return;
                      }
                      ref
                          .read(setRoleControllerProvider.notifier)
                          .setCurrentRole(Role.moderator, navigateToHome: true);
                      context.goNamed(AppRoute.home.name);
                    },
                  )
                : const SizedBox(),

            //Third Option
            roles.contains(Role.admin) && currentRole != Role.admin
                ? RoleOption(
                    optionColor: Colors.blue,
                    title: 'Admin',
                    description: 'Dashboard for Volunteer App Admin',
                    role: Role.admin,
                    image: SvgPicture.asset(
                      'assets/images/role_admin.svg',
                      fit: BoxFit.fitWidth,
                    ),
                  )
                : const SizedBox(),
          ],
        );
      },
    );
  }
}
