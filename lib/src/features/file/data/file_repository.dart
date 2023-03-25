import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:the_helper/src/features/file/domain/file_model.dart';
import 'package:the_helper/src/utils/dio.dart';

class FileRepository {
  final Dio client;

  FileRepository({required this.client});

  Future<FileModel> upload(String path) async {
    String filename = path.split('/').last;
    String? mimetype = lookupMimeType(path);
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        path,
        filename: filename,
        contentType: mimetype == null ? null : MediaType.parse(mimetype),
      )
    });
    final response = await client.post('/files/upload', data: formData);
    return FileModel.fromMap(response.data['data']);
  }

  download() async {}
}

final fileRepositoryProvider =
    Provider((ref) => FileRepository(client: ref.watch(dioProvider)));
