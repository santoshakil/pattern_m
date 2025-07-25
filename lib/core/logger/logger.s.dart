import 'package:flutter/foundation.dart';
import '../config/env.dart';

enum LogLevel {
  verbose,
  debug,
  info,
  warning,
  error,
  fatal,
}

class Logger {
  static final List<LogEntry> _logs = [];
  static List<LogEntry> get logs => List.unmodifiable(_logs);
  
  static const int _maxLogs = 1000;
  static LogLevel _minLevel = LogLevel.debug;
  
  static void init({LogLevel minLevel = LogLevel.debug}) {
    _minLevel = minLevel;
  }
  
  static void v(String message, {dynamic error, StackTrace? stackTrace}) {
    _log(LogLevel.verbose, message, error: error, stackTrace: stackTrace);
  }
  
  static void d(String message, {dynamic error, StackTrace? stackTrace}) {
    _log(LogLevel.debug, message, error: error, stackTrace: stackTrace);
  }
  
  static void i(String message, {dynamic error, StackTrace? stackTrace}) {
    _log(LogLevel.info, message, error: error, stackTrace: stackTrace);
  }
  
  static void w(String message, {dynamic error, StackTrace? stackTrace}) {
    _log(LogLevel.warning, message, error: error, stackTrace: stackTrace);
  }
  
  static void e(String message, {dynamic error, StackTrace? stackTrace}) {
    _log(LogLevel.error, message, error: error, stackTrace: stackTrace);
  }
  
  static void f(String message, {dynamic error, StackTrace? stackTrace}) {
    _log(LogLevel.fatal, message, error: error, stackTrace: stackTrace);
  }
  
  static void _log(
    LogLevel level,
    String message, {
    dynamic error,
    StackTrace? stackTrace,
  }) {
    if (!Env.enableLogging) return;
    if (level.index < _minLevel.index) return;
    
    final entry = LogEntry(
      level: level,
      message: message,
      timestamp: DateTime.now(),
      error: error,
      stackTrace: stackTrace,
    );
    
    // Add to log history
    _logs.add(entry);
    if (_logs.length > _maxLogs) {
      _logs.removeAt(0);
    }
    
    // Print to console
    final prefix = '[${entry.levelSymbol}] ${entry.timestamp.toIso8601String()}';
    final output = '$prefix - $message';
    
    if (kDebugMode) {
      switch (level) {
        case LogLevel.verbose:
        case LogLevel.debug:
        case LogLevel.info:
          debugPrint(output);
          break;
        case LogLevel.warning:
          debugPrint('\x1B[33m$output\x1B[0m'); // Yellow
          break;
        case LogLevel.error:
        case LogLevel.fatal:
          debugPrint('\x1B[31m$output\x1B[0m'); // Red
          if (error != null) {
            debugPrint('Error: $error');
          }
          if (stackTrace != null) {
            debugPrint('Stack trace:\\n$stackTrace');
          }
          break;
      }
    }
    
    // In production, send to crash reporting service
    if (Env.enableCrashReporting && level.index >= LogLevel.error.index) {
      // TODO: Send to crash reporting service
    }
  }
  
  static void clear() {
    _logs.clear();
  }
  
  static String exportLogs() {
    return _logs.map((e) => e.toString()).join('\\n');
  }
}

class LogEntry {
  final LogLevel level;
  final String message;
  final DateTime timestamp;
  final dynamic error;
  final StackTrace? stackTrace;
  
  const LogEntry({
    required this.level,
    required this.message,
    required this.timestamp,
    this.error,
    this.stackTrace,
  });
  
  String get levelSymbol => switch (level) {
    LogLevel.verbose => 'V',
    LogLevel.debug => 'D',
    LogLevel.info => 'I',
    LogLevel.warning => 'W',
    LogLevel.error => 'E',
    LogLevel.fatal => 'F',
  };
  
  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write('[${levelSymbol}] ${timestamp.toIso8601String()} - $message');
    if (error != null) {
      buffer.write(' | Error: $error');
    }
    return buffer.toString();
  }
}