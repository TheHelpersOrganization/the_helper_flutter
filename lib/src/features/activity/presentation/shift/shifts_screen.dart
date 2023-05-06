import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';

import 'shifts_widget.dart';

class ShiftsScreen extends ConsumerWidget {
  final int activityId;
  const ShiftsScreen({
    required this.activityId,
    super.key,
  });

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
                title: Text('Shifts Activity $activityId'),
                centerTitle: true,
              ),
            ),
          ];
        },
        // Todo: replace body
        body: ShiftsWidget(activityId: activityId),
      ),
    );
  }
}
