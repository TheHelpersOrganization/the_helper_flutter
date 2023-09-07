import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/utils/dio.dart';

import '../domain/contact.dart';
import '../domain/contact_query.dart';

class ContactRepository {
  final Dio client;

  ContactRepository({required this.client});

  Future<List<Contact>> getContacts({ContactQuery? query}) async {
    final List<dynamic> res = (await client.get(
      '/contacts',
      queryParameters: query?.toJson(),
    ))
        .data['data'];
    return res.map((e) => Contact.fromJson(e)).toList();
  }

  Future<Contact> getById(int id) async {
    final res = await client.get('/contacts/$id');
    return Contact.fromJson(res.data['data']);
  }

  Future<Contact> create(Contact contact) async {
    final res = await client.post('/contacts', data: contact.toJson());
    return Contact.fromJson(res.data['data']);
  }

  Future<Contact> update(int id, Contact contact) async {
    final res = await client.put('/contacts/$id', data: contact.toJson());
    return Contact.fromJson(res.data['data']);
  }

  Future<Contact> delete(int id) async {
    final res = await client.delete('/contacts/$id');
    return Contact.fromJson(res.data['data']);
  }
}

final contactRepositoryProvider =
    Provider((ref) => ContactRepository(client: ref.watch(dioProvider)));
