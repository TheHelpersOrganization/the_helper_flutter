import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/common/widget/search_bar/river_debounce_search_bar.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_creation/widget/activity_contact/activity_selected_contacts.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_creation/widget/activity_contact/activity_unselected_contacts.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_creation/widget/activity_contact/controller/activity_contact_controller.dart';
import 'package:the_helper/src/features/contact/application/contact_service.dart';

class ActivityContactCreateView extends ConsumerWidget {
  final Set<int>? initialContacts;
  final int? activityId;

  const ActivityContactCreateView({
    super.key,
    this.initialContacts,
    this.activityId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Debounce search pattern
    ref.watch(contactServiceProvider);

    final searchContactsState = ref.watch(searchedContactsProvider);
    final contacts = searchContactsState.valueOrNull;

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
              provider: contactSearchPatternProvider,
              hintText: 'Search contacts',
            ),
          ),
        ),
      ),
      body: searchContactsState.maybeWhen(
        skipLoadingOnRefresh: false,
        error: (error, stackTrace) => CustomErrorWidget(
          onRetry: () {
            ref.invalidate(selectedContactsProvider);
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
                  ActivitySelectedContacts(
                    contacts: contacts,
                    initialContacts: initialContacts,
                    activityId: activityId,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  ActivityUnselectedContacts(
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
