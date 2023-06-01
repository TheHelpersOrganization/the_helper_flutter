import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:the_helper/src/features/file/domain/file_model.dart';
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
    return FileModel.fromMap(response.data['data']);
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
    return FileModel.fromMap(response.data['data']);
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
    return FileModel.fromMap(response.data['data']);
  }

  download() async {}
}

final fileRepositoryProvider =
    Provider((ref) => FileRepository(client: ref.watch(dioProvider)));
