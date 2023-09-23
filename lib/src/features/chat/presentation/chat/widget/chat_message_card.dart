import 'package:flutter/material.dart';
import 'package:the_helper/src/features/chat/domain/chat_message.dart';

class ChatMessageCard extends StatelessWidget {
  final ChatMessage chatMessage;
  final Color? color;
  final Color? textColor;

  const ChatMessageCard({
    super.key,
    required this.chatMessage,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.6,
          ),
          child: SelectableText(
            chatMessage.message,
            //overflow: TextOverflow.visible,
            style: TextStyle(
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
