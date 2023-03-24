import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_auth_flutter_riverpod/src/router/router.dart';
import 'package:simple_auth_flutter_riverpod/src/features/change_role/presentation/controllers/home_screen_controller.dart';

class CustomScrollItem extends ConsumerWidget {
  final String name;
  final String email;
  final bool isVerified;
  final bool isBanned;

  const CustomScrollItem({
    super.key,
    required this.name,
    required this.email,
    required this.isVerified,
    required this.isBanned,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(10),
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              child: Text('A'),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name),
                Text(email),
              ],
            ),
          ),
          isVerified 
          ? Text(
            'Verified',
            style: Theme.of(context).textTheme.labelMedium?.apply(
              color: Colors.green
            ),
          )
          : Text(
            'Not verified',
            style: Theme.of(context).textTheme.labelMedium?.apply(
              color: Colors.red
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
    );
  }
}
