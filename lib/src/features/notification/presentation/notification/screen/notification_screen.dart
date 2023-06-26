import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationScreen extends ConsumerWidget {
  final int notificationId;

  const NotificationScreen({
    super.key,
    required this.notificationId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
      ),
      body: const Column(
        children: [],
      ),
    );
  }
}
