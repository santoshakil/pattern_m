import '../extensions/string_extensions.dart';

class Validators {
  Validators._();
  
  // Email validation
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    if (!value.isEmail) {
      return 'Please enter a valid email';
    }
    
    return null;
  }
  
  // Password validation
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    
    return null;
  }
  
  // Strong password validation
  static String? strongPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (!value.isStrongPassword) {
      return 'Password must contain uppercase, lowercase, number, and special character';
    }
    
    return null;
  }
  
  // Confirm password validation
  static String? Function(String?) confirmPassword(String password) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return 'Please confirm your password';
      }
      
      if (value != password) {
        return 'Passwords do not match';
      }
      
      return null;
    };
  }
  
  // Required field validation
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }
  
  // Min length validation
  static String? Function(String?) minLength(int minLength, {String? fieldName}) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return '${fieldName ?? 'This field'} is required';
      }
      
      if (value.length < minLength) {
        return '${fieldName ?? 'This field'} must be at least $minLength characters';
      }
      
      return null;
    };
  }
  
  // Max length validation
  static String? Function(String?) maxLength(int maxLength, {String? fieldName}) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return '${fieldName ?? 'This field'} is required';
      }
      
      if (value.length > maxLength) {
        return '${fieldName ?? 'This field'} must be at most $maxLength characters';
      }
      
      return null;
    };
  }
  
  // Length range validation
  static String? Function(String?) lengthRange(
    int minLength,
    int maxLength, {
    String? fieldName,
  }) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return '${fieldName ?? 'This field'} is required';
      }
      
      if (value.length < minLength || value.length > maxLength) {
        return '${fieldName ?? 'This field'} must be between $minLength and $maxLength characters';
      }
      
      return null;
    };
  }
  
  // Phone number validation
  static String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    
    if (!value.isPhoneNumber) {
      return 'Please enter a valid phone number';
    }
    
    return null;
  }
  
  // URL validation
  static String? url(String? value) {
    if (value == null || value.isEmpty) {
      return 'URL is required';
    }
    
    if (!value.isUrl) {
      return 'Please enter a valid URL';
    }
    
    return null;
  }
  
  // Number validation
  static String? number(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    
    if (!value.isNumeric) {
      return 'Please enter a valid number';
    }
    
    return null;
  }
  
  // Integer validation
  static String? integer(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    
    if (int.tryParse(value) == null) {
      return 'Please enter a valid integer';
    }
    
    return null;
  }
  
  // Range validation
  static String? Function(String?) numberRange(
    num min,
    num max, {
    String? fieldName,
  }) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return '${fieldName ?? 'This field'} is required';
      }
      
      final number = num.tryParse(value);
      if (number == null) {
        return 'Please enter a valid number';
      }
      
      if (number < min || number > max) {
        return '${fieldName ?? 'This field'} must be between $min and $max';
      }
      
      return null;
    };
  }
  
  // Date validation
  static String? date(String? value, {String? format}) {
    if (value == null || value.isEmpty) {
      return 'Date is required';
    }
    
    if (DateTime.tryParse(value) == null) {
      return 'Please enter a valid date${format != null ? ' ($format)' : ''}';
    }
    
    return null;
  }
  
  // Credit card validation
  static String? creditCard(String? value) {
    if (value == null || value.isEmpty) {
      return 'Credit card number is required';
    }
    
    // Remove spaces and dashes
    final cleanNumber = value.replaceAll(RegExp(r'[\s-]'), '');
    
    if (!cleanNumber.isNumeric) {
      return 'Please enter a valid credit card number';
    }
    
    if (cleanNumber.length < 13 || cleanNumber.length > 19) {
      return 'Please enter a valid credit card number';
    }
    
    // Luhn algorithm validation
    int sum = 0;
    bool alternate = false;
    
    for (int i = cleanNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cleanNumber[i]);
      
      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit = (digit % 10) + 1;
        }
      }
      
      sum += digit;
      alternate = !alternate;
    }
    
    if (sum % 10 != 0) {
      return 'Please enter a valid credit card number';
    }
    
    return null;
  }
  
  // CVV validation
  static String? cvv(String? value) {
    if (value == null || value.isEmpty) {
      return 'CVV is required';
    }
    
    if (!value.isNumeric || (value.length != 3 && value.length != 4)) {
      return 'Please enter a valid CVV';
    }
    
    return null;
  }
  
  // Expiry date validation (MM/YY)
  static String? expiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Expiry date is required';
    }
    
    final parts = value.split('/');
    if (parts.length != 2) {
      return 'Please enter expiry date in MM/YY format';
    }
    
    final month = int.tryParse(parts[0]);
    final year = int.tryParse(parts[1]);
    
    if (month == null || year == null) {
      return 'Please enter a valid expiry date';
    }
    
    if (month < 1 || month > 12) {
      return 'Please enter a valid month (01-12)';
    }
    
    final now = DateTime.now();
    final currentYear = now.year % 100;
    final currentMonth = now.month;
    
    if (year < currentYear || (year == currentYear && month < currentMonth)) {
      return 'Card has expired';
    }
    
    return null;
  }
  
  // Postal code validation
  static String? postalCode(String? value, {String countryCode = 'US'}) {
    if (value == null || value.isEmpty) {
      return 'Postal code is required';
    }
    
    switch (countryCode.toUpperCase()) {
      case 'US':
        final usZipRegex = RegExp(r'^\d{5}(-\d{4})?$');
        if (!usZipRegex.hasMatch(value)) {
          return 'Please enter a valid ZIP code';
        }
        break;
      case 'CA':
        final caPostalRegex = RegExp(r'^[A-Za-z]\d[A-Za-z][ -]?\d[A-Za-z]\d$');
        if (!caPostalRegex.hasMatch(value)) {
          return 'Please enter a valid postal code';
        }
        break;
      case 'UK':
      case 'GB':
        final ukPostcodeRegex = RegExp(
          r'^[A-Za-z]{1,2}\d{1,2}[A-Za-z]?\s?\d[A-Za-z]{2}$',
        );
        if (!ukPostcodeRegex.hasMatch(value)) {
          return 'Please enter a valid postcode';
        }
        break;
      default:
        // Generic validation
        if (value.length < 3 || value.length > 10) {
          return 'Please enter a valid postal code';
        }
    }
    
    return null;
  }
  
  // Username validation
  static String? username(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    
    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }
    
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      return 'Username can only contain letters, numbers, and underscores';
    }
    
    if (value.startsWith('_') || value.endsWith('_')) {
      return 'Username cannot start or end with underscore';
    }
    
    return null;
  }
  
  // Custom pattern validation
  static String? Function(String?) pattern(
    RegExp pattern, {
    String? errorMessage,
    String? fieldName,
  }) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return '${fieldName ?? 'This field'} is required';
      }
      
      if (!pattern.hasMatch(value)) {
        return errorMessage ?? 'Invalid format';
      }
      
      return null;
    };
  }
  
  // Composite validator
  static String? Function(String?) compose(List<String? Function(String?)> validators) {
    return (String? value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) return error;
      }
      return null;
    };
  }
}