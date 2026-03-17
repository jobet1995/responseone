import 'package:intl/intl.dart';

/// Extensions to provide convenient formatting and logic for [DateTime].
extension DateTimeExtensions on DateTime {
  
  /// Returns a readable date string (e.g., Oct 24, 2023).
  String get toReadableDate => DateFormat.yMMMd().format(this);

  /// Returns a readable time string (e.g., 2:30 PM).
  String get toReadableTime => DateFormat.jm().format(this);

  /// Returns a full verbose string (e.g., October 24, 2023 2:30 PM).
  String get toReadableDateTime => DateFormat.yMMMMd().add_jm().format(this);

  /// Returns relative time (e.g., "5 mins ago", "Just now").
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} mins ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return toReadableDate;
    }
  }

  /// Checks if the date is today.
  bool get isToday {
    final now = DateTime.now();
    return now.day == day && now.month == month && now.year == year;
  }

  /// Returns the start of the day (00:00:00).
  DateTime get startOfDay => DateTime(year, month, day);

  /// Returns the end of the day (23:59:59).
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);
}
