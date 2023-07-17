import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/report/data/report_repository.dart';
import 'package:the_helper/src/features/report/domain/report_request.dart';
import 'package:the_helper/src/features/report/domain/request_message.dart';

import '../../../../file/data/file_repository.dart';
import '../../../domain/report_type.dart';

part 'submit_report_screen_controller.g.dart';

@riverpod
class SubmitReportController extends _$SubmitReportController {
  @override
  FutureOr<void> build() {}

  Future<void> sendReport({
    required String title,
    required int id,
    required ReportType type,
    required String content,
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
    state = await AsyncValue.guard(
        () => ref.watch(reportRepositoryProvider).submitReport(
          ReportRequest(
            reportedAccountId: type == ReportType.account? id : null,
            reportedOrganizationId: type == ReportType.organization? id : null,
            reportedActivityId: type == ReportType.activity? id : null,
            type: type, 
            title: title,
            message: RequestMessage(
              content: content,
              fileIds: fileModels.map((e) => e.id).toList())
            )));
  }
}

