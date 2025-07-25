import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/services/storage.s.dart';

part 'auth.p.g.dart';

@riverpod
class AuthState extends _$AuthState implements ChangeNotifier {
  final List<VoidCallback> _listeners = [];
  
  @override
  bool? build() {
    final storage = ref.watch(storageServiceProvider);
    final token = storage.getUserToken();
    return token != null;
  }
  
  Future<void> login(String token, String userId) async {
    final storage = ref.read(storageServiceProvider);
    await storage.setUserToken(token);
    await storage.setUserId(userId);
    state = true;
    notifyListeners();
  }
  
  Future<void> logout() async {
    final storage = ref.read(storageServiceProvider);
    await storage.clearUserData();
    state = false;
    notifyListeners();
  }
  
  @override
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }
  
  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }
  
  @override
  void notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }
  
  @override
  void dispose() {
    _listeners.clear();
    super.dispose();
  }
}