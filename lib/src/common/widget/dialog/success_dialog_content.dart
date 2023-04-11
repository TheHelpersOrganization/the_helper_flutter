import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SuccessDialog extends StatelessWidget {
  final Widget? title;
  final Widget? content;
  final String? titleText;
  final String? contentText;
  final TextStyle? titleTextStyle;
  final TextStyle? contentTextStyle;
  final Widget? footer;
  final List<Widget>? actions;
  final EdgeInsetsGeometry padding;

  const SuccessDialog({
    super.key,
    this.title,
    this.content,
    this.titleText,
    this.contentText,
    this.titleTextStyle,
    this.contentTextStyle,
    this.footer,
    this.actions,
    this.padding = const EdgeInsets.all(24),
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 28,
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: title ??
                Text(
                  titleText ?? 'Success',
                ),
          ),
          IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(
              Icons.close,
            ),
          ),
        ],
      ),
      titleTextStyle: titleTextStyle,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (content != null)
            content!
          else if (contentText != null)
            Text(contentText!, style: contentTextStyle),
          if (footer != null) footer!,
        ],
      ),
      actions: actions,
    );
  }
}
