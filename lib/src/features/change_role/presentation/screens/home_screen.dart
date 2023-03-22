import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Widgets
import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';
import 'package:the_helper/src/features/change_role/presentation/controllers/home_screen_controller.dart';
import 'package:the_helper/src/common/widget/bottom_navigation_bar/bottom_navigator.dart';

//Screens
import 'package:the_helper/src/features/change_role/presentation/screens/volunteer_home_screen.dart';
import 'package:the_helper/src/features/change_role/presentation/screens/mod_home_screen.dart';
import 'package:the_helper/src/features/change_role/presentation/screens/admin_home_screen.dart';

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
      body: (userRole.role == 0)
          ? const VolunteerView()
          : (userRole.role == 1 ? const ModView() : const AdminView()),
      //body: const VolunteerView(),
      //bottomNavigationBar: const CustomBottomNavigator(),
    );
  }
}
