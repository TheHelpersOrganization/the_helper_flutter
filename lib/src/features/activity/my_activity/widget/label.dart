import 'package:flutter/material.dart';
import 'package:the_helper/src/common/extension/build_context.dart';

class Label extends StatelessWidget {
  final String labelText;
  final TextStyle? labelStyle;
  final Color? color;

  const Label({
    super.key,
    required this.labelText,
    this.labelStyle,
    this.color,
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
        child: Text(
          labelText,
          style: labelStyle ??
              context.theme.textTheme.labelSmall
                  ?.copyWith(color: context.theme.colorScheme.onPrimary),
        ),
      ),
    );
  }
}
