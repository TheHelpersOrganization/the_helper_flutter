import 'package:file_picker/file_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/report/data/report_repository.dart';
import 'package:the_helper/src/features/report/domain/request_message.dart';

import '../../../../file/data/file_repository.dart';



part 'reply_report_message_controller.g.dart';

@riverpod
class ReplyReportMessageController extends _$ReplyReportMessageController {
  @override
  FutureOr<void> build() {}

  Future<void> sendMessage({
    required int id,
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
        () => ref.watch(reportRepositoryProvider).sendReportMessage(
          id: id,
          msg: RequestMessage(
            content: content,
            fileIds: fileModels.map((e) => e.id).toList()
          )
        ));
  }
}

