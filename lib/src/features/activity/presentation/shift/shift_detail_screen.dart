import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';

class ShiftDetailScreen extends ConsumerWidget {
  const ShiftDetailScreen({
    super.key,
    required this.activityId,
    required this.shiftId,
  });
  final int activityId;
  final int shiftId;

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
                title: Text('Shift $shiftId of Activity $activityId'),
                centerTitle: true,
              ),
            ),
          ];
        },
        // Todo: replace body
        body: const Placeholder(),
      ),
    );
  }
}
