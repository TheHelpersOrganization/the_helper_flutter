import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';

class DialogWithHeader extends StatelessWidget {
  final String titleText;
  final TextStyle? titleStyle;
  final Widget? content;
  final EdgeInsetsGeometry? titlePadding;
  final EdgeInsetsGeometry? contentPadding;

  const DialogWithHeader({
    Key? key,
    required this.titleText,
    this.titleStyle,
    this.content,
    this.titlePadding,
    this.contentPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: titlePadding,
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
              context.pop();
            },
            icon: const Icon(
              Icons.close,
            ),
          ),
        ],
      ),
      contentPadding: contentPadding,
      content: content,
    );
  }
}
