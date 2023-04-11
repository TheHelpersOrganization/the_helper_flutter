import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'dialog_with_header.dart';

class ConfirmationDialog extends StatelessWidget {
  final String titleText;
  final TextStyle? titleStyle;
  final Widget? content;
  final EdgeInsetsGeometry? titlePadding;
  final EdgeInsetsGeometry? contentPadding;
  final VoidCallback onConfirm;

  const ConfirmationDialog({
    super.key,
    required this.titleText,
    this.titleStyle,
    this.content,
    this.titlePadding,
    this.contentPadding,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return DialogWithHeader(
      titleText: titleText,
      titleStyle: titleStyle,
      titlePadding: titlePadding,
      contentPadding: contentPadding,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (content != null) content!,
          const SizedBox(
            height: 24,
          ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text('No'),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                flex: 2,
                child: FilledButton(
                  onPressed: onConfirm,
                  child: const Text('Confirm'),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
