import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import 'package:the_helper/src/features/activity_manage/domain/activity.dart';
import 'package:the_helper/src/utils/dio.dart';

List<ActivityModel> accLst = [
  ActivityModel(
    id: 1,
    name: 'qkkw',
    startTime: DateTime.utc(2023, 1, 1, 6, 0 ,0),
    endTime: DateTime.utc(2023, 1, 1, 6, 0 ,0),
    description: 'dfasdfaefavasdffffffffffffffffffffffffffffffffffffffffffffffffffffas',
    shortDescription: 'asdfsaefavs',
    status: 0,
  ),
  ActivityModel(
    id: 1,
    name: 'qqw',
    startTime: DateTime.utc(2023, 1, 1, 6, 0 ,0),
    endTime: DateTime.utc(2023, 1, 1, 6, 0 ,0),
    description: 'dfasdfaefavas',
    shortDescription: 'asdfsaefavs',
    status: 0,
  ),
  ActivityModel(
    id: 1,
    name: 'qqw',
    startTime: DateTime.utc(2023, 1, 1, 6, 0 ,0),
    endTime: DateTime.utc(2023, 1, 1, 6, 0 ,0),
    description: 'dfasdfaefavas',
    shortDescription: 'asdfsaefavs',
    status: 0,
  ),
];

//Role Repository class
class ActivityRepository {
  final Dio client;

  ActivityRepository({
    required this.client,
  });

  Future<List<ActivityModel>> getAll(
      {
        int limit = 100, 
        int offset = 0, 
        int status = 0,
      }) async {
    // final List<dynamic> res = (await client.get(
    //   '/something',
    // ))
    //     .data['data'];
    final List<ActivityModel> res = accLst;
    // return res.map((e) => ActivityModel.fromMap(e)).toList();
    return res;
  }

  Future<ActivityModel> getById(int id) async {
    final res = await client.get('/something/$id');
    return ActivityModel.fromMap(res.data['data']);
  }

  Future<void> create(ActivityModel organization) async {
    await client.post('/something', data: organization.toJson());
  }

  Future<void> update(int id, ActivityModel organization) async {
    await client.put('/something/$id', data: organization.toJson());
  }

  Future<ActivityModel> delete(int id) async {
    final res = await client.delete('/something/$id');
    return ActivityModel.fromMap(res.data['data']);
  }
}

final activityRepositoryProvider =
    Provider((ref) => ActivityRepository(client: ref.watch(dioProvider)));
