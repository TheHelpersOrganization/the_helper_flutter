import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';

final List<String> tabs = [
  'Shift',
];

class ActivityDetailScreen extends ConsumerWidget {
  const ActivityDetailScreen({super.key, required this.activityId});
  final int activityId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                forceElevated: innerBoxIsScrolled,
                title: Text('Activity $activityId'),
                centerTitle: true,
              ),
            ),
          ];
        },
        // Todo: replace body
        body: const Placeholder(),
      ),
    );
    // return Scaffold(
    //   drawer: const AppDrawer(),
    //   body: NestedScrollView(
    //     headerSliverBuilder: (context, innerBoxIsScrolled) {
    //       return <Widget>[
    //         SliverOverlapAbsorber(
    //           handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
    //           sliver: SliverAppBar(
    //             forceElevated: innerBoxIsScrolled,
    //             title: Text('Activity Detail $activityId'),
    //             centerTitle: true,
    //           ),
    //         ),
    //       ];
    //     },
    //     // Todo: replace body
    //     body: const Placeholder(),
    //   ),
    // );
  }
}
