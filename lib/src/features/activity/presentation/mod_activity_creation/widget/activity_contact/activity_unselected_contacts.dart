import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_creation/widget/activity_contact/controller/activity_contact_controller.dart';
import 'package:the_helper/src/features/contact/domain/contact.dart';

class ActivityUnselectedContacts extends ConsumerWidget {
  final List<Contact> contacts;
  final Set<int>? initialContacts;

  const ActivityUnselectedContacts({
    super.key,
    required this.contacts,
    this.initialContacts,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedContacts =
        ref.watch(selectedContactsIdProvider) ?? initialContacts ?? {};
    final unselectedContacts = contacts
        .where((element) => !selectedContacts.contains(element.id))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available contacts',
          style: context.theme.textTheme.bodyLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (unselectedContacts.isNotEmpty)
          ...unselectedContacts.map(
            (contact) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(contact.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (contact.email != null) Text(contact.email!),
                  if (contact.phoneNumber != null) Text(contact.phoneNumber!),
                ],
              ),
              trailing: TextButton.icon(
                icon: const Icon(Icons.add_outlined),
                label: const Text('Add'),
                onPressed: () {
                  ref.read(selectedContactsIdProvider.notifier).state = {
                    ...selectedContacts..add(contact.id!),
                  };
                },
              ),
            ),
          )
        else
          const Text(
            'No contact available',
            style: TextStyle(color: Colors.grey),
          ),
        const SizedBox(height: 12),
      ],
    );
  }
}
