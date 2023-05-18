import 'package:flutter/material.dart';

class OverflowText extends StatelessWidget {
  const OverflowText({super.key, required this.text, required this.fallback});

  final Text text;
  final Text fallback;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints size) {
        final TextPainter painter = TextPainter(
          maxLines: 1,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
          text: TextSpan(
              style: text.style ?? DefaultTextStyle.of(context).style,
              text: text.data),
        );

        painter.layout(maxWidth: size.maxWidth);

        return painter.didExceedMaxLines ? fallback : text;
      },
    );
  }
}
