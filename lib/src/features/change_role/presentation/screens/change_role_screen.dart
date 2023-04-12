import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/screens/error_screen.dart';
import 'package:the_helper/src/features/change_role/domain/user_role.dart';
import 'package:the_helper/src/features/change_role/presentation/controllers/change_role_screen_controller.dart';
import 'package:the_helper/src/features/change_role/presentation/controllers/role_controller.dart';
import 'package:the_helper/src/features/change_role/presentation/widgets/role_option.dart';
import 'package:the_helper/src/features/organization/presentation/switch_organization/switch_organization_controller.dart';
import 'package:the_helper/src/features/organization/presentation/switch_organization/switch_organization_dialog.dart';
import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/utils/async_value_ui.dart';

class ChangeRoleScreen extends ConsumerWidget {
  const ChangeRoleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
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
                  )),
            ),
            const RoleChoice(),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not sure what to do?',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'See here',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.lightBlue),
                        ),
                      ),
                    ],
                  )),
            ),
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
    final userRole = ref.watch(changeRoleScreenControllerProvider);
    final currentOrganization = ref.watch(currentOrganizationProvider);
    final currentRole = ref.watch(roleControllerProvider);

    ref.listen<AsyncValue>(
      roleControllerProvider,
      (_, state) => state.showSnackbarOnError(context),
    );
    ref.listen<AsyncValue>(
      currentOrganizationProvider,
      (_, state) => state.showSnackbarOnError(context),
    );

    if (currentOrganization.isLoading || currentRole.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (currentOrganization.hasError || currentRole.hasError) {
      return const ErrorScreen();
    }

    final organization = currentOrganization.value;

    return currentRole.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (_, __) => const ErrorScreen(),
      data: (data) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RoleOption(
            optionColor: Colors.purple,
            title: 'Volunteer',
            description:
                'Join thousands of activities, by trusted organizations',
            role: Role.volunteer,
            image: SvgPicture.asset(
              'assets/images/role_volunteer.svg',
              fit: BoxFit.cover,
            ),
          ),

          //Second Option
          userRole.isMod
              ? RoleOption(
                  optionColor: Colors.red,
                  title: 'Organization',
                  description:
                      'Manage your organization activities, members and more',
                  role: Role.moderator,
                  image: SvgPicture.asset(
                    'assets/images/role_mod.svg',
                    fit: BoxFit.cover,
                  ),
                  onTap: () async {
                    if (data == null) {
                      await showDialog(
                        context: context,
                        builder: (context) => const SwitchOrganizationDialog(),
                      );
                      return;
                    }
                    ref
                        .read(roleControllerProvider.notifier)
                        .setCurrentRole(Role.moderator);
                    context.goNamed(AppRoute.home.name);
                  },
                )
              : const SizedBox(),

          //Third Option
          userRole.isAdmin
              ? RoleOption(
                  optionColor: Colors.blue,
                  title: 'Admin',
                  description: 'Dashboard for Volunteer App Admin',
                  role: Role.admin,
                  image: SvgPicture.asset(
                    'assets/images/role_admin.svg',
                    fit: BoxFit.cover,
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
