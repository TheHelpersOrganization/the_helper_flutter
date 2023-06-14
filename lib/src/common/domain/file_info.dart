import 'package:flutter/foundation.dart';
import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'file_info.g.dart';
part 'file_info.freezed.dart';

@freezed
class FileInfoModel with _$FileInfoModel {
  factory FileInfoModel({
    int? id,
    required String name,
    required String internalName,
    required String mimetype,
    required double size,
    required String sizeUnit,
    int? createdBy,
  }) = _FileInfoModel;

  factory FileInfoModel.fromJson(Map<String, dynamic> json) =>
      _$FileInfoModelFromJson(json);
}
