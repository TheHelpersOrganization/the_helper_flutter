import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/router/router.dart';

class AppDrawerHeader extends StatelessWidget {
  const AppDrawerHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).canvasColor,
      padding: const EdgeInsets.only(
        top: 12,
        bottom: 12,
        left: 24,
        right: 12,
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                context.pop();
                context.goNamed(AppRoute.home.name);
              },
              splashFactory: NoSplash.splashFactory,
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage:
                        Image.asset('assets/images/logo.png').image,
                  ),
                  Expanded(
                    child: Text(
                      'The Helpers',
                      style: context.theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}
