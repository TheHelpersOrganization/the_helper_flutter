import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/contact/domain/contact.dart';
import 'package:collection/collection.dart';
import '../profile/profile_contact_controller.dart';
import 'profile_contact_create_view.dart';
import 'profile_contact_edit_view.dart';

class ProfileEditContactWidget extends ConsumerWidget {
  final List<Contact>? initialContacts;

  const ProfileEditContactWidget({
    super.key,
    this.initialContacts,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Contacts',
                style: context.theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            TextButton.icon(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProfileContactCreateView(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Contact'),
            ),
          ],
        ),
        if (initialContacts?.isNotEmpty != true) ...[
          const SizedBox(height: 16),
          Text(
            'No contact',
            style: context.theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Tap "+ Add Contact" to add contact',
            style: TextStyle(color: context.theme.colorScheme.secondary),
          ),
        ],
        const SizedBox(height: 16),
        ...ListTile.divideTiles(
          tiles: initialContacts?.mapIndexed((i, contact) {
                String subtitle = '';
                if (contact.email != null) {
                  subtitle = contact.email!;
                  subtitle += '\n';
                }
                if (contact.phoneNumber != null) {
                  subtitle += contact.phoneNumber!;
                }

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  isThreeLine: true,
                  title: Text(contact.name),
                  subtitle: Text(subtitle),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProfileContactEditView(
                                initialData: contact,
                              ),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.edit,
                          color: context.theme.colorScheme.secondary,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await ref
                              .read(profileContactControllerProvider.notifier)
                              .removeContact(contact.id!);

                          ref.invalidate(profileContactControllerProvider);
                        },
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              }) ??
              [],
          context: context,
        ),
      ],
    );
  }
}
