import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:the_helper/src/features/file/domain/file_model.dart';
import 'package:the_helper/src/utils/dio_provider.dart';

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

  download() async {}
}

final fileRepositoryProvider =
    Provider((ref) => FileRepository(client: ref.watch(dioProvider)));
