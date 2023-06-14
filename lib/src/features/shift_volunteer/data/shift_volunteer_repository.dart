import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/shift_volunteer/domain/shift_volunteer.dart';
import 'package:the_helper/src/features/shift_volunteer/domain/shift_volunteer_query.dart';
import 'package:the_helper/src/utils/dio.dart';

class ShiftVolunteerRepository {
  final Dio client;

  const ShiftVolunteerRepository({
    required this.client,
  });

  Future<List<ShiftVolunteer>> getShiftVolunteers({
    ShiftVolunteerQuery? query,
  }) async {
    final res = await client.get(
      '/shift-volunteers',
      queryParameters: query?.toJson(),
    );
    final List<dynamic> resList = res.data['data'];
    return resList.map((e) => ShiftVolunteer.fromJson(e)).toList();
  }

  Future<ShiftVolunteer?> joinShift({
    required int shiftId,
  }) async {
    final res = await client.post(
      '/shifts/$shiftId/volunteers/join',
    );
    return ShiftVolunteer.fromJson(res.data['data']);
  }

  Future<ShiftVolunteer?> cancelJoinShift({
    required int shiftId,
  }) async {
    final res = await client.put(
      '/shifts/$shiftId/volunteers/cancel-join',
    );
    return ShiftVolunteer.fromJson(res.data['data']);
  }

  Future<ShiftVolunteer?> leaveShift({
    required int shiftId,
  }) async {
    final res = await client.put(
      '/shifts/$shiftId/volunteers/leave',
    );
    return ShiftVolunteer.fromJson(res.data['data']);
  }
}

final shiftVolunteerRepositoryProvider = Provider.autoDispose(
  (ref) => ShiftVolunteerRepository(
    client: ref.watch(dioProvider),
  ),
);
