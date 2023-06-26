import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Widgets
import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';
import 'package:the_helper/src/features/organization/presentation/admin_manage/controllers/organization_manage_screen_controller.dart';
import 'package:the_helper/src/features/organization/presentation/admin_manage/widgets/custom_list.dart';

//Screens

const List<Tab> tabs = <Tab>[
  Tab(text: 'Active'),
  Tab(text: 'Banned'),
];

class OrganizationAdminManageScreen extends ConsumerWidget {
  // final String? role;
  const OrganizationAdminManageScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: tabs.length,
      child: Builder(builder: (BuildContext context) {
        final TabController tabController = DefaultTabController.of(context);
        tabController.addListener(() {
          if (tabController.indexIsChanging) {
            ref.read(tabStatusProvider.notifier).state = tabController.index;
          }
        });
        return Scaffold(
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
          body: TabBarView(
            children: tabs.map((tab) {
              return const CustomScrollList();
            }).toList(),
          ),
        );
      }),
    );
  }
}
