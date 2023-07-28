import 'package:flutter/material.dart';
import 'package:the_helper/src/common/exception/backend_exception.dart';

SnackBar errorSnackBar(String message) => SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
      showCloseIcon: true,
    );

SnackBar errorSnackBarFromException(Object error) {
  String? message;
  if (error is BackendException) {
    message = error.error.message;
  } else if (error is String) {
    message = error;
  }
  return SnackBar(
    content: Row(
      children: [
        const Icon(Icons.error, color: Colors.white),
        const SizedBox(width: 8),
        Expanded(child: Text(message ?? 'An error has happened')),
      ],
    ),
    backgroundColor: Colors.red,
    showCloseIcon: true,
  );
}
