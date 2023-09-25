import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/chat/domain/create_chat.dart';
import 'package:the_helper/src/features/chat/presentation/chat/controller/chat_controller.dart';
import 'package:the_helper/src/features/contact/domain/contact.dart';

class ActivityContactCard extends ConsumerWidget {
  final Contact contact;

  const ActivityContactCard({
    super.key,
    required this.contact,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createChatState = ref.watch(createChatControllerProvider);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      isThreeLine: true,
      leading: Icon(
        Icons.phone,
        color: context.theme.colorScheme.onSurfaceVariant,
      ),
      title: Text(contact.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (contact.phoneNumber != null)
            Text(
              contact.phoneNumber!,
            ),
          if (contact.email != null)
            Text(
              contact.email!,
            ),
        ],
      ),
      trailing: IconButton(
        onPressed: contact.accountId == null
            ? null
            : () {
                ref.read(createChatControllerProvider.notifier).createChat(
                      CreateChat(
                        to: contact.accountId!,
                      ),
                      pushChatScreen: true,
                    );
              },
        icon: const Icon(Icons.chat),
      ),
    );
  }
}
