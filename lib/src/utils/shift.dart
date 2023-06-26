import 'package:flutter/material.dart';
import 'package:the_helper/src/common/widget/label.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/features/shift/domain/shift_volunteer.dart';

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

Widget getShiftVolunteerStatusLabel(ShiftVolunteerStatus? status) {
  if (status == ShiftVolunteerStatus.pending) {
    return const Label(
      labelText: 'Waiting for approval',
      color: Colors.lightBlue,
    );
  } else if (status == ShiftVolunteerStatus.approved) {
    return const Label(
      labelText: 'Approved',
      color: Colors.green,
    );
  } else if (status == ShiftVolunteerStatus.rejected ||
      status == ShiftVolunteerStatus.removed) {
    return const Label(
      labelText: 'Rejected',
      color: Colors.red,
    );
  } else {
    return const SizedBox.shrink();
  }
}
