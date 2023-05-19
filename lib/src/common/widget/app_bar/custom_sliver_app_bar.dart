import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomSliverAppBar extends StatelessWidget {
  final String? titleText;
  final Widget? leading;
  final bool showBackButton;
  final VoidCallback? onBackFallback;

  const CustomSliverAppBar({
    super.key,
    this.titleText,
    this.leading,
    this.showBackButton = false,
    this.onBackFallback,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      iconTheme: const IconThemeData(color: Colors.black),
      backgroundColor: Colors.transparent,
      title: titleText == null
          ? null
          : Text(titleText!, style: const TextStyle(color: Colors.black)),
      centerTitle: true,
      leading: showBackButton
          ? IconButton(
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                  return;
                }
                onBackFallback?.call();
              },
              icon: const Icon(Icons.arrow_back),
            )
          : leading,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none_outlined)),
        ),
      ],
      floating: true,
    );
  }
}
