import 'package:flutter/material.dart';

class CustomSliverScrollView extends StatelessWidget {
  final Widget body;
  final Widget appBar;

  const CustomSliverScrollView({
    super.key,
    required this.body,
    required this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      floatHeaderSlivers: true,
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        appBar,
      ],
      body: body,
    );
  }
}
