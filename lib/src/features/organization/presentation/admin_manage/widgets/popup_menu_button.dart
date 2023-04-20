import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PopupButton extends ConsumerWidget {
  const PopupButton({
    super.key,
    this.accountId,
  });
  final int? accountId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton(
        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              const PopupMenuItem(
                child: Text('Detail'),
              ),
              const PopupMenuItem(
                child: Text('Banned'),
              ),
              const PopupMenuItem(
                child: Text('Delete'),
              ),
            ]);
  }
}
