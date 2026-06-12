/// DateTime extension helpers.
extension DateTimeExtension on DateTime {
  /// Returns only the date portion (no time).
  DateTime get dateOnly => DateTime(year, month, day);

  /// ISO date string: "2026-06-12"
  String get isoDate => toIso8601String().substring(0, 10);

  /// Difference in calendar days (ignoring time).
  int calendarDaysUntil(DateTime other) =>
      other.dateOnly.difference(dateOnly).inDays;

  /// Whether this date is today.
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Whether this date is yesterday.
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Start of the week (Monday).
  DateTime get startOfWeek =>
      dateOnly.subtract(Duration(days: weekday - 1));

  /// Start of the month.
  DateTime get startOfMonth => DateTime(year, month, 1);

  /// Start of the year.
  DateTime get startOfYear => DateTime(year, 1, 1);

  /// End of the day (23:59:59).
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59);
}
