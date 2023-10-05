import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_creation/controller/mod_shift_creation_controller.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_creation/widget/shift_contact_view.dart';

class ShiftCreationContactView extends ConsumerWidget {
  final List<int>? initialContacts;

  const ShiftCreationContactView({
    super.key,
    this.initialContacts,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersState = ref.watch(memberDataProvider);
    final selectedContacts =
        ref.watch(selectedContactIdsProvider) ?? initialContacts;

    return membersState.when(
      skipLoadingOnRefresh: false,
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => CustomErrorWidget(
        onRetry: () => ref.invalidate(memberDataProvider),
      ),
      data: (data) {
        final availableContacts =
            data.managers.flatMap((e) => e.contacts!).toList();
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
                        builder: (_) => ShiftContactView(
                          initialContacts: initialContacts,
                        ),
                        fullscreenDialog: true,
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Contact'),
                ),
              ],
            ),
            if (selectedContacts?.isNotEmpty != true) ...[
              const SizedBox(height: 16),
              Text(
                'No contact added',
                style: context.theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Tap "+ Add Contact" to add skill or skip this step',
                style: TextStyle(color: context.theme.colorScheme.secondary),
              ),
            ],
            const SizedBox(height: 16),
            ...ListTile.divideTiles(
              tiles: selectedContacts?.mapIndexed((i, contactId) {
                    final contact = availableContacts.firstWhereOrNull(
                      (e) => e.id == contactId,
                    );
                    if (contact == null) {
                      return const SizedBox.shrink();
                    }
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
                          selectedContacts.removeAt(i);
                          ref.read(selectedContactIdsProvider.notifier).state =
                              [...selectedContacts];
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
    );
  }
}
