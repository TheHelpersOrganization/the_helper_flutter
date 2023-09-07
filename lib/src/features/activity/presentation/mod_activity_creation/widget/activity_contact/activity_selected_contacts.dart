import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_creation/widget/activity_contact/controller/activity_contact_controller.dart';
import 'package:the_helper/src/features/contact/domain/contact.dart';

class ActivitySelectedContacts extends ConsumerWidget {
  final List<Contact> contacts;
  final Set<int>? initialContacts;
  final int? activityId;

  const ActivitySelectedContacts({
    super.key,
    required this.contacts,
    this.initialContacts,
    this.activityId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedContactsState =
        ref.watch(selectedContactsProvider(activityId));
    final selectedContacts = selectedContactsState.valueOrNull;
    final selectedContactIds =
        ref.watch(selectedContactsIdProvider) ?? initialContacts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selected Contacts',
          style: context.theme.textTheme.bodyLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (selectedContactIds != null && selectedContactIds.isNotEmpty)
          ...selectedContacts?.map(
                (contact) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(contact.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (contact.email != null) Text(contact.email!),
                      if (contact.phoneNumber != null)
                        Text(contact.phoneNumber!),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      ref.read(selectedContactsIdProvider.notifier).state = {
                        ...selectedContactIds..remove(contact.id),
                      };
                    },
                  ),
                ),
              ) ??
              []
        else
          const Text(
            'No contact selected',
            style: TextStyle(color: Colors.grey),
          ),
        const SizedBox(height: 12),
      ],
    );
  }
}
