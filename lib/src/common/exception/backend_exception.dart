import 'package:flutter/foundation.dart';

@immutable
class BackendException implements Exception {
  final BackendExceptionData error;

  const BackendException({
    required this.error,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BackendException &&
          runtimeType == other.runtimeType &&
          error == other.error);

  @override
  int get hashCode => error.hashCode;

  @override
  String toString() {
    return 'BackendException{ error: $error }';
  }

  BackendException copyWith({
    BackendExceptionData? error,
  }) {
    return BackendException(
      error: error ?? this.error,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'error': error,
    };
  }

  factory BackendException.fromMap(Map<String, dynamic> map) {
    return BackendException(
      error: BackendExceptionData.fromMap(map['error']),
    );
  }
}

@immutable
class BackendExceptionData {
  final String message;
  final String errorCode;

  const BackendExceptionData({
    required this.message,
    required this.errorCode,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BackendExceptionData &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          errorCode == other.errorCode);

  @override
  int get hashCode => message.hashCode ^ errorCode.hashCode;

  @override
  String toString() {
    return 'BackendException{ message: $message, errorCode: $errorCode}';
  }

  BackendExceptionData copyWith({
    String? message,
    String? errorCode,
  }) {
    return BackendExceptionData(
      message: message ?? this.message,
      errorCode: errorCode ?? this.errorCode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'errorCode': errorCode,
    };
  }

  factory BackendExceptionData.fromMap(Map<String, dynamic> map) {
    return BackendExceptionData(
      message: map['message'] as String,
      errorCode: map['errorCode'] as String,
    );
  }
}
