import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared/data/services/storage.s.dart';
import '../logger/logger.s.dart';

abstract class DI {
  static late SharedPreferences _prefs;
  
  static List<Override> get providerOverrides => [
    sharedPreferencesProvider.overrideWithValue(_prefs),
  ];
  
  static Future<void> init() async {
    Logger.d('Initializing dependency injection');
    
    // Initialize SharedPreferences
    _prefs = await SharedPreferences.getInstance();
    Logger.d('SharedPreferences initialized');
    
    // Initialize other dependencies here
    // e.g., database, API clients, etc.
  }
}

// Global providers
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences not initialized');
});