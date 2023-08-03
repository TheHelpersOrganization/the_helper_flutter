import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class BackendException extends DioException {
  @override
  final BackendExceptionData error;

  BackendException({
    required this.error,
    RequestOptions? requestOptions,
  }) : super(requestOptions: requestOptions ?? RequestOptions());

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'error': error.toMap(),
    };
  }

  factory BackendException.fromMap(Map<String, dynamic> map) {
    return BackendException(
      error: BackendExceptionData.fromMap(map['error'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory BackendException.fromJson(String source) =>
      BackendException.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'BackendException(error: $error)';

  @override
  bool operator ==(covariant BackendException other) {
    if (identical(this, other)) return true;

    return other.error == error;
  }

  @override
  int get hashCode => error.hashCode;
}

@immutable
class BackendExceptionData {
  final String message;
  final String errorName;
  final String? errorCode;

  const BackendExceptionData({
    required this.message,
    required this.errorName,
    this.errorCode,
  });

  @override
  bool operator ==(covariant BackendExceptionData other) {
    if (identical(this, other)) return true;

    return other.message == message &&
        other.errorName == errorName &&
        other.errorCode == errorCode;
  }

  @override
  int get hashCode =>
      message.hashCode ^ errorName.hashCode ^ errorCode.hashCode;

  @override
  String toString() =>
      'BackendExceptionData(message: $message, errorName: $errorName, errorCode: $errorCode)';

  BackendExceptionData copyWith({
    String? message,
    String? errorName,
    String? errorCode,
  }) {
    return BackendExceptionData(
      message: message ?? this.message,
      errorName: errorName ?? this.errorName,
      errorCode: errorCode ?? this.errorCode,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'errorName': errorName,
      'errorCode': errorCode,
    };
  }

  factory BackendExceptionData.fromMap(Map<String, dynamic> map) {
    return BackendExceptionData(
      message: map['message'] as String,
      errorName: map['errorName'] as String,
      errorCode: map['errorCode'] != null ? map['errorCode'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BackendExceptionData.fromJson(String source) =>
      BackendExceptionData.fromMap(json.decode(source) as Map<String, dynamic>);
}
