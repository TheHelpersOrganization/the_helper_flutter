import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/controller/activity_controller.dart';
import 'package:the_helper/src/features/contact/data/contact_repository.dart';
import 'package:the_helper/src/features/contact/domain/contact.dart';
import 'package:the_helper/src/features/contact/domain/contact_query.dart';
import 'package:the_helper/src/features/organization/application/current_organization_service.dart';

final contactSearchPatternProvider =
    StateProvider.autoDispose<String>((ref) => '');

final selectedContactsIdProvider =
    StateProvider.autoDispose<Set<int>?>((ref) => null);

final selectedContactsProvider =
    FutureProvider.autoDispose.family<List<Contact>?, int?>(
  (ref, activityId) async {
    final organizationId =
        (await ref.watch(currentOrganizationServiceProvider.future))!.id;
    final selectedContacts = ref.watch(selectedContactsIdProvider);
    if (selectedContacts == null) {
      if (activityId == null) {
        return null;
      }
      final activity = await ref.watch(getActivityProvider(activityId).future);
      final initialIds = activity?.contacts?.map((e) => e.id!).toList();
      if (initialIds != null && initialIds.isNotEmpty) {
        return ref.watch(contactRepositoryProvider).getContacts(
              query: ContactQuery(
                organizationId: organizationId,
                id: initialIds,
              ),
            );
      }
      return null;
    }
    if (selectedContacts.isEmpty) {
      return [];
    }
    return ref.watch(contactRepositoryProvider).getContacts(
          query: ContactQuery(
            organizationId: organizationId,
            id: selectedContacts.toList(),
          ),
        );
  },
);

final searchedContactsProvider = FutureProvider.autoDispose<List<Contact>>(
  (ref) async {
    final organizationId =
        (await ref.watch(currentOrganizationServiceProvider.future))!.id;
    final searchPattern = ref.watch(contactSearchPatternProvider);
    final selectedContacts = ref.watch(selectedContactsIdProvider);
    return ref.watch(contactRepositoryProvider).getContacts(
          query: ContactQuery(
            organizationId: organizationId,
            search: searchPattern,
            excludeId: selectedContacts?.toList(),
            limit: 10,
          ),
        );
  },
);
