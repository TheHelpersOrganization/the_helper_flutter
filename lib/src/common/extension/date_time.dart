import 'package:intl/intl.dart';

extension DateTimeX on DateTime {
  String formatDayMonthYearBulletHourSecond() {
    return DateFormat('dd-MM-yyyy 🞄 HH:mm').format(toLocal());
  }

  String formatDayMonthYear() {
    return DateFormat('dd-MM-yyyy').format(toLocal());
  }

  String formatHourSecond() {
    return DateFormat('HH:mm').format(toLocal());
  }

  bool get isToday {
    final now = DateTime.now();
    return now.day == day && now.month == month && now.year == year;
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return tomorrow.day == day &&
        tomorrow.month == month &&
        tomorrow.year == year;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return yesterday.day == day &&
        yesterday.month == month &&
        yesterday.year == year;
  }
}
