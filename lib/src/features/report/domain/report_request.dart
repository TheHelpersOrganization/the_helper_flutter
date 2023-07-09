import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/report/domain/request_message.dart';

import 'report_type.dart';

part 'report_request.freezed.dart';
part 'report_request.g.dart';

@freezed
class ReportRequest with _$ReportRequest {
  factory ReportRequest({
    required ReportType type,
    required String title,
    required RequestMessage message,
    int? reportedAccountId,
    int? reportedOrganizationId,
    int? reportedActivityId,
  }) = _ReportRequest;

  factory ReportRequest.fromJson(Map<String, dynamic> json) =>
      _$ReportRequestFromJson(json);
}
