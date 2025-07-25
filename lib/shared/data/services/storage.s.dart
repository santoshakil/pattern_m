import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/di/injection.dart';
import '../../../core/logger/logger.s.dart';

part 'storage.s.g.dart';

@riverpod
StorageService storageService(Ref ref) {
  return StorageService(ref.watch(sharedPreferencesProvider));
}

class StorageService {
  final SharedPreferences _prefs;
  
  StorageService(this._prefs);
  
  // Keys
  static const String _keyPrefix = 'pattern_m_';
  static const String _themeKey = '${_keyPrefix}theme_mode';
  static const String _localeKey = '${_keyPrefix}locale';
  static const String _firstLaunchKey = '${_keyPrefix}first_launch';
  static const String _onboardingCompleteKey = '${_keyPrefix}onboarding_complete';
  static const String _userTokenKey = '${_keyPrefix}user_token';
  static const String _userIdKey = '${_keyPrefix}user_id';
  static const String _lastSyncKey = '${_keyPrefix}last_sync';
  
  // Theme
  String? getThemeMode() => _getString(_themeKey);
  Future<bool> setThemeMode(String mode) => _setString(_themeKey, mode);
  
  // Locale
  String? getLocale() => _getString(_localeKey);
  Future<bool> setLocale(String locale) => _setString(_localeKey, locale);
  
  // App state
  bool isFirstLaunch() => _getBool(_firstLaunchKey) ?? true;
  Future<bool> setFirstLaunch(bool value) => _setBool(_firstLaunchKey, value);
  
  bool isOnboardingComplete() => _getBool(_onboardingCompleteKey) ?? false;
  Future<bool> setOnboardingComplete(bool value) => _setBool(_onboardingCompleteKey, value);
  
  // Auth
  String? getUserToken() => _getString(_userTokenKey);
  Future<bool> setUserToken(String? token) {
    if (token == null) {
      return _remove(_userTokenKey);
    }
    return _setString(_userTokenKey, token);
  }
  
  String? getUserId() => _getString(_userIdKey);
  Future<bool> setUserId(String? id) {
    if (id == null) {
      return _remove(_userIdKey);
    }
    return _setString(_userIdKey, id);
  }
  
  // Sync
  DateTime? getLastSync() {
    final timestamp = _getInt(_lastSyncKey);
    return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
  }
  
  Future<bool> setLastSync(DateTime dateTime) {
    return _setInt(_lastSyncKey, dateTime.millisecondsSinceEpoch);
  }
  
  // Generic methods with error handling
  Future<bool> _setBool(String key, bool value) async {
    try {
      return await _prefs.setBool(key, value);
    } catch (e, s) {
      Logger.e('Failed to set bool: $key', error: e, stackTrace: s);
      return false;
    }
  }
  
  bool? _getBool(String key) {
    try {
      return _prefs.getBool(key);
    } catch (e, s) {
      Logger.e('Failed to get bool: $key', error: e, stackTrace: s);
      return null;
    }
  }
  
  Future<bool> _setString(String key, String value) async {
    try {
      return await _prefs.setString(key, value);
    } catch (e, s) {
      Logger.e('Failed to set string: $key', error: e, stackTrace: s);
      return false;
    }
  }
  
  String? _getString(String key) {
    try {
      return _prefs.getString(key);
    } catch (e, s) {
      Logger.e('Failed to get string: $key', error: e, stackTrace: s);
      return null;
    }
  }
  
  Future<bool> _setInt(String key, int value) async {
    try {
      return await _prefs.setInt(key, value);
    } catch (e, s) {
      Logger.e('Failed to set int: $key', error: e, stackTrace: s);
      return false;
    }
  }
  
  int? _getInt(String key) {
    try {
      return _prefs.getInt(key);
    } catch (e, s) {
      Logger.e('Failed to get int: $key', error: e, stackTrace: s);
      return null;
    }
  }
  
  Future<bool> _setDouble(String key, double value) async {
    try {
      return await _prefs.setDouble(key, value);
    } catch (e, s) {
      Logger.e('Failed to set double: $key', error: e, stackTrace: s);
      return false;
    }
  }
  
  double? _getDouble(String key) {
    try {
      return _prefs.getDouble(key);
    } catch (e, s) {
      Logger.e('Failed to get double: $key', error: e, stackTrace: s);
      return null;
    }
  }
  
  Future<bool> _setStringList(String key, List<String> value) async {
    try {
      return await _prefs.setStringList(key, value);
    } catch (e, s) {
      Logger.e('Failed to set string list: $key', error: e, stackTrace: s);
      return false;
    }
  }
  
  List<String>? _getStringList(String key) {
    try {
      return _prefs.getStringList(key);
    } catch (e, s) {
      Logger.e('Failed to get string list: $key', error: e, stackTrace: s);
      return null;
    }
  }
  
  Future<bool> _remove(String key) async {
    try {
      return await _prefs.remove(key);
    } catch (e, s) {
      Logger.e('Failed to remove: $key', error: e, stackTrace: s);
      return false;
    }
  }
  
  Future<bool> clear() async {
    try {
      return await _prefs.clear();
    } catch (e, s) {
      Logger.e('Failed to clear storage', error: e, stackTrace: s);
      return false;
    }
  }
  
  Future<bool> clearUserData() async {
    try {
      final keys = [_userTokenKey, _userIdKey];
      for (final key in keys) {
        await _remove(key);
      }
      return true;
    } catch (e, s) {
      Logger.e('Failed to clear user data', error: e, stackTrace: s);
      return false;
    }
  }
  
  // Custom object storage using JSON
  Future<bool> setObject(String key, Map<String, dynamic> object) async {
    try {
      final json = jsonEncode(object);
      return await _setString('${_keyPrefix}object_$key', json);
    } catch (e, s) {
      Logger.e('Failed to set object: $key', error: e, stackTrace: s);
      return false;
    }
  }
  
  Map<String, dynamic>? getObject(String key) {
    try {
      final json = _getString('${_keyPrefix}object_$key');
      if (json == null) return null;
      return jsonDecode(json) as Map<String, dynamic>;
    } catch (e, s) {
      Logger.e('Failed to get object: $key', error: e, stackTrace: s);
      return null;
    }
  }
}