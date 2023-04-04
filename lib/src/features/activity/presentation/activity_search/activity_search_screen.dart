import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:the_helper/src/common/widget/drawer/app_drawer.dart';

class ActivitySearchScreen extends ConsumerWidget {
  const ActivitySearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              // Todo: implement search bar for sliver app bar
              sliver: SliverAppBar(
                forceElevated: innerBoxIsScrolled,
                title: const Text('Activities'),
                centerTitle: true,
              ),
            ),
          ];
        },
        // Todo: replace body with activities card
        body: const Placeholder(),
      ),
    );
  }
}
