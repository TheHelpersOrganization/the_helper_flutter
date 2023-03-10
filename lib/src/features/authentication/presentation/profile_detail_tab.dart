import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/application/profile_service.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/presentation/profile_controller.dart';

class ProfileDetailTab extends ConsumerWidget {
  const ProfileDetailTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileControllerProvider);
    return profile.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
      data: (profile) => Text(profile.username),
    );
  }
}
