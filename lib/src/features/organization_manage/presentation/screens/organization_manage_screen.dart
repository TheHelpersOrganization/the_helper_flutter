import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

//Widgets
import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';
import 'package:the_helper/src/features/organization_manage/presentation/widgets/custom_list.dart';

//Screens
import 'package:the_helper/src/features/organization_manage/domain/organization_model.dart';

const List<Tab> tabs = <Tab>[
  Tab(text: 'Active'),
  Tab(text: 'Pending'),
];

class OrganizationManageScreen extends ConsumerWidget {
  // final String? role;
  const OrganizationManageScreen({
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
          title: const Text('Organization Management',
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
            CustomScrollList(status: 0),
            CustomScrollList(status: 1),
          ],
        ),
      ),
    );
  }
}
