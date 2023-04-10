import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/screens/error_screen.dart';
import 'package:the_helper/src/features/change_role/presentation/controllers/change_role_screen_controller.dart';
import 'package:the_helper/src/features/change_role/presentation/controllers/home_screen_controller.dart';
import 'package:the_helper/src/features/change_role/presentation/widgets/role_option.dart';
import 'package:the_helper/src/features/organization/presentation/switch_organization/switch_organization_controller.dart';
import 'package:the_helper/src/features/organization/presentation/switch_organization/switch_organization_dialog.dart';
import 'package:the_helper/src/router/router.dart';

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

    return currentOrganization.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (_, __) => const ErrorScreen(),
      data: (data) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const RoleOption(
            optionColor: Colors.purple,
            title: 'Volunteer',
            description:
                'Join thousands of activities, by trusted organizations',
            role: 1,
          ),

          //Second Option
          userRole.isMod
              ? RoleOption(
                  optionColor: Colors.red,
                  title: 'Organization',
                  description:
                      'Manage your organization activities, members and more',
                  role: 2,
                  onTap: () async {
                    if (data == null) {
                      await showDialog(
                        context: context,
                        builder: (context) => const SwitchOrganizationDialog(),
                      );
                      return;
                    }
                    ref
                        .read(homeScreenControllerProvider.notifier)
                        .changeRole(2);
                    context.goNamed(AppRoute.home.name);
                  },
                )
              : const SizedBox(),

          //Third Option
          userRole.isAdmin
              ? const RoleOption(
                  optionColor: Colors.blue,
                  title: 'Admin',
                  description: 'Dashboard for Volunteer App Admin',
                  role: 3,
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
