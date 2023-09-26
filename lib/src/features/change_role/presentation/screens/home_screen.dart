import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/screens/error_screen.dart';
import 'package:the_helper/src/common/widget/app_bar/custom_sliver_app_bar.dart';
import 'package:the_helper/src/common/widget/custom_sliver_scroll_view.dart';
//Widgets
import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';
import 'package:the_helper/src/common/widget/label.dart';
import 'package:the_helper/src/features/change_role/application/role_service.dart';
import 'package:the_helper/src/features/change_role/domain/user_role.dart';
import 'package:the_helper/src/features/change_role/presentation/screens/admin_home_screen.dart';
import 'package:the_helper/src/features/change_role/presentation/screens/mod_home_screen.dart';
//Screens
import 'package:the_helper/src/features/change_role/presentation/screens/volunteer_home_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(roleServiceProvider);

    return Scaffold(
      drawer: const AppDrawer(),
      body: role.when(
          loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
          error: (_, __) => const ErrorScreen(),
          data: (role) {
            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                CustomSliverAppBar(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Home'),
                      const SizedBox(width: 12),
                      if (role == Role.admin)
                        Label(
                          labelText: 'Admin',
                          color: context.theme.primaryColor,
                        ),
                      if (role == Role.moderator)
                        const Label(
                          labelText: 'Moderator',
                          color: Colors.orange,
                        ),
                      if (role == Role.volunteer)
                        const Label(
                          labelText: 'Volunteer',
                          color: Colors.purple,
                        ),
                    ],
                  ),
                  showQRButton: role == Role.volunteer,
                ),
              ],
              body: getHomeScreen(role),
            );
          }),
    );

    return role.when(
        loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
        error: (_, __) => const ErrorScreen(),
        data: (role) {
          return Scaffold(
            drawer: const AppDrawer(),
            body: CustomSliverScrollView(
              appBar: CustomSliverAppBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Home'),
                    const SizedBox(width: 12),
                    if (role == Role.admin)
                      Label(
                        labelText: 'Admin',
                        color: context.theme.primaryColor,
                      ),
                    if (role == Role.moderator)
                      const Label(
                        labelText: 'Moderator',
                        color: Colors.orange,
                      ),
                    if (role == Role.volunteer)
                      const Label(
                        labelText: 'Volunteer',
                        color: Colors.purple,
                      ),
                  ],
                ),
                showQRButton: role == Role.volunteer,
              ),
              body: getHomeScreen(role),
            ),
            //body: const VolunteerView(),
            //bottomNavigationBar: const CustomBottomNavigator(),
          );
        });
  }
}

Widget getHomeScreen(Role role) {
  switch (role) {
    case Role.volunteer:
      return const VolunteerView();
    case Role.moderator:
      return const ModView();
    case Role.admin:
      return const AdminView();
    default:
      return const VolunteerView();
  }
}
