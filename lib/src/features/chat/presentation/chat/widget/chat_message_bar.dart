import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/chat/domain/chat_message.dart';
import 'package:the_helper/src/features/chat/presentation/chat/controller/chat_controller.dart';

class ChatMessageBar extends ConsumerWidget {
  final int chatId;

  const ChatMessageBar({
    super.key,
    required this.chatId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatController = ref.read(chatControllerProvider.notifier);

    final chatMessageEditingController =
        ref.watch(chatMessageEditingControllerProvider);
    final message = chatMessageEditingController.text.trim();
    final isMessageEmpty = message.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: FormBuilderTextField(
                  name: 'message',
                  controller: chatMessageEditingController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    border: const OutlineInputBorder(),
                    hintText: 'Type a message',
                    suffixIcon: IconButton(
                      onPressed: () {
                        chatMessageEditingController.text = '';
                      },
                      icon: const Icon(Icons.clear_outlined),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: isMessageEmpty
                    ? null
                    : () {
                        chatController.sendMessage(
                          CreateChatMessage(
                            chatId: chatId,
                            message: message,
                          ),
                        );
                        chatMessageEditingController.text = '';
                      },
                icon: Icon(
                  Icons.send,
                  color: isMessageEmpty ? null : context.theme.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
