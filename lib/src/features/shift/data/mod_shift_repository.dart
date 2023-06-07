import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/shift/domain/create_shift.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/features/shift/domain/shift_query.dart';
import 'package:the_helper/src/utils/dio.dart';

class ModShiftRepository {
  final Dio client;

  ModShiftRepository({
    required this.client,
  });

  Future<List<Shift>> getShifts({
    ShiftQuery? query,
  }) async {
    final res = await client.get('/shifts', queryParameters: query?.toJson());
    final List<dynamic> resList = res.data['data'];
    return resList.map((e) => Shift.fromJson(e)).toList();
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
}

final modShiftRepositoryProvider = Provider.autoDispose<ModShiftRepository>(
  (ref) {
    final client = ref.watch(dioProvider);
    return ModShiftRepository(
      client: client,
    );
  },
);
