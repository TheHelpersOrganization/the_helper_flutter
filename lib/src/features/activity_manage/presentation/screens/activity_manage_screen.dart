import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

//Widgets
import 'package:the_helper/src/features/activity_manage/presentation/widgets/activity_list.dart';

//Screens

const List<Tab> tabs = <Tab>[
  Tab(text: 'Ongoing'),
  Tab(text: 'Pendding'),
  Tab(text: 'Done'),
  Tab(text: 'Reject'),
];

class ActivityManageScreen extends ConsumerWidget {
  // final String? role;
  const ActivityManageScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          title: const Text('Activity Management',
              style: TextStyle(color: Colors.black)),
          centerTitle: true,
          elevation: 0.0,
          leading: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back)),
          bottom: TabBar(
            padding: const EdgeInsets.all(10),
            labelColor: Theme.of(context).colorScheme.onSurface,
            tabs: tabs,
            isScrollable: true,
          ),
        ),
        body: const TabBarView(
          
          children: [
            CustomScrollList(status: 0),
            CustomScrollList(status: 1),
            CustomScrollList(status: 2),
            CustomScrollList(status: 3),
          ],
        ),
      ),

      
    );
  }
}