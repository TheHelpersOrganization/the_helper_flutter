import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/common/converter/comma_separated_ints_converter.dart';

part 'request_message.freezed.dart';
part 'request_message.g.dart';

@freezed
class RequestMessage with _$RequestMessage {
  factory RequestMessage({
    required String content,
    @CommaSeparatedIntsConverter() List<int>? fileIds,  
  }) = _RequestMessage;

  factory RequestMessage.fromJson(Map<String, dynamic> json) =>
      _$RequestMessageFromJson(json);
}
