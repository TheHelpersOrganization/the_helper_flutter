import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/utils/dio.dart';

import '../domain/location_model.dart';

class LocationRepository {
  final Dio client;

  LocationRepository({required this.client});

  Future<LocationModel> getById(int id) async {
    final res = await client.get('/locations/$id');
    return LocationModel.fromJson(res.data['data']);
  }

  Future<void> create(LocationModel location) async {
    await client.post('/locations', data: location.toJson());
  }

  Future<void> update(int id, LocationModel location) async {
    await client.put('/locations/$id', data: location.toJson());
  }

  Future<LocationModel> delete(int id) async {
    final res = await client.delete('/locations/$id');
    return LocationModel.fromJson(res.data['data']);
  }
}

final locationRepositoryProvider =
    Provider((ref) => LocationRepository(client: ref.watch(dioProvider)));
