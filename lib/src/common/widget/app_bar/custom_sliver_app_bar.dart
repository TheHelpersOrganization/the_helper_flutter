import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/widget/button/notification_button.dart';
import 'package:the_helper/src/router/router.dart';

class CustomSliverAppBar extends StatelessWidget {
  final Widget? title;
  final String? titleText;
  final bool centerTitle;
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final bool showBackButton;
  final VoidCallback? onBack;
  final VoidCallback? onBackFallback;
  final List<Widget>? actions;
  final double? expandedHeight;
  final Widget? flexibleSpace;
  final bool? showQRButton;

  const CustomSliverAppBar({
    super.key,
    this.title,
    this.titleText,
    this.centerTitle = true,
    this.leading,
    this.showBackButton = false,
    this.onBack,
    this.onBackFallback,
    this.bottom,
    this.actions,
    this.expandedHeight,
    this.flexibleSpace,
    this.showQRButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      iconTheme: const IconThemeData(color: Colors.black),
      backgroundColor: Colors.transparent,
      title: title ??
          (titleText == null
              ? null
              : Text(titleText!, style: const TextStyle(color: Colors.black))),
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
            if (showQRButton == true)
              IconButton(
                onPressed: () {
                  context.pushNamed(AppRoute.qrScan.name);
                },
                icon: const Icon(Icons.qr_code_scanner),
              ),
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: NotificationButton(),
            ),
          ],
      bottom: bottom,
      floating: true,
      expandedHeight: expandedHeight,
      flexibleSpace: flexibleSpace,
    );
  }
}
