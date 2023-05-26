import 'package:flutter/material.dart';

class ProfileOrganizationTab extends StatelessWidget {
  const ProfileOrganizationTab({super.key});

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
              child: Text('Organization'),
            ),
          ),
        ],
      ),
    ));
  }
}
