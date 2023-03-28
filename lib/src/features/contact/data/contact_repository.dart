import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/contact/domain/contact_model.dart';
import 'package:the_helper/src/utils/dio.dart';

class ContactRepository {
  final Dio client;

  ContactRepository({required this.client});

  Future<ContactModel> getById(int id) async {
    final res = await client.get('/contacts/$id');
    return ContactModel.fromMap(res.data['data']);
  }

  Future<void> create(ContactModel contact) async {
    await client.post('/contacts', data: contact.toJson());
  }

  Future<void> update(int id, ContactModel contact) async {
    await client.put('/contacts/$id', data: contact.toJson());
  }

  Future<ContactModel> delete(int id) async {
    final res = await client.delete('/contacts/$id');
    return ContactModel.fromMap(res.data['data']);
  }
}

final contactRepositoryProvider =
    Provider((ref) => ContactRepository(client: ref.watch(dioProvider)));
