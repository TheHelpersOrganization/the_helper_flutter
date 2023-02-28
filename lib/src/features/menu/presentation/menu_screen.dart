import 'package:flutter/material.dart';
import 'package:simple_auth_flutter_riverpod/src/common/widget/drawer/app_drawer.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu')),
      drawer: const AppDrawer(),
    );
  }
}
