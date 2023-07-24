import 'package:flutter/material.dart';
import 'package:the_helper/src/common/extension/build_context.dart';

class VolunteerAnalyticsSecondaryCard extends StatelessWidget {
  final String titleText;
  final TextStyle? titleStyle;
  final String metaText;
  final TextStyle? metaStyle;
  final String subtitleText;
  final TextStyle? subtitleStyle;
  final EdgeInsetsGeometry? margin;

  const VolunteerAnalyticsSecondaryCard({
    super.key,
    required this.titleText,
    this.titleStyle,
    required this.metaText,
    this.metaStyle,
    required this.subtitleText,
    this.subtitleStyle,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: RichText(
                maxLines: 2,
                text: TextSpan(
                  text: titleText,
                  style: titleStyle ??
                      context.theme.textTheme.headlineLarge?.copyWith(
                        color: context.theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                  children: [
                    const WidgetSpan(
                      alignment: PlaceholderAlignment.baseline,
                      baseline: TextBaseline.alphabetic,
                      child: SizedBox(width: 4),
                    ),
                    TextSpan(
                      text: metaText,
                      style: metaStyle ??
                          context.theme.textTheme.bodyLarge
                              ?.copyWith(color: Colors.green),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitleText,
              style: subtitleStyle ??
                  TextStyle(
                    color: context.theme.colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
