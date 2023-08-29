import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/dialog/loading_dialog_content.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/common/widget/loading_overlay.dart';
import 'package:the_helper/src/common/widget/search_bar/river_debounce_search_bar.dart';
import 'package:the_helper/src/features/chat/domain/create_chat_group.dart';
import 'package:the_helper/src/features/chat/presentation/chat_group_create/controller/create_chat_group_controller.dart';
import 'package:the_helper/src/utils/async_value_ui.dart';
import 'package:the_helper/src/utils/image.dart';
import 'package:the_helper/src/utils/profile.dart';

class ChatGroupCreateScreen extends ConsumerWidget {
  const ChatGroupCreateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatNameController = ref.watch(chatNameTextEditingControllerProvider);
    final selectedProfiles = ref.watch(selectedProfilesProvider);
    final availableParticipants = ref.watch(participantsProvider);
    final createChatGroupState = ref.watch(createChatGroupControllerProvider);

    ref.listen(createChatGroupControllerProvider, (previous, next) {
      next.showSnackbarOnSuccess(
        context,
        content: const Text('Chat group created'),
        name: createChatGroupSnackbarName,
      );
      next.showSnackbarOnError(
        context,
        name: createChatGroupSnackbarName,
      );
    });

    return LoadingOverlay.customDarken(
      isLoading: createChatGroupState.isLoading,
      indicator: const LoadingDialog(
        titleText: 'Creating chat group',
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create chat group'),
          actions: [
            FilledButton(
              onPressed: selectedProfiles.length < 2
                  ? null
                  : () {
                      final name = chatNameController.text.trim().isEmpty
                          ? null
                          : chatNameController.text.trim();
                      ref
                          .read(createChatGroupControllerProvider.notifier)
                          .createChatGroup(
                            CreateChatGroup(
                              name: name,
                              to: selectedProfiles.map((e) => e.id!).toList(),
                            ),
                          );
                    },
              child: const Text('Create'),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Name',
                  style: context.theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: chatNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter chat name',
                    helperText: 'Optional. Max 50 characters',
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.maxLength(50),
                  ]),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(),
                ),
                Text(
                  'Participants (2 or more)',
                  style: context.theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                if (selectedProfiles.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  ...selectedProfiles
                      .map((e) => ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 4),
                          leading:
                              getBackendCircleAvatarOrCharacterFromProfile(e),
                          title: Text(getProfileName(e)),
                          trailing: TextButton.icon(
                            onPressed: () {
                              ref
                                  .read(selectedProfilesProvider.notifier)
                                  .state = {
                                ...selectedProfiles,
                                e,
                              };
                            },
                            icon: const Icon(Icons.remove),
                            label: const Text('Remove'),
                          )))
                      .toList(),
                ] else ...[
                  const SizedBox(height: 12),
                  Text(
                    'No participants selected',
                    style: context.theme.textTheme.bodyMedium,
                  ),
                ],
                const SizedBox(height: 36),
                Text(
                  'Available participants',
                  style: context.theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                RiverDebounceSearchBar.autoDispose(
                  provider: searchPatternProvider,
                  hintText: 'Search participants',
                ),
                const SizedBox(height: 12),
                availableParticipants.when(
                  skipLoadingOnRefresh: false,
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (_, __) => CustomErrorWidget(
                    onRetry: () => ref.invalidate(participantsProvider),
                  ),
                  data: (data) => Column(
                    children: data
                        .map(
                          (e) => ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 4),
                            leading:
                                getBackendCircleAvatarOrCharacterFromProfile(e),
                            title: Text(getProfileName(e)),
                            trailing: TextButton.icon(
                              onPressed: () {
                                ref
                                    .read(selectedProfilesProvider.notifier)
                                    .state = {
                                  ...selectedProfiles,
                                  e,
                                };
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Add'),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
