import 'package:flutter/material.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/extension/widget.dart';

class Label extends StatelessWidget {
  final String? labelText;
  final TextStyle? labelStyle;
  final Widget? label;
  final Color? color;
  final Widget? leading;
  final Widget? trailing;
  final double spacing;

  const Label({
    super.key,
    required this.labelText,
    this.labelStyle,
    this.label,
    this.color,
    this.leading,
    this.trailing,
    this.spacing = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color ?? context.theme.colorScheme.primary,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null) leading,
            label ??
                Text(
                  labelText ?? '',
                  style: labelStyle ??
                      context.theme.textTheme.labelSmall?.copyWith(
                          color: context.theme.colorScheme.onPrimary),
                ),
            if (trailing != null) trailing,
          ].sizedBoxSpacing(SizedBox(
            width: spacing,
          )),
        ),
      ),
    );
  }
}
