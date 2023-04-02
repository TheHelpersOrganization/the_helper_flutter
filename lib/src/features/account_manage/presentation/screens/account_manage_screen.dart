import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

//Widgets
import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';
import 'package:the_helper/src/features/account_manage/presentation/widgets/account_list.dart';

//Screens
import 'package:the_helper/src/features/account_manage/domain/account.dart';

const List<Tab> tabs = <Tab>[
  Tab(text: 'Active'),
  Tab(text: 'Banned'),
];

class AccountManageScreen extends ConsumerWidget {
  // final String? role;
  const AccountManageScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          title: const Text('Account Management',
              style: TextStyle(color: Colors.black)),
          centerTitle: true,
          elevation: 0.0,
          bottom: TabBar(
            labelColor: Theme.of(context).colorScheme.onSurface,
            tabs: tabs,
          ),
        ),
        body: const TabBarView(
          children: [
            CustomScrollList(isBanned: false),
            CustomScrollList(isBanned: true),
          ],
        ),
      ),

      
    );
  }
}