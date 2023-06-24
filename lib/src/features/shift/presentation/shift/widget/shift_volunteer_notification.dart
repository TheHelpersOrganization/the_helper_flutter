import 'package:flutter/material.dart';

class ShiftVolunteerNotification extends StatelessWidget {
  final String message;
  final Widget? action;

  const ShiftVolunteerNotification({
    super.key,
    required this.message,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.yellow[100],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Wrap(
          spacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Icon(Icons.info_outline),
            Text(message),
            action ?? const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
