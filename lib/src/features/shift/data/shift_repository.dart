import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/shift/domain/create_shift.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/features/shift/domain/shift_query.dart';
import 'package:the_helper/src/features/shift/domain/shift_volunteer.dart';
import 'package:the_helper/src/features/shift/domain/shift_volunteer_query.dart';
import 'package:the_helper/src/features/shift/domain/update_shift.dart';
import 'package:the_helper/src/utils/dio.dart';

class ShiftRepository {
  final Dio client;

  ShiftRepository({
    required this.client,
  });

  Future<List<Shift>> getShifts({
    ShiftQuery? query,
  }) async {
    final res = await client.get('/shifts', queryParameters: query?.toJson());
    final List<dynamic> resList = res.data['data'];
    return resList.map((e) => Shift.fromJson(e)).toList();
  }

  Future<List<ShiftVolunteer>> getShiftVolunteerQ(
      {Map<String, dynamic>? queryParameters}) async {
    final List<dynamic> res = (await client.get(
      '/mod/shift-volunteers',
      queryParameters: queryParameters,
    ))
        .data['data'];
    return res.map((data) => ShiftVolunteer.fromJson(data)).toList();
  }

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

  Future<ShiftVolunteer?> approveVolunteer(
    int shiftId,
    int volunteerId,
    [CancelToken? cancenToken]
  ) async {
    final res = (await client.put(
      '/shifts/$shiftId/volunteers/$volunteerId/approve',
      cancelToken: cancenToken,
    ))
        .data['data'];
    return ShiftVolunteer.fromJson(res);
  }

  Future<ShiftVolunteer?> rejectVolunteer(
    int shiftId,
    int volunteerId,
  ) async {
    final res = (await client.put(
      '/shifts/$shiftId/volunteers/$volunteerId/reject',
    ))
        .data['data'];
    return ShiftVolunteer.fromJson(res);
  }

// TODO: replace completion and reviewNote with single Review object
  Future<ShiftVolunteer?> reviewVolunteer(
    int shiftId,
    int volunteerId,
    double completion,
    String reviewNote,
  ) async {
    final res = (await client.put(
      '/shifts/$shiftId/volunteers/$volunteerId/reject',
      queryParameters: {
        "completion": completion,
        "reviewNote": reviewNote,
      },
    ))
        .data['data'];
    return ShiftVolunteer.fromJson(res);
  }

  Future<Shift?> getShiftById({
    required int id,
    ShiftQuery? query,
  }) async {
    final res =
        await client.get('/shifts/$id', queryParameters: query?.toJson());
    final data = res.data['data'];
    if (data == null) {
      return null;
    }
    return Shift.fromJson(data);
  }

  Future<Shift> createShift({
    required CreateShift shift,
  }) async {
    final res = await client.post(
      '/shifts',
      data: shift.toJson(),
    );
    return Shift.fromJson(res.data['data']);
  }

  Future<Shift> updateShift({
    required int id,
    required UpdateShift shift,
  }) async {
    final res = await client.put(
      '/shifts/$id',
      data: shift.toJson(),
    );
    return Shift.fromJson(res.data['data']);
  }

  Future<Shift> deleteShift({
    required int id,
  }) async {
    final res = await client.delete('/shifts/$id');
    return Shift.fromJson(res.data['data']);
  }
}

final shiftRepositoryProvider = Provider.autoDispose<ShiftRepository>(
  (ref) {
    final client = ref.watch(dioProvider);
    return ShiftRepository(
      client: client,
    );
  },
);
