import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/shift/domain/attendance.dart';
import 'package:the_helper/src/features/shift/domain/create_shift.dart';
import 'package:the_helper/src/features/shift/domain/list_attendance.dart';
import 'package:the_helper/src/features/shift/domain/many_query_response.dart';
import 'package:the_helper/src/features/shift/domain/rate_shift.dart';
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

  Future<List<ShiftVolunteer>> modGetShiftVolunteers(
      {ShiftVolunteerQuery? query}) async {
    final res = await client.get(
      '/mod/shift-volunteers',
      queryParameters: query?.toJson(),
    );
    final List<dynamic> resList = res.data['data'];
    return resList.map((e) => ShiftVolunteer.fromJson(e)).toList();
    // return res.map((data) => ShiftVolunteer.fromJson(data)).toList();
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

  Future<ShiftVolunteer?> approveVolunteer({
    required int shiftId,
    required int volunteerId,
  }) async {
    final res = (await client.put(
      '/shifts/$shiftId/volunteers/$volunteerId/approve',
    ))
        .data['data'];
    return ShiftVolunteer.fromJson(res);
  }

  Future<ManyQueryResponse?> approveManyVolunteer({
    required int shiftId,
    required List<int> volunteerIds,
  }) async {
    final res = (await client.put('/shifts/$shiftId/volunteers/approve',
            data: {'volunteerIds': volunteerIds}))
        .data['data'];
    return ManyQueryResponse.fromJson(res);
  }

  Future<ShiftVolunteer?> rejectVolunteer({
    required int shiftId,
    required int volunteerId,
  }) async {
    final res = (await client.put(
      '/shifts/$shiftId/volunteers/$volunteerId/reject',
    ))
        .data['data'];
    return ShiftVolunteer.fromJson(res);
  }

  Future<ManyQueryResponse?> rejectManyVolunteer({
    required int shiftId,
    required List<int> volunteerIds,
  }) async {
    final res = (await client.put('/shifts/$shiftId/volunteers/reject',
            data: {'volunteerIds': volunteerIds}))
        .data['data'];
    return ManyQueryResponse.fromJson(res);
  }

  Future<ShiftVolunteer?> removeVolunteer({
    required int shiftId,
    required int volunteerId,
  }) async {
    final res = (await client.put(
      '/shifts/$shiftId/volunteers/$volunteerId/remove',
    ))
        .data['data'];
    return ShiftVolunteer.fromJson(res);
  }

  Future<ManyQueryResponse?> removeManyVolunteer({
    required int shiftId,
    required List<int> volunteerIds,
  }) async {
    final res = (await client.put('/shifts/$shiftId/volunteers/remove',
            data: {'volunteerIds': volunteerIds}))
        .data['data'];
    return ManyQueryResponse.fromJson(res);
  }

// TODO: replace completion and reviewNote with single Review object
  Future<ShiftVolunteer?> reviewVolunteer(
    double completion,
    String reviewNote, {
    required int shiftId,
    required int volunteerId,
  }) async {
    final res = (await client.put(
      '/shifts/$shiftId/volunteers/$volunteerId/review',
      data: {
        "completion": completion,
        "reviewNote": reviewNote,
      },
    ))
        .data['data'];
    return ShiftVolunteer.fromJson(res);
  }

  Future<ShiftVolunteer?> verifyAttendance({
    required int shiftId,
    required int volunteerId,
    required Attendance attendance,
  }) async {
    final res = (await client.put(
      '/shifts/$shiftId/volunteers/$volunteerId/verify-check-in',
      data: attendance.toJson(),
    ))
        .data['data'];
    return ShiftVolunteer.fromJson(res);
  }

  Future<ManyQueryResponse?> verifyManyAttendance({
    required int shiftId,
    required ListAttendance volunteers,
  }) async {
    final res = (await client.put(
      '/shifts/$shiftId/volunteers/verify-check-in',
      data: volunteers.toJson(),
    ))
        .data['data'];
    return ManyQueryResponse.fromJson(res);
  }

  Future<Shift> getShiftById({
    required int id,
    ShiftQuery? query,
  }) async {
    final res =
        await client.get('/shifts/$id', queryParameters: query?.toJson());
    final data = res.data['data'];
    // if (data == null) {
    //   return null;
    // }
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

  Future<ShiftVolunteer> checkIn({
    required int shiftId,
  }) async {
    final res = await client.put(
      '/shifts/$shiftId/volunteers/check-in',
    );
    return ShiftVolunteer.fromJson(res.data['data']);
  }

  Future<ShiftVolunteer> checkInTest({
    required int shiftId,
  }) async {
    final res = await client.put(
      '/test/shifts/$shiftId/volunteers/check-in',
    );
    return ShiftVolunteer.fromJson(res.data['data']);
  }

  Future<ShiftVolunteer> checkOut({
    required int shiftId,
  }) async {
    final res = await client.put(
      '/shifts/$shiftId/volunteers/check-out',
    );
    return ShiftVolunteer.fromJson(res.data['data']);
  }

  Future<ShiftVolunteer> checkOutTest({
    required int shiftId,
  }) async {
    final res = await client.put(
      '/test/shifts/$shiftId/volunteers/check-out',
    );
    return ShiftVolunteer.fromJson(res.data['data']);
  }

  Future<ShiftVolunteer> rateShift({
    required int shiftId,
    required RateShift data,
  }) async {
    final res = await client.post(
      '/shifts/$shiftId/volunteers/rate',
      data: data.toJson(),
    );
    return ShiftVolunteer.fromJson(res.data['data']);
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
