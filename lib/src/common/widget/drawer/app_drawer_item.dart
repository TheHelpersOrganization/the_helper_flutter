import 'package:flutter/material.dart';
import 'package:the_helper/src/common/extension/build_context.dart';

class AppDrawerItem extends StatelessWidget {
  final String title;
  final TextStyle? titleStyle;
  final String? subtitle;
  final TextStyle? subtitleStyle;
  final Widget? leading;
  final IconData? icon;
  final GestureTapCallback? onTap;
  final bool isSub;
  final String? path;
  final bool enabled;

  const AppDrawerItem({
    super.key,
    required this.title,
    this.titleStyle,
    this.subtitle,
    this.subtitleStyle,
    this.leading,
    this.icon,
    this.onTap,
    required this.isSub,
    this.path,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = path == context.currentRoute;
    final TextStyle? tStyle;
    final TextStyle? sStyle;
    if (isSelected) {
      tStyle = titleStyle == null
          ? const TextStyle(color: Colors.white)
          : titleStyle!.copyWith(color: Colors.white);
      sStyle = subtitleStyle == null
          ? const TextStyle(color: Colors.white)
          : subtitleStyle!.copyWith(color: Colors.white);
    } else {
      tStyle = titleStyle;
      sStyle = subtitleStyle;
    }
    return Ink(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        color: isSelected ? Theme.of(context).colorScheme.primary : null,
      ),
      child: ListTile(
        dense: true,
        enabled: enabled,
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        title: Text(title, style: tStyle),
        subtitle: subtitle == null ? null : Text(subtitle!, style: sStyle),
        leading: leading ??
            (icon == null
                ? null
                : Icon(isSub && isSelected ? Icons.radio_button_checked : icon,
                    color: (isSelected ? Colors.white : null))),
        onTap: onTap,
      ),
    );
  }
}
