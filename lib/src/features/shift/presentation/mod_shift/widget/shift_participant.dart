import 'package:flutter/material.dart';

class ShiftParticipant extends StatelessWidget {
  final int? joinedParticipants;
  final int? numberOfParticipants;

  const ShiftParticipant({
    super.key,
    this.joinedParticipants,
    this.numberOfParticipants,
    bool hasShift = true,
  });

  @override
  Widget build(BuildContext context) {
    String slots = '';
    int jp = joinedParticipants ?? 0;
    final maxParticipants = numberOfParticipants;
    if (maxParticipants != null) {
      slots += '$jp/$maxParticipants';
    } else {
      slots += '$jp Joined';
    }
    final joinedPercentage = maxParticipants == null || maxParticipants < 1
        ? null
        : jp / maxParticipants;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Participants',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              slots,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: LinearProgressIndicator(
            value: joinedPercentage ?? 100,
          ),
        ),
        if (maxParticipants != null)
          Text(
            '${maxParticipants - jp} slots remaining',
          )
        else
          const Text('Unlimited slots'),
      ],
    );
  }
}
