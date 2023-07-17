import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/location/domain/place_autocomplete.dart';
import 'package:the_helper/src/features/location/domain/place_autocomplete_query.dart';
import 'package:the_helper/src/features/location/domain/place_details.dart';
import 'package:the_helper/src/features/location/domain/place_details_query.dart';
import 'package:the_helper/src/features/location/domain/reverse_geocode.dart';
import 'package:the_helper/src/features/location/domain/reverse_geocode_query.dart';
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

  Future<List<PlaceAutocomplete>> placeAutocompleteQuery({
    required PlaceAutocompleteQuery query,
  }) async {
    if (query.input.trim().isEmpty) return const [];
    final res = await client.post(
      '/locations/place-autocomplete',
      data: query.toJson(),
    );
    final List<dynamic> resList = res.data['data'];
    return resList.map((e) => PlaceAutocomplete.fromJson(e)).toList();
  }

  Future<PlaceDetails> placeDetailsQuery({
    required PlaceDetailsQuery query,
  }) async {
    final res = await client.post(
      '/locations/place-details',
      data: query.toJson(),
    );
    return PlaceDetails.fromJson(res.data['data']);
  }

  Future<List<ReverseGeocode>> reverseGeocodeQuery({
    required ReverseGeocodeQuery query,
  }) async {
    final res = await client.post(
      '/locations/reverse-geocode',
      data: query.toJson(),
    );
    final List<dynamic> resList = res.data['data'];
    return resList.map((e) => ReverseGeocode.fromJson(e)).toList();
  }
}

final locationRepositoryProvider =
    Provider((ref) => LocationRepository(client: ref.watch(dioProvider)));
