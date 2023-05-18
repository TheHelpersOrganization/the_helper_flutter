import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/skill/domain/skill.dart';
import 'package:the_helper/src/features/skill/domain/skill_query.dart';
import 'package:the_helper/src/utils/dio.dart';

part 'skill_repository.g.dart';

class SkillRepository {
  final Dio client;

  SkillRepository({
    required this.client,
  });

  Future<List<Skill>> getSkills({SkillQuery? query}) async {
    final List<dynamic> res = (await client.get(
      '/skills',
      queryParameters: query?.toJson(),
    ))
        .data['data'];
    return res.map((e) => Skill.fromJson(e)).toList();
  }

  Future<Skill> getSkillById({required int id}) async {
    final res = (await client.get('/skills')).data['data'];
    return Skill.fromJson(res);
  }
}

@riverpod
SkillRepository skillRepository(SkillRepositoryRef ref) => SkillRepository(
      client: ref.watch(dioProvider),
    );
