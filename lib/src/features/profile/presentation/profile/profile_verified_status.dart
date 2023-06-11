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
    return verified
    ? const VerifiedStatus()
    : const UnverifiedStatus();
  }
}

class VerifiedStatus extends StatelessWidget {
  const VerifiedStatus({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      color: Colors.green,
      child: const Padding(
        padding: EdgeInsets.only(left: 20),
        child: Row(
          children: [
            Text(
              'Your account is verified',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(
              Icons.verified_user,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}

class UnverifiedStatus extends StatelessWidget {
  const UnverifiedStatus({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      color: const Color.fromRGBO(255,238,193,.95),
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          children: [
            const Text(
              'Your account is not verified. Do it now?',
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(
              width: 10,
            ),
            IconButton(
              onPressed: () => context.goNamed(AppRoute.profileVerified.name), 
              icon: const Icon(
                Icons.arrow_right_alt,
                color: Colors.black,
              )
            ),
          ],
        ),
      ),
    );
  }
}
