import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/profile_repository.dart';
import '../../domain/profile_setting_options.dart';

class ProfileSettingScreen extends ConsumerWidget {
  const ProfileSettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<ProfileSettingOption> options =
        ref.watch(profileSettingOptionListProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          // Todo: change to context.pushNamed for unwanted cache error.
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.info),
            tooltip: 'Choose what you want to show in your profile',
          )
        ],
        title: const Text('Profile Setting'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          for (final option in options)
            SwitchListTile(
              value: option.optionState,
              onChanged: option.isDisable
                  ? null
                  : (value) => ref
                      .read(profileSettingOptionListProvider.notifier)
                      .toggle(option.label),
              title: Text(option.label),
            ),
        ],
      ),
    );
  }
}
