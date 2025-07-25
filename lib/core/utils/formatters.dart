import 'package:intl/intl.dart';

class Formatters {
  Formatters._();
  
  // Number formatters
  static String formatNumber(num value, {int? decimals}) {
    if (decimals != null) {
      return value.toStringAsFixed(decimals);
    }
    return NumberFormat.decimalPattern().format(value);
  }
  
  static String formatCompactNumber(num value) {
    return NumberFormat.compact().format(value);
  }
  
  static String formatCurrency(
    num value, {
    String? symbol,
    String? locale,
    int? decimalDigits,
  }) {
    return NumberFormat.currency(
      symbol: symbol ?? '\$',
      locale: locale,
      decimalDigits: decimalDigits,
    ).format(value);
  }
  
  static String formatPercentage(
    double value, {
    int decimals = 0,
    bool multiply = true,
  }) {
    final percentage = multiply ? value * 100 : value;
    return '${percentage.toStringAsFixed(decimals)}%';
  }
  
  static String formatBytes(int bytes, {int decimals = 2}) {
    if (bytes == 0) return '0 B';
    
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB'];
    final i = (bytes == 0) ? 0 : (bytes.bitLength ~/ 10);
    final size = bytes / (1 << (i * 10));
    
    return '${size.toStringAsFixed(decimals)} ${suffixes[i]}';
  }
  
  // Date/Time formatters
  static String formatDate(DateTime date, {String? pattern}) {
    return DateFormat(pattern ?? 'yyyy-MM-dd').format(date);
  }
  
  static String formatTime(DateTime time, {bool use24Hour = false}) {
    return DateFormat(use24Hour ? 'HH:mm' : 'h:mm a').format(time);
  }
  
  static String formatDateTime(DateTime dateTime, {String? pattern}) {
    return DateFormat(pattern ?? 'yyyy-MM-dd HH:mm').format(dateTime);
  }
  
  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 365) {
      return DateFormat.yMMMd().format(dateTime);
    } else if (difference.inDays > 30) {
      return DateFormat.MMMd().format(dateTime);
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
  
  static String formatDuration(Duration duration, {bool showSeconds = true}) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return showSeconds
          ? '${hours}h ${minutes}m ${seconds}s'
          : '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return showSeconds ? '${minutes}m ${seconds}s' : '${minutes}m';
    } else {
      return '${seconds}s';
    }
  }
  
  // String formatters
  static String formatPhoneNumber(String phone, {String countryCode = 'US'}) {
    // Remove all non-digit characters
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    
    switch (countryCode.toUpperCase()) {
      case 'US':
      case 'CA':
        if (digits.length == 10) {
          return '(${digits.substring(0, 3)}) ${digits.substring(3, 6)}-${digits.substring(6)}';
        } else if (digits.length == 11 && digits.startsWith('1')) {
          return '+1 (${digits.substring(1, 4)}) ${digits.substring(4, 7)}-${digits.substring(7)}';
        }
        break;
      case 'UK':
      case 'GB':
        if (digits.length == 11 && digits.startsWith('0')) {
          return '${digits.substring(0, 5)} ${digits.substring(5, 8)} ${digits.substring(8)}';
        } else if (digits.length == 13 && digits.startsWith('44')) {
          return '+44 ${digits.substring(2, 6)} ${digits.substring(6, 9)} ${digits.substring(9)}';
        }
        break;
    }
    
    // Default formatting for other countries
    return phone;
  }
  
  static String formatCreditCard(String cardNumber) {
    final digits = cardNumber.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();
    
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(digits[i]);
    }
    
    return buffer.toString();
  }
  
  static String maskCreditCard(String cardNumber) {
    final digits = cardNumber.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 8) return cardNumber;
    
    final lastFour = digits.substring(digits.length - 4);
    final masked = '*' * (digits.length - 4);
    
    return formatCreditCard('$masked$lastFour');
  }
  
  static String formatName(String name) {
    return name
        .trim()
        .split(' ')
        .map((word) => word.isEmpty
            ? ''
            : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
        .join(' ');
  }
  
  static String formatInitials(String name, {int count = 2}) {
    final words = name.trim().split(' ').where((w) => w.isNotEmpty).toList();
    final initials = words
        .take(count)
        .map((w) => w[0].toUpperCase())
        .join();
    
    return initials;
  }
  
  static String truncate(
    String text,
    int maxLength, {
    String ellipsis = '...',
    bool truncateAtWord = true,
  }) {
    if (text.length <= maxLength) return text;
    
    if (!truncateAtWord) {
      return '${text.substring(0, maxLength - ellipsis.length)}$ellipsis';
    }
    
    // Truncate at word boundary
    final truncated = text.substring(0, maxLength - ellipsis.length);
    final lastSpace = truncated.lastIndexOf(' ');
    
    if (lastSpace > 0) {
      return '${truncated.substring(0, lastSpace)}$ellipsis';
    }
    
    return '$truncated$ellipsis';
  }
  
  static String pluralize(
    int count,
    String singular, {
    String? plural,
    bool showCount = true,
  }) {
    final word = count == 1 ? singular : (plural ?? '${singular}s');
    return showCount ? '$count $word' : word;
  }
  
  // File size formatting
  static String formatFileSize(int bytes) {
    if (bytes == 0) return '0 B';
    
    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    final digitGroups = (bytes.bitLength - 1) ~/ 10;
    final size = bytes / (1 << (digitGroups * 10));
    
    return '${size.toStringAsFixed(size < 10 ? 1 : 0)} ${units[digitGroups]}';
  }
  
  // Address formatting
  static String formatAddress({
    String? street1,
    String? street2,
    String? city,
    String? state,
    String? postalCode,
    String? country,
  }) {
    final parts = <String>[];
    
    if (street1?.isNotEmpty ?? false) parts.add(street1!);
    if (street2?.isNotEmpty ?? false) parts.add(street2!);
    if (city?.isNotEmpty ?? false) {
      final cityLine = StringBuffer(city!);
      if (state?.isNotEmpty ?? false) cityLine.write(', $state');
      if (postalCode?.isNotEmpty ?? false) cityLine.write(' $postalCode');
      parts.add(cityLine.toString());
    }
    if (country?.isNotEmpty ?? false) parts.add(country!);
    
    return parts.join('\n');
  }
  
  // URL formatting
  static String formatUrl(String url) {
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      return 'https://$url';
    }
    return url;
  }
  
  static String extractDomain(String url) {
    final uri = Uri.tryParse(formatUrl(url));
    if (uri == null) return url;
    
    return uri.host.startsWith('www.') 
        ? uri.host.substring(4) 
        : uri.host;
  }
}