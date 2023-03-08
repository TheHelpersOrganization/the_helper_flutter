import 'package:flutter/material.dart';
import 'package:simple_auth_flutter_riverpod/src/common/extension/build_context.dart';

import '../../../router/router.dart';

class AppDrawerItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final GestureTapCallback? onTap;
  final AppRoute? route;

  const AppDrawerItem({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    this.route,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = route?.path == context.currentRoute;

    return Ink(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(32), bottomRight: Radius.circular(32)),
        color: isSelected ? Theme.of(context).colorScheme.primary : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        title: Text(title,
            style: isSelected ? const TextStyle(color: Colors.white) : null),
        leading: Icon(icon, color: (isSelected ? Colors.white : null)),
        onTap: onTap,
      ),
    );
  }
}
