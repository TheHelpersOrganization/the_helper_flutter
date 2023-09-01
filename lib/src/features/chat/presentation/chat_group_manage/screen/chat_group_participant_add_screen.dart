import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/dialog/loading_dialog_content.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/common/widget/loading_overlay.dart';
import 'package:the_helper/src/common/widget/search_bar/river_debounce_search_bar.dart';
import 'package:the_helper/src/features/chat/domain/chat_add_participants.dart';
import 'package:the_helper/src/features/chat/presentation/chat/controller/chat_controller.dart';
import 'package:the_helper/src/features/chat/presentation/chat_group_manage/controller/chat_group_participants_add_controller.dart';
import 'package:the_helper/src/utils/async_value_ui.dart';
import 'package:the_helper/src/utils/image.dart';
import 'package:the_helper/src/utils/profile.dart';

class ChatGroupParticipantAddScreen extends ConsumerWidget {
  final int chatId;

  const ChatGroupParticipantAddScreen({
    super.key,
    required this.chatId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatProvider(chatId));
    final availableParticipants =
        ref.watch(availableParticipantsProvider(chatId));
    final selectedProfiles = ref.watch(selectedProfilesProvider);
    final addParticipantState =
        ref.watch(chatGroupParticipantAddControllerProvider);

    ref.listen(chatGroupParticipantAddControllerProvider, (previous, next) {
      next.showSnackbarOnError(
        context,
        name: chatGroupParticipantAddSnackbarName,
      );
      next.showSnackbarOnSuccess(
        context,
        name: chatGroupParticipantAddSnackbarName,
        content: const Text('Participants added'),
      );
    });

    return LoadingOverlay.customDarken(
      isLoading: addParticipantState.isLoading,
      indicator: const LoadingDialog(
        titleText: 'Adding participants',
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add participants'),
          actions: [
            TextButton.icon(
              onPressed: () {
                ref
                    .read(chatGroupParticipantAddControllerProvider.notifier)
                    .addParticipants(
                      ChatAddParticipants(
                        chatId: chatId,
                        accountIds: selectedProfiles.map((e) => e.id!).toList(),
                      ),
                    );
              },
              icon: const Icon(Icons.check),
              label: const Text('Save'),
            ),
          ],
        ),
        body: chatState.when(
          skipLoadingOnRefresh: false,
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => CustomErrorWidget(
            onRetry: () => ref.invalidate(chatProvider(chatId)),
          ),
          data: (chat) => SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected Participants',
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
                                  ...selectedProfiles..remove(e),
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
                      onRetry: () =>
                          ref.invalidate(availableParticipantsProvider),
                    ),
                    data: (data) => Column(
                      children: data
                          .map(
                            (e) => ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 4),
                              leading:
                                  getBackendCircleAvatarOrCharacterFromProfile(
                                      e),
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
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
