import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/utils/domain_provider.dart';

part 'file_model.freezed.dart';
part 'file_model.g.dart';

@freezed
class FileModel with _$FileModel {
  factory FileModel({
    required int id,
    required String name,
    required String mimetype,
  }) = _FileModel;

  factory FileModel.fromJson(Map<String, dynamic> json) =>
      _$FileModelFromJson(json);
}

extension FileModelX on FileModel {
  String get asImageUrl => getImageUrl(id);
}
