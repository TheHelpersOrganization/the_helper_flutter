import 'package:flutter/material.dart';
import 'package:the_helper/src/common/extension/build_context.dart';

class LoadingDialog extends StatelessWidget {
  final Widget? content;
  final String? titleText;
  final String? subtitleText;
  final double indicatorSize;
  final double indicatorStrokeWidth;
  final bool showProgressIndicator;
  final bool showContent;

  const LoadingDialog({
    super.key,
    this.content,
    this.titleText,
    this.subtitleText,
    this.indicatorSize = 32,
    this.indicatorStrokeWidth = 3,
    this.showProgressIndicator = true,
    this.showContent = true,
  });

  const LoadingDialog.indicatorOnly({
    super.key,
    this.content,
    this.titleText,
    this.subtitleText,
    this.indicatorSize = 32,
    this.indicatorStrokeWidth = 3,
    this.showProgressIndicator = true,
  }) : showContent = false;

  @override
  Widget build(BuildContext context) {
    if (showProgressIndicator && !showContent) {
      return Center(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: const Padding(
            padding: EdgeInsets.all(24),
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return AlertDialog(
      contentPadding: const EdgeInsets.all(24),
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showProgressIndicator)
            Container(
              constraints: BoxConstraints(
                maxHeight: indicatorSize,
                maxWidth: indicatorSize,
              ),
              child: CircularProgressIndicator(
                strokeWidth: indicatorStrokeWidth,
              ),
            ),
          if (showProgressIndicator && showContent)
            const SizedBox(
              width: 24,
            ),
          if (showContent)
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
