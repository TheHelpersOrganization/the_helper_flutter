import 'package:flutter/material.dart';
import 'package:the_helper/src/common/widget/label.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';

Widget getShiftStatusLabel(ShiftStatus? status) {
  if (status == ShiftStatus.pending) {
    return const Label(
      labelText: 'Upcoming',
      color: Colors.lightBlue,
    );
  } else if (status == ShiftStatus.ongoing) {
    return const Label(
      labelText: 'Ongoing',
      color: Colors.deepOrange,
    );
  } else if (status == ShiftStatus.completed) {
    return const Label(
      labelText: 'Completed',
      color: Colors.green,
    );
  } else {
    return const SizedBox.shrink();
  }
}
