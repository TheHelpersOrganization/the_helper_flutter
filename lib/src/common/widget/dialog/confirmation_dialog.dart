import 'package:flutter/material.dart';
import 'package:the_helper/src/common/extension/build_context.dart';

class ConfirmationDialog extends StatelessWidget {
  final String titleText;
  final TextStyle? titleStyle;
  final List<Widget>? contentColumnChildren;
  final Widget? content;
  final EdgeInsetsGeometry? titlePadding;
  final EdgeInsetsGeometry? contentPadding;
  final VoidCallback? onConfirm;
  final String confirmText;
  final String cancelText;
  final bool showActionCanNotBeUndoneText;

  const ConfirmationDialog({
    super.key,
    required this.titleText,
    this.titleStyle,
    this.content,
    this.contentColumnChildren,
    this.titlePadding,
    this.contentPadding,
    this.onConfirm,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.showActionCanNotBeUndoneText = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget? content = this.content ??
        (contentColumnChildren != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: contentColumnChildren!,
              )
            : null);
    if (showActionCanNotBeUndoneText) {
      if (content is Column) {
        content.children.add(
          const SizedBox(
            height: 8,
          ),
        );
        content.children.add(
          const Text(
            'This action can not be undone.',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      } else {
        content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            content!,
            const SizedBox(
              height: 8,
            ),
            const Text(
              'This action can not be undone.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        );
      }
    }

    return AlertDialog(
      titlePadding: titlePadding,
      contentPadding: contentPadding,
      title: Row(
        children: [
          Expanded(
            child: Text(
              titleText,
              style: titleStyle ?? context.theme.textTheme.titleLarge,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.close,
            ),
          ),
        ],
      ),
      content: content,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(cancelText),
        ),
        const SizedBox(
          width: 8,
        ),
        FilledButton(
          onPressed: onConfirm,
          child: Text(confirmText),
        )
      ],
    );
  }
}
