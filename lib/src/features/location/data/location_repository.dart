import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/utils/dio.dart';

import '../domain/location.dart';

class LocationRepository {
  final Dio client;

  LocationRepository({required this.client});

  Future<Location> getById(int id) async {
    final res = await client.get('/locations/$id');
    return Location.fromJson(res.data['data']);
  }

  Future<void> create(Location location) async {
    await client.post('/locations', data: location.toJson());
  }

  Future<void> update(int id, Location location) async {
    await client.put('/locations/$id', data: location.toJson());
  }

  Future<Location> delete(int id) async {
    final res = await client.delete('/locations/$id');
    return Location.fromJson(res.data['data']);
  }
}

final locationRepositoryProvider =
    Provider((ref) => LocationRepository(client: ref.watch(dioProvider)));
