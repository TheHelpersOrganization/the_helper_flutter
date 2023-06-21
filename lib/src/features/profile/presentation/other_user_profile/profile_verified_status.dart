import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/router/router.dart';

class ProfileVerifiedStatus extends ConsumerWidget {
  final bool verified;
  const ProfileVerifiedStatus({
    super.key,
    required this.verified,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return !verified
    ? const VerifiedStatus()
    : const SizedBox();
  }
}

class VerifiedStatus extends StatelessWidget {
  const VerifiedStatus({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      // color: Colors.green,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Verified user',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Colors.green,
                fontSize: 18,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const Icon(
              Icons.verified_user,
              color: Colors.blue,
            )
          ],
        ),
      ),
    );
  }
}
