import 'package:flutter/material.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/chat/domain/chat.dart';

class ChatBlockAlert extends StatelessWidget {
  final Chat chat;
  final int myId;
  final VoidCallback onUnblock;

  const ChatBlockAlert({
    super.key,
    required this.chat,
    required this.myId,
    required this.onUnblock,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            chat.blockedBy == myId
                ? 'You have blocked this user. Unblock to send messages.'
                : 'You have been blocked. You cannot send messages to this user.',
            style: TextStyle(
              color: context.theme.colorScheme.error,
            ),
          ),
        ),
        if (chat.blockedBy == myId)
          Padding(
            padding: const EdgeInsets.only(
              left: 12,
              right: 12,
              bottom: 12,
            ),
            child: OutlinedButton(
              onPressed: onUnblock,
              child: const Text('Unblock'),
            ),
          ),
      ],
    );
  }
}
