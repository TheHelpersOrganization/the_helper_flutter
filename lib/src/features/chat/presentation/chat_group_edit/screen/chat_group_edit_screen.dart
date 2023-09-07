import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/dialog/loading_dialog_content.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/common/widget/loading_overlay.dart';
import 'package:the_helper/src/features/chat/domain/update_chat_group.dart';
import 'package:the_helper/src/features/chat/presentation/chat_group_edit/controller/chat_group_edit_controller.dart';
import 'package:the_helper/src/utils/async_value_ui.dart';

class ChatGroupEditScreen extends ConsumerWidget {
  final int chatId;

  const ChatGroupEditScreen({
    super.key,
    required this.chatId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatProvider(chatId));
    final createChatGroupState = ref.watch(updateChatGroupControllerProvider);
    final chatName = ref.watch(chatNameProvider);

    ref.listen(updateChatGroupControllerProvider, (previous, next) {
      next.showSnackbarOnError(
        context,
        name: chatGroupUpdateSnackbarName,
      );
      next.showSnackbarOnSuccess(
        context,
        name: chatGroupUpdateSnackbarName,
        content: const Text('Chat group updated'),
      );
    });

    return LoadingOverlay.customDarken(
      isLoading: createChatGroupState.isLoading,
      indicator: const LoadingDialog(
        titleText: 'Updating chat group',
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit chat group'),
          actions: [
            FilledButton(
              onPressed: () {
                final name = chatName == null || chatName.trim().isEmpty
                    ? null
                    : chatName.trim();
                ref
                    .read(updateChatGroupControllerProvider.notifier)
                    .updateChatGroup(
                      data: UpdateChatGroup(
                        chatId: chatId,
                        name: name,
                      ),
                    );
              },
              child: const Text('Save'),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: chatState.when(
          skipLoadingOnRefresh: false,
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => CustomErrorWidget(
            onRetry: () => ref.invalidate(chatProvider(chatId)),
          ),
          data: (chat) {
            if (chat == null) {
              return CustomErrorWidget(
                message: 'Chat not found',
                onRetry: () => ref.invalidate(chatProvider(chatId)),
              );
            }
            return SingleChildScrollView(
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
                      initialValue: chatName ?? chat.name,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter chat name',
                        helperText: 'Optional. Max 50 characters',
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.maxLength(50),
                      ]),
                      onChanged: (value) => ref
                          .read(chatNameProvider.notifier)
                          .state = value.trim(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
