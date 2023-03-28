import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/utils/dio.dart';

import '../domain/contact.dart';

class ContactRepository {
  final Dio client;

  ContactRepository({required this.client});

  Future<Contact> getById(int id) async {
    final res = await client.get('/contacts/$id');
    return Contact.fromJson(res.data['data']);
  }

  Future<void> create(Contact contact) async {
    await client.post('/contacts', data: contact.toJson());
  }

  Future<void> update(int id, Contact contact) async {
    await client.put('/contacts/$id', data: contact.toJson());
  }

  Future<Contact> delete(int id) async {
    final res = await client.delete('/contacts/$id');
    return Contact.fromJson(res.data['data']);
  }
}

final contactRepositoryProvider =
    Provider((ref) => ContactRepository(client: ref.watch(dioProvider)));
