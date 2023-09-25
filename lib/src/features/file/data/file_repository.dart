import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:the_helper/src/features/file/domain/file_model.dart';
import 'package:the_helper/src/features/file/domain/local_file.dart';
import 'package:the_helper/src/utils/dio.dart';

class FileRepository {
  final Dio client;

  FileRepository({required this.client});

  Future<FileModel> upload(XFile file) async {
    String? mimetype = file.mimeType;
    if (kIsWeb) {
      mimetype = file.mimeType;
    } else {
      mimetype = lookupMimeType(file.path);
    }
    final stream = file.openRead();
    FormData formData = FormData.fromMap({
      "file": MultipartFile(
        stream,
        await file.length(),
        filename: file.name,
        contentType: mimetype == null ? null : MediaType.parse(mimetype),
      ),
    });
    final response = await client.post('/files/upload', data: formData);
    return FileModel.fromJson(response.data['data']);
  }

  Future<FileModel> uploadWithPlatformFile(PlatformFile file) async {
    String? mimetype =
        file.extension == null ? null : lookupMimeType(file.name);
    if (file.readStream == null) {
      throw 'No readStream found. PlatformFile must be created with readStream: true';
    }
    final stream = file.readStream!;
    FormData formData = FormData.fromMap({
      "file": MultipartFile(
        stream,
        file.size,
        filename: file.name,
        contentType: mimetype == null ? null : MediaType.parse(mimetype),
      ),
    });
    final response = await client.post('/files/upload', data: formData);
    return FileModel.fromJson(response.data['data']);
  }

  Future<FileModel> uploadWithBytes(Uint8List data) async {
    FormData formData = FormData.fromMap({
      "file": MultipartFile.fromBytes(
        data,
        filename: 'any',
        contentType: MediaType.parse('image/jpeg'),
      ),
    });
    final response = await client.post('/files/upload', data: formData);
    return FileModel.fromJson(response.data['data']);
  }

  Future<LocalFile> getDownloadPath({
    String? filename,
    String? folderPath,
  }) async {
    Directory downloadsDir = folderPath == null
        ? (Platform.isAndroid
                ? await getExternalStorageDirectory()
                : await getDownloadsDirectory()) ??
            await getTemporaryDirectory()
        : Directory(folderPath);
    if (filename == null) {
      return LocalFile(folderPath: downloadsDir.path);
    }
    String name = filename.split('.').first;
    String? ext = filename.split('.').lastOrNull;
    String dotExt = ext == null ? '' : '.$ext';
    print(downloadsDir.path);
    final downloadPath = downloadsDir.path.endsWith('/')
        ? downloadsDir.path.substring(0, downloadsDir.path.length - 1)
        : downloadsDir.path;
    File file = File('$downloadPath/$filename');
    int index = 0;
    while (file.existsSync()) {
      index++;
      file = File('$downloadPath/${name}_($index)$dotExt');
    }
    return LocalFile(folderPath: downloadPath, name: filename);
  }

  Future<void> download({
    required FileModel fileModel,
    String? saveToPath,
    void Function(int received, int total)? onProgress,
  }) async {
    final fileId = fileModel.id;
    final filename = fileModel.name;
    final res = await client.get(
      '/files/download/$fileId',
      onReceiveProgress: onProgress,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
      ),
    );
    File file;
    if (saveToPath == null) {
      final localFile = await getDownloadPath(filename: filename);
      file = File(localFile.fullPath);
    } else {
      file = File(saveToPath);
    }
    file.createSync();
    RandomAccessFile? raf;
    try {
      raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(res.data);
    } finally {
      await raf?.close();
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }
}

final fileRepositoryProvider =
    Provider((ref) => FileRepository(client: ref.watch(dioProvider)));
