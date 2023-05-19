import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/screens/error_screen.dart';
import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';
import 'package:the_helper/src/features/authentication/application/auth_service.dart';
import 'package:the_helper/src/features/change_role/domain/user_role.dart';
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
            Padding(
                padding: EdgeInsets.only(
                  top: context.mediaQuery.size.height * 0.1,
                  bottom: 32,
                ),
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
            const Expanded(child: RoleChoice()),
            Padding(
                padding: EdgeInsets.only(
                  bottom: context.mediaQuery.size.height * 0.1,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not sure what to do?',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'See here',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                )),
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
    final roles = ref.watch(authServiceProvider).valueOrNull!.account.roles;
    final currentOrganization = ref.watch(currentOrganizationProvider);
    final currentRole = ref.watch(setRoleControllerProvider);

    ref.listen<AsyncValue>(
      setRoleControllerProvider,
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
              fit: BoxFit.fitWidth,
            ),
          ),

          //Second Option
          roles.contains(Role.moderator)
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
                    if (organization == null) {
                      await showDialog(
                        context: context,
                        builder: (context) => const SwitchOrganizationDialog(),
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
          roles.contains(Role.admin)
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
      ),
    );
  }
}
