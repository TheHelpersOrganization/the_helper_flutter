import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/report/data/report_repository.dart';
import 'package:the_helper/src/features/report/domain/report_type.dart';

import '../../../file/data/file_repository.dart';

part 'submit_report_screen_controller.g.dart';

@riverpod
class SubmitReportController extends _$SubmitReportController {
  @override
  FutureOr<void> build() {}

  Future<void> sendReport({
    required String title,
    required int accusedId,
    required String entityType,
    required String reportType,
    String? description,
    List<PlatformFile>? files,
  }) async {
    state = const AsyncLoading();
    final fileRepo = ref.read(fileRepositoryProvider);

    final fileFutures = files
            ?.map(
              (file) => fileRepo.uploadWithPlatformFile(
                file,
              ),
            )
            .toList() ??
        [];
    final fileModels = await Future.wait(fileFutures);
    // state = await AsyncValue.guard(
    //     () => ref.watch(reportRepositoryProvider).submitReport(ReportModel(
    //           title: title,
    //           accusedId: accusedId,
    //           entityType: entityType,
    //           reportType: reportType,
    //           description: description,
    //           files: fileModels.map((e) => e.id).toList(),
    //         )));
  }
}

@riverpod
class ReportTypeController extends _$ReportTypeController {
  @override
  FutureOr<List<ReportType>?> build(String entityType) {
    return getReportTypes(entityType: entityType);
  }

  Future<List<ReportType>?> getReportTypes({
    required String entityType,
  }) async {
    state = const AsyncLoading();
    final res = await AsyncValue.guard(() => ref
        .watch(reportRepositoryProvider)
        .getReportTypeList(entityType: entityType));
    return res.valueOrNull;
  }
}
