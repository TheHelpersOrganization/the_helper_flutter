import 'package:freezed_annotation/freezed_annotation.dart';

part 'local_file.freezed.dart';
part 'local_file.g.dart';

@freezed
class LocalFile with _$LocalFile {
  factory LocalFile({
    required String folderPath,
    String? name,
  }) = _LocalFile;

  factory LocalFile.fromJson(Map<String, dynamic> json) =>
      _$LocalFileFromJson(json);
}

extension LocalFileX on LocalFile {
  String get fullPath => name == null ? folderPath : '$folderPath/$name';
}
