import 'package:flutter/material.dart';

class CustomAppBar extends AppBar {
  CustomAppBar({super.key, String? title, List<Widget>? actions})
      : super(
            iconTheme: const IconThemeData(color: Colors.black),
            backgroundColor: Colors.transparent,
            centerTitle: true,
            elevation: 0.0,
            title: title != null
                ? Text(title, style: const TextStyle(color: Colors.black))
                : null,
            actions: actions ??
                [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.notifications_none_outlined)),
                ]);
}
