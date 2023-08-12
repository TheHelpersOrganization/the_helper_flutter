import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/extension/widget.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/features/profile/presentation/profile/profile_contact_controller.dart';
import 'package:the_helper/src/features/profile/presentation/profile_edit/profile_edit_contact_widget.dart';
import 'package:the_helper/src/router/router.dart';

import '../profile_controller.dart';
import 'profile_edit_avatar_picker_widget.dart';
import 'profile_edit_basic_info_widget.dart';
import 'profile_edit_skill_widget.dart';

class ProfileEditScreen extends ConsumerWidget {
  ProfileEditScreen({super.key});

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contacts = ref.watch(profileContactControllerProvider);
    final profile = ref.watch(profileControllerProvider());

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              _formKey.currentState!.reset();
              context.goNamed(AppRoute.profile.name);
            },
          ),
          title: const Text('Edit Profile'),
          centerTitle: true,
        ),
        body: profile.when(
          error: (error, stacktrace) => Text(error.toString()),
          loading: () => const Center(child: CircularProgressIndicator()),
          data: (profile) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: FormBuilder(
              key: _formKey,
              child: Column(
                  children: <Widget>[
                Row(
                  children: [
                    Text(
                      'Avatar',
                      style: context.theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const ProfileEditAvatarPickerWidget(),
                const SizedBox(
                  height: 16,
                ),
                const Divider(),
                ProfileEditBasicInfoWidget(profile: profile, formKey: _formKey),
                const Divider(),
                ProfileEditSkillWidget(
                  profile: profile,
                ),
                const Divider(),
                contacts.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (_, __) => const CustomErrorWidget(),
                  data: (data) => ProfileEditContactWidget(
                    initialContacts: data,
                  ),
                ),
                const SizedBox(height: 16),
              ].padding(const EdgeInsets.symmetric(vertical: 5))),
            ),
          ),
        ));
  }
}
