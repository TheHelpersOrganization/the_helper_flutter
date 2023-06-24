import 'package:flutter/material.dart';
import 'package:the_helper/src/common/extension/widget.dart';

class Alert extends StatelessWidget {
  final Widget message;
  final Widget? leading;
  final Widget? action;
  final double spacing;
  final Color? color;

  const Alert({
    super.key,
    required this.message,
    this.leading,
    this.action,
    this.spacing = 8,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    if (leading != null) {
      children.add(leading!);
    }
    children.add(Expanded(child: message));
    if (action != null) {
      children.add(action!);
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color ?? Colors.yellow[100],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Row(
          children: children.sizedBoxSpacing(SizedBox(
            width: spacing,
          )),
        ),
      ),
    );
  }
}
