import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/file/data/file_repository.dart';
import 'package:the_helper/src/features/file/domain/file_model.dart';
import 'package:the_helper/src/features/file/domain/local_file.dart';
import 'package:the_helper/src/features/notification/application/download_notification_service.dart';

class FileService {
  final FileRepository fileRepository;
  final DownloadNotificationService downloadNotificationService;

  FileService({
    required this.fileRepository,
    required this.downloadNotificationService,
  });

  Future<void> downloadFileAndNotify({
    required FileModel fileModel,
    String? saveToPath,
  }) async {
    final notificationId =
        await downloadNotificationService.createDownloadNotification(
      filename: fileModel.name,
    );
    try {
      final localFile = await fileRepository.getDownloadPath(
        filename: fileModel.name,
        folderPath: '/storage/emulated/0/Download',
      );
      await fileRepository.download(
        fileModel: fileModel,
        saveToPath: localFile.fullPath,
        onProgress: (received, total) {
          downloadNotificationService.updateDownloadNotification(
            id: notificationId,
            folderPath: localFile.fullPath,
            filename: fileModel.name,
            progress: received / total,
          );
        },
      );
      downloadNotificationService.updateDownloadNotification(
        id: notificationId,
        filename: fileModel.name,
        folderPath: localFile.fullPath,
        progress: 1,
      );
    } catch (e) {
      downloadNotificationService.updateDownloadNotificationAsFailed(
        id: notificationId,
        filename: fileModel.name,
      );
    }
  }
}

final fileServiceProvider = Provider.autoDispose<FileService>((ref) {
  return FileService(
    fileRepository: ref.watch(fileRepositoryProvider),
    downloadNotificationService: ref.watch(downloadNotificationServiceProvider),
  );
});
