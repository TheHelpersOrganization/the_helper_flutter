import 'package:flutter/material.dart';
import 'package:the_helper/src/common/extension/build_context.dart';

class AppDrawerItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final GestureTapCallback? onTap;
  final bool isSub;
  final String? path;

  const AppDrawerItem({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    required this.isSub,
    this.path,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = path == context.currentRoute;
    return Ink(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(32), bottomRight: Radius.circular(32)),
        color: isSelected ? Theme.of(context).colorScheme.primary : null,
      ),
      child: isSub
      ? Material(
        color: Colors.transparent.withOpacity(0.12),
        child: ListTile(
          dense: true,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
          title: Text(title,
              style: isSelected ? const TextStyle(color: Colors.white) : null),
          leading: Icon(isSub && isSelected ? Icons.radio_button_checked : icon,
              color: (isSelected ? Colors.white : null)),
          onTap: onTap,
        ),
      )
      :ListTile(
        dense: true,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        title: Text(title,
            style: isSelected ? const TextStyle(color: Colors.white) : null),
        leading: Icon(isSub && isSelected ? Icons.radio_button_checked : icon,
            color: (isSelected ? Colors.white : null)),
        onTap: onTap,
      ),
    );
  }
}
