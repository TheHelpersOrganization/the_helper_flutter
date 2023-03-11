import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:simple_auth_flutter_riverpod/src/features/change_role/data/role_repository.dart';
import 'package:simple_auth_flutter_riverpod/src/features/change_role/presentation/controllers/change_role_screen_controller.dart';

import 'package:simple_auth_flutter_riverpod/src/features/change_role/presentation/widgets/role_option.dart';

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const RoleOption(
          optionColor: Colors.purple,
          title: 'Volunteer',
          description: 'Join thousands of activities, by trusted organizations',
          role: 0,
        ),

        //Second Option
        userRole.isMod
        ? const RoleOption(
          optionColor: Colors.red,
          title: 'Organization',
          description: 'Manage your organization activites, members and more',
          role: 1,
        )
        : const SizedBox(),

        //Third Option
        userRole.isAdmin
        ? const RoleOption(
          optionColor: Colors.blue,
          title: 'Admin',
          description: 'Dashboard for Volunteer App Admin',
          role: 2,
        )
        : const SizedBox(),
      ],
    );
  }
}
