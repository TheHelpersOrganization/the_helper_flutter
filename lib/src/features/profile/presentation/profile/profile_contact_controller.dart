import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/authentication/application/auth_service.dart';
import 'package:the_helper/src/features/contact/application/contact_service.dart';
import 'package:the_helper/src/features/contact/domain/contact.dart';

part 'profile_contact_controller.g.dart';

@riverpod
class ProfileContactController extends _$ProfileContactController {
  @override
  FutureOr<List<Contact>> build() async {
    return _getJoinedContact();
  }

  Future<List<Contact>> _getJoinedContact() async {
    final account = ref.watch(authServiceProvider).value!.account;
    final ContactService contactService = ref.watch(contactServiceProvider);
    final List<Contact> orgs = await contactService.getOfAccount(id: account.id);
    return orgs;
  }

  Future<Contact?> addContact(Contact contact) async {
    return ref.watch(contactServiceProvider).create(contact: contact);
  }

  Future<Contact?> removeContact(int id) async {
    return ref.watch(contactServiceProvider).delete(id: id);
  }

  Future<Contact?> updateContact(int id, Contact contact) async {
    return ref.watch(contactServiceProvider).update(id: id,contact: contact);
  }
}
