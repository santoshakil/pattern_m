import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/logger/logger.s.dart';

part 'home.p.g.dart';

@riverpod
class Counter extends _$Counter {
  @override
  int build() {
    Logger.d('Counter provider initialized');
    return 0;
  }
  
  void increment() {
    state++;
    Logger.d('Counter incremented to $state');
  }
  
  void decrement() {
    state--;
    Logger.d('Counter decremented to $state');
  }
  
  void reset() {
    state = 0;
    Logger.d('Counter reset');
  }
  
  void setValue(int value) {
    state = value;
    Logger.d('Counter set to $state');
  }
}