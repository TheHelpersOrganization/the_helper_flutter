import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/drawer/app_drawer_item.dart';
import 'package:the_helper/src/common/widget/drawer/draw_item_model.dart';

import '../../../router/router.dart';

class AppDrawerDropDown extends ConsumerWidget {
  final String title;
  final IconData icon;
  final List<DrawerItemModel> subPaths;

  const AppDrawerDropDown({
    super.key,
    required this.title,
    required this.icon,
    required this.subPaths,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isSelected =
        subPaths.any((e) => e.route?.path == context.currentRoute);

    return Padding(
      padding: const EdgeInsets.only(right: 0.0),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          backgroundColor: Colors.transparent.withOpacity(0.12),
          tilePadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
            ),
          ),
          initiallyExpanded: isSelected,
          leading: Icon(icon),
          children: subPaths
          .map<Widget>((item) => AppDrawerItem(
            title: item.title,
            icon: Icons.radio_button_off,
            isSub: true,
            path: item.route?.path,
            onTap: () {
              context.goNamed(item.route != null
                  ? item.route!.name
                  : AppRoute.developing.name);
            },
          ))
          .toList(),
        ),
      ),
    );
  }
}
