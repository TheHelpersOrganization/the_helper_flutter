import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/features/activity/domain/activity_status.dart';
import 'package:the_helper/src/router/router.dart';

class TabElement {
  final ActivityStatus status;
  final String tabTitle;
  final String? noDataTitle;
  final String? noDataSubtitle;

  const TabElement({
    required this.status,
    required this.tabTitle,
    this.noDataTitle,
    this.noDataSubtitle,
  });
}

const List<TabElement> tabs = [
  TabElement(
    status: ActivityStatus.ongoing,
    tabTitle: 'Ongoing',
    noDataTitle: 'No organization found',
    noDataSubtitle: 'Look like you haven\'t joined any organization yet',
  ),
  TabElement(
    status: ActivityStatus.pending,
    tabTitle: 'Pending',
    noDataTitle: 'No pending join request',
  ),
  TabElement(
    status: ActivityStatus.completed,
    tabTitle: 'Completed',
    noDataTitle: 'No rejected join request',
  ),
  TabElement(
    status: ActivityStatus.cancelled,
    tabTitle: 'Cancelled',
    noDataTitle: 'No rejected join request',
  ),
];

class ActivityModManagementScreen extends ConsumerWidget {
  const ActivityModManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Activity Management'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.goNamed(AppRoute.home.name);
              }
            },
          ),
          bottom: TabBar(
            isScrollable: true,
            tabs: tabs.map((e) => Tab(text: e.tabTitle)).toList(),
          ),
        ),
      ),
    );
  }
}
