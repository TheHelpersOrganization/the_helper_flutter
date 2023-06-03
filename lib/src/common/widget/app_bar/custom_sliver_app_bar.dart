import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomSliverAppBar extends StatelessWidget {
  final String? titleText;
  final bool centerTitle;
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final bool showBackButton;
  final VoidCallback? onBack;
  final VoidCallback? onBackFallback;
  final List<Widget>? actions;

  const CustomSliverAppBar({
    super.key,
    this.titleText,
    this.centerTitle = true,
    this.leading,
    this.showBackButton = false,
    this.onBack,
    this.onBackFallback,
    this.bottom,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      iconTheme: const IconThemeData(color: Colors.black),
      backgroundColor: Colors.transparent,
      title: titleText == null
          ? null
          : Text(titleText!, style: const TextStyle(color: Colors.black)),
      centerTitle: centerTitle,
      leading: showBackButton
          ? IconButton(
              onPressed: onBack ??
                  () {
                    if (context.canPop()) {
                      context.pop();
                      return;
                    }
                    onBackFallback?.call();
                  },
              icon: const Icon(Icons.arrow_back),
            )
          : leading,
      actions: actions ??
          <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_none_outlined)),
            ),
          ],
      bottom: bottom,
      floating: true,
    );
  }
}
