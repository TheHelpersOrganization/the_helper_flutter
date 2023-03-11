import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_auth_flutter_riverpod/src/features/menu/data/menu_feature_list.dart';
import 'package:simple_auth_flutter_riverpod/src/features/menu/domain/role_menu.dart';
import 'package:simple_auth_flutter_riverpod/src/features/menu/presentation/widgets/feature_option.dart';

class VolunteerMenu extends ConsumerWidget {
  const VolunteerMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final RoleMenu featuresList = volunteerList;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: featuresList.ofProfile
              .map<Widget>(
                (item) => FeatureOption(icon: item.icon, name: item.label)
              ).toList(),
            ),
          ),
          Text('Menu'),
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: featuresList.ofMenu
              .map<Widget>(
                (item) => FeatureOption(icon: item.icon, name: item.label)
              ).toList(),
            ),
          ),
          Text('Account'),
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: featuresList.ofAccount
              .map<Widget>(
                (item) => FeatureOption(icon: item.icon, name: item.label)
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
