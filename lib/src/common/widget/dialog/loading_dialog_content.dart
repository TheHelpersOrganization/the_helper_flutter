import 'package:flutter/material.dart';
import 'package:the_helper/src/common/extension/build_context.dart';

class LoadingDialog extends StatelessWidget {
  final Widget? content;
  final String? titleText;
  final String? subtitleText;
  final double indicatorSize;
  final double indicatorStrokeWidth;

  const LoadingDialog({
    super.key,
    this.content,
    this.titleText,
    this.subtitleText,
    this.indicatorSize = 32,
    this.indicatorStrokeWidth = 3,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(24),
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            constraints: BoxConstraints(
              maxHeight: indicatorSize,
              maxWidth: indicatorSize,
            ),
            child: CircularProgressIndicator(
              strokeWidth: indicatorStrokeWidth,
            ),
          ),
          const SizedBox(
            width: 24,
          ),
          Expanded(
            child: content ??
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titleText ?? 'Loading',
                      style: context.theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (subtitleText != null)
                      Text(
                        subtitleText!,
                        style: context.theme.textTheme.bodyLarge,
                      )
                    else
                      const Text('This may take a few minutes'),
                  ],
                ),
          ),
        ],
      ),
    );
  }
}
