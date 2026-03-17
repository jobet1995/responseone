import 'package:intl/intl.dart';

/// A collection of static methods for formatting data.
class AppFormatters {
  AppFormatters._();

  /// Formats a double into a currency string (e.g., PHP 1,000.00).
  static String formatCurrency(double amount, {String symbol = 'PHP'}) {
    return NumberFormat.currency(symbol: '$symbol ').format(amount);
  }

  /// Formats a phone number into a readable string (e.g., +63 912 345 6789).
  static String formatPhone(String phone) {
    String cleaned = phone.replaceAll(RegExp(r'\D'), '');
    if (cleaned.length == 11 && cleaned.startsWith('0')) {
      return '0 ${cleaned.substring(1, 4)} ${cleaned.substring(4, 7)} ${cleaned.substring(7)}';
    } else if (cleaned.length == 12 && cleaned.startsWith('63')) {
      return '+63 ${cleaned.substring(2, 5)} ${cleaned.substring(5, 8)} ${cleaned.substring(8)}';
    }
    return phone;
  }

  /// Shortens a long string with ellipses.
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Formats bytes into a human-readable size (KB, MB, GB).
  static String formatBytes(int bytes, {int decimals = 2}) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (bytes.bitLength / 10).floor();
    return '${(bytes / (1 << (i * 10))).toStringAsFixed(decimals)} ${suffixes[i]}';
  }
}
