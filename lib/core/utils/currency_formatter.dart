import 'package:intl/intl.dart';

/// Currency and number formatting utilities.
class CurrencyFormatter {
  CurrencyFormatter._();

  static final _currencyFmt = NumberFormat.currency(
    locale: 'es_MX',
    symbol: '\$',
    decimalDigits: 2,
  );

  static final _compactFmt = NumberFormat.compact(locale: 'es_MX');

  static final _percentFmt = NumberFormat.percentPattern('es_MX');

  /// Format as currency: $1,234.56
  static String format(double amount) => _currencyFmt.format(amount);

  /// Format compact: $1.2K, $3.4M
  static String formatCompact(double amount) {
    if (amount < 1000) return _currencyFmt.format(amount);
    return '\$${_compactFmt.format(amount)}';
  }

  /// Format as integer pesos: $1,234
  static String formatInt(double amount) =>
      '\$${NumberFormat('#,##0', 'es_MX').format(amount)}';

  /// Format as percentage: 75.3%
  static String formatPercent(double ratio) {
    final pct = (ratio * 100).clamp(0.0, 100.0);
    return '${pct.toStringAsFixed(1)}%';
  }

  /// Parse a currency string back to double.
  static double? tryParse(String input) {
    final cleaned = input.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(cleaned);
  }
}
