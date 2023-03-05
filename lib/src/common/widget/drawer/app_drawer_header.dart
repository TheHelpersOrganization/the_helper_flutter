import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/application/auth_service.dart';

class AppDrawerHeader extends ConsumerWidget {
  const AppDrawerHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(authServiceProvider).valueOrNull?.account;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(
                'https://avatars.githubusercontent.com/u/66234343?s=400&u=5ceeec60f5b9d0ccc57f73f735ae1a99d2ea4f83&v=4'),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Volunteer Name',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  account?.email ?? 'Unknown',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
