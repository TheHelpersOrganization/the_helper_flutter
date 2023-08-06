import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/contact_repository.dart';
import '../domain/contact.dart';
import '../domain/contact_query.dart';

part 'contact_service.g.dart';

class ContactService {
  final ContactRepository contactRepository;

  const ContactService({
    required this.contactRepository,
  });

  Future<List<Contact>> getOfAccount({
    required int id,
  }) async {
    final contacts =
        await contactRepository.getOfId(query: ContactQuery(accountId: id));
    return contacts;
  }

  Future<List<Contact>> getOfOrg({
    required int id,
  }) async {
    final contacts = await contactRepository.getOfId(
        query: ContactQuery(organizationId: id));
    return contacts;
  }

  Future<Contact> create({required Contact contact}) async {
    final res = await contactRepository.create(contact);
    return res;
  }

  Future<Contact> delete({required int id}) async {
    final res = await contactRepository.delete(id);
    return res;
  }

  Future<Contact> update({
    required int id,
    required Contact contact}) async {
    final res = await contactRepository.update(id, contact);
    return res;
  }
}

@riverpod
ContactService contactService(ContactServiceRef ref) {
  return ContactService(
      contactRepository: ref.watch(contactRepositoryProvider));
}
