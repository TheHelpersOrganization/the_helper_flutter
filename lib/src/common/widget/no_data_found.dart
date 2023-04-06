import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:the_helper/src/common/extension/build_context.dart';

class NoDataFound extends StatelessWidget {
  final Widget? icon;
  final Widget? content;
  final String? contentTitle;
  final TextStyle? contentTitleStyle;
  final String? contentSubtitle;
  final TextStyle? contentSubtitleStyle;

  const NoDataFound({
    Key? key,
    this.icon,
    this.content,
    this.contentTitle,
    this.contentTitleStyle,
    this.contentSubtitle,
    this.contentSubtitleStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];
    if (icon == null) {
      children.add(
        Container(
          constraints: BoxConstraints(
            maxWidth: context.mediaQuery.size.width * 0.8,
            maxHeight: context.mediaQuery.size.height * 0.3,
          ),
          child: SvgPicture.asset(
            'assets/images/no_data_found.svg',
          ),
        ),
      );
      children.add(const SizedBox(height: 32));
    } else {
      children.add(icon!);
    }
    if (content != null) {
      children.add(content!);
    } else {
      if (contentTitle != null) {
        children.add(
          Text(
            contentTitle!,
            style: contentTitleStyle ?? Theme.of(context).textTheme.titleLarge,
          ),
        );
      }
      if (contentSubtitle != null) {
        children.add(const SizedBox(height: 8));
        children.add(
          Text(
            contentSubtitle!,
            style:
                contentSubtitleStyle ?? Theme.of(context).textTheme.bodyMedium,
          ),
        );
      }
    }
    if (contentTitle == null && contentSubtitle == null) {
      children.add(
        Text(
          'No Data Found',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      );
    }

    return Center(
      child: Column(
        children: children,
      ),
    );
  }
}
