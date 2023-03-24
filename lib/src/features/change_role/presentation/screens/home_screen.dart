import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

//Widgets
import 'package:simple_auth_flutter_riverpod/src/common/widget/drawer/app_drawer.dart';
import 'package:simple_auth_flutter_riverpod/src/features/change_role/presentation/controllers/home_screen_controller.dart';
import 'package:simple_auth_flutter_riverpod/src/common/widget/bottom_navigation_bar/bottom_navigator.dart';
import 'package:simple_auth_flutter_riverpod/src/features/change_role/presentation/screens/change_role_screen.dart';

//Screens
import 'package:simple_auth_flutter_riverpod/src/features/change_role/presentation/screens/volunteer_home_screen.dart';
import 'package:simple_auth_flutter_riverpod/src/features/change_role/presentation/screens/mod_home_screen.dart';
import 'package:simple_auth_flutter_riverpod/src/features/change_role/presentation/screens/admin_home_screen.dart';

class HomeScreen extends ConsumerWidget {
  // final String? role;
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRole = ref.watch(homeScreenControllerProvider);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        title: const Text('Homepage', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none_outlined)),
        ],
      ),
      drawer: const AppDrawer(),
      body: getHomeScreen(userRole.role),
      //body: const VolunteerView(),
      //bottomNavigationBar: const CustomBottomNavigator(),
    );
  }
}

Widget getHomeScreen(int role) {
  switch (role) {
    case 1:
      return const VolunteerView();
    case 2:
      return const ModView();
    case 3:
      return const AdminView();
    default:
      return const VolunteerView();
  }
}
