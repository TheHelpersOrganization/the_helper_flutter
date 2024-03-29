import 'package:flutter/material.dart';
import 'package:the_helper/src/common/extension/build_context.dart';

class DrawerDropdownItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final GestureTapCallback? onTap;
  // final AppRoute? route;
  final String? path;

  const DrawerDropdownItem({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    this.path,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = path == context.currentRoute;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(32), bottomRight: Radius.circular(32)),
          color: isSelected ? Theme.of(context).colorScheme.primary : null,
        ),
        child: ListTile(
          dense: true,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
          title: Text(title,
              style: isSelected ? const TextStyle(color: Colors.white) : null),
          leading: Icon(icon, color: (isSelected ? Colors.white : null)),
          onTap: onTap,
        ),
      ),
    );
  }
}
