import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Widgets
import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';
import 'package:the_helper/src/features/change_role/presentation/controllers/home_screen_controller.dart';

//Screens
import 'package:the_helper/src/features/menu/presentation/screens/volunteer_menu_screen.dart';
import 'package:the_helper/src/features/menu/presentation/screens/mod_menu_screen.dart';
import 'package:the_helper/src/features/menu/presentation/screens/admin_menu_screen.dart';

class MenuScreen extends ConsumerWidget {
  // final String? role;
  const MenuScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRole = ref.watch(homeScreenControllerProvider);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        title: const Text('Menu', style: TextStyle(color: Colors.black)),
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
          ? const VolunteerMenu()
          : (userRole.role == 1 ? const ModMenu() : const AdminMenu()),
    );
  }
}
