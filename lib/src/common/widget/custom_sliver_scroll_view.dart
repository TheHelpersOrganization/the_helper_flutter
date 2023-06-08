import 'package:flutter/material.dart';

class CustomSliverScrollView extends StatelessWidget {
  final Widget appBar;
  final Widget body;

  const CustomSliverScrollView({
    super.key,
    required this.appBar,
    required this.body,
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
