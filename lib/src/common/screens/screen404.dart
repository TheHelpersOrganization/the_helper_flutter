import 'package:flutter/material.dart';

class DevelopingScreen extends StatelessWidget {
  const DevelopingScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Icon(Icons.error),
          Text('404'),
          Text('Page not found'),
        ],
      ),
    );
  }
}
