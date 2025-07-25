import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/services/storage.s.dart';

part 'theme.p.g.dart';

@riverpod
class ThemeMode extends _$ThemeMode {
  @override
  ThemeMode build() {
    final storage = ref.watch(storageServiceProvider);
    final savedTheme = storage.getThemeMode();
    
    return switch (savedTheme) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }
  
  Future<void> setThemeMode(ThemeMode mode) async {
    final storage = ref.read(storageServiceProvider);
    
    final modeString = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    
    await storage.setThemeMode(modeString);
    state = mode;
  }
  
  void toggleTheme() {
    final newMode = switch (state) {
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.light,
      ThemeMode.system => ThemeMode.light,
    };
    
    setThemeMode(newMode);
  }
}