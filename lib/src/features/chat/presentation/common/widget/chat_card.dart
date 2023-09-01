import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/extension/date_time.dart';
import 'package:the_helper/src/features/authentication/application/auth_service.dart';
import 'package:the_helper/src/features/chat/domain/chat.dart';
import 'package:the_helper/src/features/chat/presentation/chat_list/controller/chat_list_controller.dart';
import 'package:the_helper/src/features/chat/presentation/common/widget/chat_avatar.dart';
import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/utils/profile.dart';

class ChatCard extends ConsumerWidget {
  final Chat chat;

  const ChatCard({
    super.key,
    required this.chat,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myId = ref.watch(authServiceProvider).asData!.value!.account.id;
    final creator = chat.participants!
        .firstWhere((element) => element.id == chat.createdBy);
    final name = chat.getDisplayName(myId: myId);
    final lastMessage = chat.messages?.firstOrNull?.message;

    final unread =
        chat.participants?.firstWhere((element) => element.id == myId).read !=
            true;

    final chatListSocket = ref.watch(chatListSocketProvider).asData?.value;

    return ListTile(
      leading: ChatAvatar(
        myId: myId,
        chat: chat,
      ),
      trailing: Text(
        chat.updatedAt.formatDayMonth(),
        style: TextStyle(
          fontWeight: unread ? FontWeight.bold : null,
        ),
      ),
      title: Text(
        name,
        style: TextStyle(
          fontWeight: unread ? FontWeight.bold : null,
        ),
      ),
      subtitle: lastMessage != null
          ? Text(
              lastMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: context.theme.colorScheme.secondary,
                fontWeight: unread ? FontWeight.bold : null,
              ),
            )
          : chat.isGroup
              ? Text(
                  'Group created by ${myId == creator.id ? 'you' : getChatParticipantName(creator)}',
                )
              : null,
      onTap: () {
        //chatListNotifier.markChatAsRead(chat.id, myId);
        chatListSocket?.emit('read-chat', chat.id);
        context.pushNamed(
          AppRoute.chat.name,
          pathParameters: {'chatId': chat.id.toString()},
        );
      },
    );
  }
}
