import 'package:flutter/foundation.dart';

enum Environment {
  dev('Development'),
  staging('Staging'),
  prod('Production');
  
  final String name;
  const Environment(this.name);
}

abstract class Env {
  static Environment _current = Environment.dev;
  static Environment get current => _current;
  
  static const String appName = 'Pattern M';
  
  // Environment flags
  static bool get isDev => _current == Environment.dev;
  static bool get isStaging => _current == Environment.staging;
  static bool get isProd => _current == Environment.prod;
  
  // API Configuration
  static String get apiBaseUrl => switch (_current) {
    Environment.dev => 'https://api.dev.example.com',
    Environment.staging => 'https://api.staging.example.com',
    Environment.prod => 'https://api.example.com',
  };
  
  // Feature flags
  static bool get enableAnalytics => isProd;
  static bool get enableCrashReporting => !isDev;
  static bool get enableDebugBanner => isDev;
  static bool get enableLogging => isDev || isStaging;
  
  // Timeouts
  static Duration get apiTimeout => const Duration(seconds: isDev ? 60 : 30);
  static Duration get cacheTimeout => const Duration(hours: isProd ? 24 : 1);
  
  static Future<void> init() async {
    // Determine environment based on build mode or env variable
    if (kDebugMode) {
      _current = Environment.dev;
    } else if (const String.fromEnvironment('ENVIRONMENT') == 'staging') {
      _current = Environment.staging;
    } else {
      _current = Environment.prod;
    }
  }
}