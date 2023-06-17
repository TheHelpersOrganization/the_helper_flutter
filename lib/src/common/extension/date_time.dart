import 'package:intl/intl.dart';

extension DateTimeX on DateTime {
  String formatDayMonthYearBulletHourSecond() {
    return DateFormat('dd-MM-yyyy 🞄 HH:ss').format(this);
  }
}
