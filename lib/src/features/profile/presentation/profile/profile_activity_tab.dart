import 'package:flutter/material.dart';

class ProfileActivityTab extends StatelessWidget {
  const ProfileActivityTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Builder(
      builder: (context) => CustomScrollView(
        slivers: [
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          const SliverFillRemaining(
            child: Center(
              child: Text('Activity'),
            ),
          ),
        ],
      ),
    ));
  }
}
