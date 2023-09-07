import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_creation/widget/activity_contact/activity_contact_create_view.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_creation/widget/activity_contact/controller/activity_contact_controller.dart';

class ActivityContactView extends ConsumerWidget {
  final int? activityId;
  final Set<int>? initialContacts;

  const ActivityContactView({
    super.key,
    this.activityId,
    this.initialContacts,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactsState = ref.watch(selectedContactsProvider(activityId));
    final contacts = contactsState.valueOrNull;
    final selectedContacts =
        ref.watch(selectedContactsIdProvider) ?? initialContacts;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Contacts',
                style: context.theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            TextButton.icon(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ActivityContactCreateView(
                      initialContacts: initialContacts,
                      activityId: activityId,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Contact'),
            ),
          ],
        ),
        contactsState.maybeWhen(
          skipLoadingOnRefresh: false,
          error: (error, stackTrace) => CustomErrorWidget(
            onRetry: () {
              ref.invalidate(selectedContactsProvider);
            },
          ),
          orElse: () {
            if (contacts == null && contactsState.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (selectedContacts?.isNotEmpty != true) ...[
                  const SizedBox(height: 16),
                  Text(
                    'No contact added',
                    style: context.theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap "+ Add Contact" to add skill or skip this step',
                    style:
                        TextStyle(color: context.theme.colorScheme.secondary),
                  ),
                ],
                const SizedBox(height: 16),
                ...ListTile.divideTiles(
                  tiles: contacts?.mapIndexed((i, contact) {
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
                          trailing: IconButton(
                            onPressed: () {
                              selectedContacts!.remove(contact.id);
                              ref
                                  .read(selectedContactsIdProvider.notifier)
                                  .state = {...selectedContacts};
                            },
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                          ),
                        );
                      }) ??
                      [],
                  context: context,
                ),
              ],
            );
          },
        )
      ],
    );
  }
}
