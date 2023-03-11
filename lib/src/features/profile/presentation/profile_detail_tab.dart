import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:simple_auth_flutter_riverpod/src/features/profile/presentation/profile_controller.dart';

class ProfileDetailTab extends ConsumerWidget {
  const ProfileDetailTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileControllerProvider);
    return profile.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Text('Error: $error'),
      data: (profile) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Username: '),
                Text(profile.username ?? ''),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Phone Number: '),
                Text(profile.phoneNumber ?? ''),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('First Name: '),
                Text(profile.firstName ?? ''),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Last Name: '),
                Text(profile.lastName ?? ''),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Gender: '),
                Text(profile.gender ?? ''),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Address: '),
                Text(
                    '${profile.addressLine1 ?? ''}, ${profile.addressLine2 ?? ''}'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Date of birth: '),
                Text(profile.dateOfBirth == null
                    ? ''
                    : DateFormat('yyyy-MM-dd').format(profile.dateOfBirth!)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
