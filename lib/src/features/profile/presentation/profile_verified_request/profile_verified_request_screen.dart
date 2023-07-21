import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/features/profile/presentation/profile_verified_request/profile_request_controller.dart';
import 'package:the_helper/src/utils/async_value_ui.dart';

import '../../../../common/widget/button/primary_button.dart';
import '../../../../common/widget/file_picker/form_multiple_file_picker_field.dart';
import '../profile_controller.dart';
import 'profile_review.dart';

// import '../../../common/widget/button/primary_button.dart';
// import '../domain/profile.dart';

class ProfileVerifiedRequestScreen extends ConsumerWidget {
  ProfileVerifiedRequestScreen({super.key});

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileControllerProvider());
    final customTileExpanded = ref.watch(expansionTitleControllerProvider);

    ref.listen<AsyncValue>(
      profileVerifiedRequestControllerProvider,
      (_, state) {
        state.showSnackbarOnError(context);
        state.showSnackbarOnSuccess(
          context,
          content: const Text('Verified request send'),
        );
      },
    );

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.pop();
            },
          ),
          title: const Text('Make verified request'),
          centerTitle: true,
        ),
        body: profile.when(
          error: (error, stacktrace) => Text(error.toString()),
          loading: () => const Center(child: CircularProgressIndicator()),
          data: (profile) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                ExpansionTile(
                  title: const Text('Your profile'),
                  subtitle: const Text('Review your profile before submit'),
                  initiallyExpanded: customTileExpanded,
                  trailing: Icon(
                    customTileExpanded
                        ? Icons.arrow_drop_down_circle
                        : Icons.arrow_left,
                  ),
                  children: <Widget>[
                    ProfileReviewWidget(
                      profile: profile,
                    ),
                  ],
                  onExpansionChanged: (bool expanded) {
                    ref.read(expansionTitleControllerProvider.notifier).state =
                        expanded;
                  },
                ),
                FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      FormMultipleFilePickerField(name: 'files'),
                      const SizedBox(
                        height: 32,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: PrimaryButton(
                        // isLoading: profile.isLoading,
                        onPressed: () async {
                          _formKey.currentState!.save();
                          // Validate returns true if the form is valid, or false otherwise.

                          final files = _formKey.currentState!.value['files'];

                          await ref
                              .read(profileVerifiedRequestControllerProvider
                                  .notifier)
                              .sendVerifiedRequest(files: files);

                          if (context.mounted) {
                            context.pop();
                          }
                        },
                        child: const Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
