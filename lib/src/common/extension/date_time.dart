import 'package:intl/intl.dart';

extension DateTimeX on DateTime {
  String formatWeekDayDayMonthYearBulletHourMinute() {
    return DateFormat('EEE dd-MM-yyyy - HH:mm').format(toLocal());
  }

  String formatDayMonthYearBulletHourMinute() {
    return DateFormat('dd-MM-yyyy - HH:mm').format(toLocal());
  }

  String formatDayMonthYear() {
    return DateFormat('dd-MM-yyyy').format(toLocal());
  }

  String formatDayMonth() {
    return DateFormat('dd MMM').format(toLocal());
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

  String timeAgo({
    bool numericDates = true,
  }) {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays >= 60) {
      return formatDayMonthYear();
    } else if (difference.inDays >= 30) {
      return (numericDates) ? '1 month ago' : 'Last month';
    } else if (difference.inDays >= 7) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }
}
