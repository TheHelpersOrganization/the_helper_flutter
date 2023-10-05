import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/common/widget/search_bar/river_debounce_search_bar.dart';
import 'package:the_helper/src/features/contact/application/contact_service.dart';
import 'package:the_helper/src/features/contact/domain/contact.dart';
import 'package:the_helper/src/features/organization/presentation/organization_transfer_ownership/controller/organization_transfer_ownership_controller.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_creation/controller/mod_shift_creation_controller.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_creation/widget/shift_creation_contact/shift_selected_contacts.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_creation/widget/shift_creation_contact/shift_unselected_contacts.dart';

class ShiftContactCreateView extends ConsumerWidget {
  final Set<int>? initialContacts;
  final int? activityId;

  const ShiftContactCreateView({
    super.key,
    this.initialContacts,
    this.activityId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersState = ref.watch(memberDataProvider);

    if (membersState.valueOrNull == null) {
      return const SizedBox.shrink();
    }

    // Debounce search pattern
    ref.watch(contactServiceProvider);

    final searchContactsState = ref.watch(searchContactsProvider);
    final contacts = membersState.valueOrNull?.managers
        .flatMap((t) => t.contacts!)
        .filterByPattern(searchContactsState)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        actions: [
          TextButton.icon(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(Icons.check),
            label: const Text('Save'),
          ),
          const SizedBox(
            width: 12,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(90),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: RiverDebounceSearchBar.autoDispose(
              provider: searchContactsProvider,
              hintText: 'Search contacts',
            ),
          ),
        ),
      ),
      body: membersState.maybeWhen(
        skipLoadingOnRefresh: false,
        error: (error, stackTrace) => CustomErrorWidget(
          onRetry: () {
            ref.invalidate(membersProvider);
          },
        ),
        orElse: () {
          if (contacts == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShiftSelectedContacts(
                    contacts: contacts,
                    initialContacts: initialContacts,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  ShiftUnselectedContacts(
                    contacts: contacts,
                    initialContacts: initialContacts,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
