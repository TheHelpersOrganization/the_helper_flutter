import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/utils/dio.dart';
import '../domain/shift.dart';

part 'shift_repository.g.dart';

class ShiftRepository {
  const ShiftRepository({required this.client});
  final Dio client;

  Future<List<Shift>> fetchShifts(int activityId) async {
    final List<dynamic> res =
        (await client.get('/activities/$activityId/shifts')).data['data'];
    final shifts = res.map((shift) => Shift.fromJson(shift)).toList();
    return shifts;
  }
  // Future<Shift> fetchShift(int shiftId) async {}
  // Future<Shift> addShift(Shift shift) async {}
  // Future<Shift> updateShift(Shift shift) async {}
  // Future<Shift> deleteShift(int shiftId) async {}
}

@riverpod
ShiftRepository shiftRepository(ShiftRepositoryRef ref) =>
    ShiftRepository(client: ref.watch(dioProvider));
