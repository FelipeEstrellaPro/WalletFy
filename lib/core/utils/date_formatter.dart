import 'package:intl/intl.dart';

/// Date and time formatting utilities.
class DateFormatter {
  DateFormatter._();

  static final _dateFmt = DateFormat('dd/MM/yyyy', 'es_MX');
  static final _shortFmt = DateFormat('dd MMM', 'es_MX');
  static final _monthYearFmt = DateFormat('MMMM yyyy', 'es_MX');
  static final _dayMonthFmt = DateFormat('d MMM yyyy', 'es_MX');
  static final _timeFmt = DateFormat('HH:mm', 'es_MX');
  static final _fullFmt = DateFormat('d MMMM yyyy, HH:mm', 'es_MX');

  /// dd/MM/yyyy
  static String format(DateTime date) => _dateFmt.format(date);

  /// "12 Jun"
  static String formatShort(DateTime date) => _shortFmt.format(date);

  /// "Junio 2026"
  static String formatMonthYear(DateTime date) => _monthYearFmt.format(date);

  /// "12 Jun 2026"
  static String formatDayMonth(DateTime date) => _dayMonthFmt.format(date);

  /// "HH:mm"
  static String formatTime(DateTime date) => _timeFmt.format(date);

  /// "12 junio 2026, 08:30"
  static String formatFull(DateTime date) => _fullFmt.format(date);

  /// Friendly relative: "Hoy", "Ayer", "Hace 3 días", or full date.
  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(date.year, date.month, date.day);
    final diff = today.difference(d).inDays;
    if (diff == 0) return 'Hoy';
    if (diff == 1) return 'Ayer';
    if (diff < 7) return 'Hace $diff días';
    return format(date);
  }

  /// Days remaining label: "En 5 días", "Vence hoy", "Venció hace 3 días"
  static String formatDeadline(DateTime deadline) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(deadline.year, deadline.month, deadline.day);
    final diff = d.difference(today).inDays;
    if (diff > 0) return 'En $diff días';
    if (diff == 0) return 'Vence hoy';
    return 'Venció hace ${-diff} días';
  }

  /// Parse HH:mm string to TimeOfDay-like record.
  static ({int hour, int minute}) parseTime(String hhmm) {
    final parts = hhmm.split(':');
    return (
      hour: int.tryParse(parts.first) ?? 8,
      minute: int.tryParse(parts.last) ?? 0,
    );
  }

  /// Greeting based on hour: Buenos días / tardes / noches
  static String greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Buenos días';
    if (h < 19) return 'Buenas tardes';
    return 'Buenas noches';
  }
}
