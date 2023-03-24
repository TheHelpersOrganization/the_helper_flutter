import 'package:flutter/material.dart';
import 'package:the_helper/src/common/extension/build_context.dart';

class SplashScreen extends StatelessWidget {
  final bool enableIndicator;

  const SplashScreen({Key? key, this.enableIndicator = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF42a5f5),
      body: Center(
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 128,
              height: 128,
              gaplessPlayback: true,
            ),
            enableIndicator
                ? Positioned(
                    bottom: -context.mediaQuery.size.height * 0.15,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : null,
          ].whereType<Widget>().toList(),
        ),
      ),
    );
  }
}
