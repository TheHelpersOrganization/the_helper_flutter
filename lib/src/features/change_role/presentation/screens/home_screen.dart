import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/screens/error_screen.dart';
//Widgets
import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';
import 'package:the_helper/src/features/change_role/domain/user_role.dart';
import 'package:the_helper/src/features/change_role/presentation/controllers/role_controller.dart';
import 'package:the_helper/src/features/change_role/presentation/screens/admin_home_screen.dart';
import 'package:the_helper/src/features/change_role/presentation/screens/mod_home_screen.dart';
//Screens
import 'package:the_helper/src/features/change_role/presentation/screens/volunteer_home_screen.dart';

class HomeScreen extends ConsumerWidget {
  // final String? role;
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(roleControllerProvider);

    return role.when(
        loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
        error: (_, __) => const ErrorScreen(),
        data: (role) => Scaffold(
              appBar: AppBar(
                iconTheme: const IconThemeData(color: Colors.black),
                backgroundColor: Colors.transparent,
                title: const Text('Homepage',
                    style: TextStyle(color: Colors.black)),
                centerTitle: true,
                elevation: 0.0,
                actions: <Widget>[
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.notifications_none_outlined)),
                ],
              ),
              drawer: const AppDrawer(),
              body: getHomeScreen(role ?? Role.volunteer),
              //body: const VolunteerView(),
              //bottomNavigationBar: const CustomBottomNavigator(),
            ));
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
