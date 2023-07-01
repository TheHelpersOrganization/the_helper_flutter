import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/report/data/report_repository.dart';
import 'package:the_helper/src/features/report/domain/admin_report.dart';
import 'package:the_helper/src/features/report/domain/report_query.dart';

part 'report_detail_controller.g.dart';


@riverpod
class ReportDetailController extends _$ReportDetailController {
  @override
  FutureOr<AdminReportModel> build({
    required int id
  }) async {
    return _fetchReportDetail(id: id);
  }

  Future<AdminReportModel> _fetchReportDetail({
    required int id,
  }) async {
    final repository = ref.watch(reportRepositoryProvider);
    final data = await repository.getById(
      id: id,
      query: ReportQuery(
        include: [
          ReportQueryInclude.message,
          ReportQueryInclude.reporter
        ]
      ));
    return data;
  }

  // Future<void> updateProfile(Profile profile, {ProfileQuery? query}) async {
  //   state = const AsyncValue.loading();
  //   state = await AsyncValue.guard(() async {
  //     final profileRepository = ref.read(profileRepositoryProvider);
  //     await profileRepository.updateProfile(profile);
  //     return _fetchProfile();
  //   });
  // }
}
