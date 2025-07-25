import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  // Comparison helpers
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }
  
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && 
           month == yesterday.month && 
           day == yesterday.day;
  }
  
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year && 
           month == tomorrow.month && 
           day == tomorrow.day;
  }
  
  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return isAfter(startOfWeek.subtract(const Duration(days: 1))) && 
           isBefore(endOfWeek.add(const Duration(days: 1)));
  }
  
  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }
  
  bool get isThisYear {
    return year == DateTime.now().year;
  }
  
  bool get isPast => isBefore(DateTime.now());
  
  bool get isFuture => isAfter(DateTime.now());
  
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
  
  // Formatting
  String format(String pattern) => DateFormat(pattern).format(this);
  
  String get formatted => DateFormat.yMMMd().format(this);
  
  String get formattedWithTime => DateFormat.yMMMd().add_jm().format(this);
  
  String get timeOnly => DateFormat.jm().format(this);
  
  String get dateOnly => DateFormat.yMMMd().format(this);
  
  String get monthYear => DateFormat.yMMM().format(this);
  
  String get dayMonth => DateFormat.MMMd().format(this);
  
  String get iso8601 => toIso8601String();
  
  // Relative time
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);
    
    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 7) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }
  
  String get timeUntil {
    final now = DateTime.now();
    final difference = this.difference(now);
    
    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return 'in $years ${years == 1 ? 'year' : 'years'}';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return 'in $months ${months == 1 ? 'month' : 'months'}';
    } else if (difference.inDays > 7) {
      final weeks = (difference.inDays / 7).floor();
      return 'in $weeks ${weeks == 1 ? 'week' : 'weeks'}';
    } else if (difference.inDays > 0) {
      return 'in ${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'}';
    } else if (difference.inHours > 0) {
      return 'in ${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'}';
    } else if (difference.inMinutes > 0) {
      return 'in ${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'}';
    } else {
      return 'Soon';
    }
  }
  
  // Date manipulation
  DateTime get startOfDay => DateTime(year, month, day);
  
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);
  
  DateTime get startOfWeek {
    final days = weekday - 1;
    return subtract(Duration(days: days)).startOfDay;
  }
  
  DateTime get endOfWeek {
    final days = 7 - weekday;
    return add(Duration(days: days)).endOfDay;
  }
  
  DateTime get startOfMonth => DateTime(year, month, 1);
  
  DateTime get endOfMonth => DateTime(year, month + 1, 0).endOfDay;
  
  DateTime get startOfYear => DateTime(year, 1, 1);
  
  DateTime get endOfYear => DateTime(year, 12, 31).endOfDay;
  
  DateTime addDays(int days) => add(Duration(days: days));
  
  DateTime subtractDays(int days) => subtract(Duration(days: days));
  
  DateTime addMonths(int months) {
    final newMonth = month + months;
    final yearsToAdd = (newMonth - 1) ~/ 12;
    final finalMonth = ((newMonth - 1) % 12) + 1;
    final finalYear = year + yearsToAdd;
    
    // Handle day overflow (e.g., Jan 31 + 1 month = Feb 28/29)
    final daysInFinalMonth = DateTime(finalYear, finalMonth + 1, 0).day;
    final finalDay = day > daysInFinalMonth ? daysInFinalMonth : day;
    
    return DateTime(finalYear, finalMonth, finalDay, hour, minute, second, millisecond, microsecond);
  }
  
  DateTime subtractMonths(int months) => addMonths(-months);
  
  DateTime addYears(int years) => DateTime(
    year + years,
    month,
    day,
    hour,
    minute,
    second,
    millisecond,
    microsecond,
  );
  
  DateTime subtractYears(int years) => addYears(-years);
  
  // Utility
  int get daysInMonth => DateTime(year, month + 1, 0).day;
  
  int get dayOfYear {
    return difference(DateTime(year, 1, 1)).inDays + 1;
  }
  
  int get weekOfYear {
    final startOfYear = DateTime(year, 1, 1);
    final firstMonday = startOfYear.weekday == 1 
        ? startOfYear 
        : startOfYear.add(Duration(days: 8 - startOfYear.weekday));
    
    if (isBefore(firstMonday)) return 1;
    
    return ((difference(firstMonday).inDays) ~/ 7) + 1;
  }
  
  // Age calculation
  int get age {
    final now = DateTime.now();
    int age = now.year - year;
    if (now.month < month || (now.month == month && now.day < day)) {
      age--;
    }
    return age;
  }
  
  // Conversion
  int get millisecondsSinceEpoch => millisecondsSinceEpoch;
  
  int get secondsSinceEpoch => millisecondsSinceEpoch ~/ 1000;
}