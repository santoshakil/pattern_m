import 'dart:convert';

extension StringExtensions on String {
  // Validation
  bool get isEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }
  
  bool get isUrl {
    final urlRegex = RegExp(
      r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
    );
    return urlRegex.hasMatch(this);
  }
  
  bool get isPhoneNumber {
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]+$');
    return phoneRegex.hasMatch(this) && 
           replaceAll(RegExp(r'\D'), '').length >= 10;
  }
  
  bool get isNumeric => double.tryParse(this) != null;
  
  bool get isAlphabetic => RegExp(r'^[a-zA-Z]+$').hasMatch(this);
  
  bool get isAlphanumeric => RegExp(r'^[a-zA-Z0-9]+$').hasMatch(this);
  
  bool get isStrongPassword {
    // At least 8 characters, 1 uppercase, 1 lowercase, 1 number, 1 special char
    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
    );
    return passwordRegex.hasMatch(this);
  }
  
  // Transformations
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
  
  String get capitalizeWords {
    return split(' ').map((word) => word.capitalize).join(' ');
  }
  
  String get camelCase {
    if (isEmpty) return this;
    final words = split(RegExp(r'[\s_-]+'));
    if (words.isEmpty) return this;
    
    return words.first.toLowerCase() + 
           words.skip(1).map((w) => w.capitalize).join();
  }
  
  String get snakeCase {
    return replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '_${match.group(0)!.toLowerCase()}',
    ).replaceAll(RegExp(r'^_'), '').replaceAll(RegExp(r'[\s-]+'), '_');
  }
  
  String get kebabCase {
    return snakeCase.replaceAll('_', '-');
  }
  
  String get pascalCase {
    return split(RegExp(r'[\s_-]+')).map((w) => w.capitalize).join();
  }
  
  // Utilities
  String? get nullIfEmpty => isEmpty ? null : this;
  
  String? get nullIfBlank => trim().isEmpty ? null : this;
  
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - ellipsis.length)}$ellipsis';
  }
  
  String get reversed => split('').reversed.join();
  
  String removeWhitespace() => replaceAll(RegExp(r'\s+'), '');
  
  String normalizeWhitespace() => replaceAll(RegExp(r'\s+'), ' ').trim();
  
  // Parsing
  int? toIntOrNull() => int.tryParse(this);
  
  double? toDoubleOrNull() => double.tryParse(this);
  
  bool? toBoolOrNull() {
    switch (toLowerCase()) {
      case 'true':
      case '1':
      case 'yes':
      case 'y':
        return true;
      case 'false':
      case '0':
      case 'no':
      case 'n':
        return false;
      default:
        return null;
    }
  }
  
  DateTime? toDateTimeOrNull() => DateTime.tryParse(this);
  
  // Encoding/Decoding
  String get base64Encoded {
    final bytes = codeUnits;
    return base64.encode(bytes);
  }
  
  String get base64Decoded {
    final bytes = base64.decode(this);
    return String.fromCharCodes(bytes);
  }
  
  // Masking
  String mask({
    int start = 0,
    int? end,
    String maskChar = '*',
  }) {
    end ??= length;
    if (start >= length || end > length || start >= end) return this;
    
    final prefix = substring(0, start);
    final suffix = substring(end);
    final masked = maskChar * (end - start);
    
    return '$prefix$masked$suffix';
  }
  
  String maskEmail() {
    if (!isEmail) return this;
    final parts = split('@');
    final username = parts[0];
    final domain = parts[1];
    
    if (username.length <= 3) {
      return '${username[0]}**@$domain';
    }
    
    return '${username.substring(0, 2)}${'*' * (username.length - 3)}${username[username.length - 1]}@$domain';
  }
}