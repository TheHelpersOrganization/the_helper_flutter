import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/widget/snack_bar.dart';

extension AsyncValueUI on AsyncValue {
  void showSnackbarOnError(BuildContext context) {
    if (!isLoading && !isRefreshing && hasError) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text(error.toString())),
      // );
      ScaffoldMessenger.of(context).showSnackBar(
        errorSnackBarFromException(error!),
      );
    }
  }

  void showSnackbarOnSuccess(
    BuildContext context, {
    Widget? content,
    SnackBarBehavior? behavior,
  }) {
    if (!isLoading && !isRefreshing && hasValue) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text(error.toString())),
      // );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: content ??
              const Text(
                'Success',
              ),
          showCloseIcon: true,
          behavior: behavior,
        ),
      );
    }
  }
}
