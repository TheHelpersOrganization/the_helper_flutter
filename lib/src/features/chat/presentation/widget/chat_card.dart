import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/extension/date_time.dart';
import 'package:the_helper/src/features/authentication/application/auth_service.dart';
import 'package:the_helper/src/features/chat/domain/chat.dart';
import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/utils/image.dart';
import 'package:the_helper/src/utils/profile.dart';

class ChatCard extends ConsumerWidget {
  final Chat chat;

  const ChatCard({
    super.key,
    required this.chat,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final you = ref.watch(authServiceProvider).asData!.value!.account.id;
    final other = chat.participants?.firstWhere((e) => e.id != you);

    final name = getProfileName(other);
    final lastMessage = chat.messages?.firstOrNull?.message;

    return ListTile(
      leading: getBackendCircleAvatarOrCharacter(
        other?.avatarId,
        name.characters.firstOrNull,
      ),
      trailing: Text(chat.updatedAt.formatDayMonth()),
      title: Text(name),
      subtitle: lastMessage != null
          ? Text(
              lastMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: context.theme.colorScheme.secondary),
            )
          : null,
      onTap: () {
        context.goNamed(
          AppRoute.chat.name,
          pathParameters: {'chatId': chat.id.toString()},
        );
      },
    );
  }
}
