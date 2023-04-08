import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';

class CustomModalBottomSheet extends StatelessWidget {
  final String titleText;
  final Widget? content;
  final EdgeInsetsGeometry? titlePadding;
  final EdgeInsetsGeometry? contentPadding;

  const CustomModalBottomSheet({
    Key? key,
    required this.titleText,
    this.content,
    this.titlePadding,
    this.contentPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding:
              titlePadding ?? const EdgeInsets.only(top: 8, left: 8, right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: 24,
              ),
              Center(
                child: Text(
                  titleText,
                  style: context.theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
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
        ),
        const Divider(),
        Padding(
          padding: contentPadding ?? const EdgeInsets.all(8.0),
          child: content,
        ),
      ],
    );
  }
}
