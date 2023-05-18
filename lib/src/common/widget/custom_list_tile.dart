import 'package:flutter/material.dart';
import 'package:the_helper/src/common/extension/build_context.dart';

class CustomListTile extends StatelessWidget {
  final String? titleText;
  final Widget? title;
  final String? subtitleText;
  final Widget? subtitle;
  final String? subtitleText2;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final Widget? leading;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;

  const CustomListTile({
    super.key,
    this.titleText,
    this.title,
    this.subtitleText,
    this.subtitle,
    this.subtitleText2,
    this.titleStyle,
    this.subtitleStyle,
    this.leading,
    this.trailing,
    this.padding = const EdgeInsets.symmetric(vertical: 8),
  });

  @override
  Widget build(BuildContext context) {
    final actualSubtitleStyle = subtitleStyle ??
        context.theme.textTheme.bodyMedium?.copyWith(
          color: context.theme.colorScheme.secondary,
        );

    return Padding(
      padding: padding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (leading != null) leading!,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) title!,
                if (titleText != null)
                  Text(titleText!,
                      style: titleStyle ?? context.theme.textTheme.bodyMedium),
                if (subtitle != null) subtitle!,
                if (subtitleText != null)
                  Text(subtitleText!, style: actualSubtitleStyle),
                if (subtitleText2 != null)
                  Text(subtitleText2!, style: actualSubtitleStyle),
              ],
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
