extension ListExtensions<T> on List<T> {
  // Safe access
  T? get firstOrNull => isEmpty ? null : first;
  T? get lastOrNull => isEmpty ? null : last;
  T? getOrNull(int index) => (index >= 0 && index < length) ? this[index] : null;
  
  // Manipulation
  List<T> separated(T separator) {
    if (isEmpty) return this;
    
    final result = <T>[];
    for (int i = 0; i < length; i++) {
      result.add(this[i]);
      if (i < length - 1) {
        result.add(separator);
      }
    }
    return result;
  }
  
  List<T> unique() => toSet().toList();
  
  List<List<T>> chunk(int size) {
    final chunks = <List<T>>[];
    for (int i = 0; i < length; i += size) {
      final end = (i + size < length) ? i + size : length;
      chunks.add(sublist(i, end));
    }
    return chunks;
  }
  
  List<T> takeWhileIndexed(bool Function(int index, T element) test) {
    final result = <T>[];
    for (int i = 0; i < length; i++) {
      if (!test(i, this[i])) break;
      result.add(this[i]);
    }
    return result;
  }
  
  // Searching
  T? firstWhereOrNull(bool Function(T) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
  
  T? lastWhereOrNull(bool Function(T) test) {
    for (int i = length - 1; i >= 0; i--) {
      if (test(this[i])) return this[i];
    }
    return null;
  }
  
  int? indexWhereOrNull(bool Function(T) test, [int start = 0]) {
    final index = indexWhere(test, start);
    return index == -1 ? null : index;
  }
  
  // Grouping
  Map<K, List<T>> groupBy<K>(K Function(T) keySelector) {
    final map = <K, List<T>>{};
    for (final element in this) {
      final key = keySelector(element);
      map.putIfAbsent(key, () => []).add(element);
    }
    return map;
  }
  
  // Statistics (for numeric lists)
  num? sumBy(num Function(T) selector) {
    if (isEmpty) return null;
    return fold<num>(0, (sum, element) => sum + selector(element));
  }
  
  double? averageBy(num Function(T) selector) {
    if (isEmpty) return null;
    return sumBy(selector)! / length;
  }
  
  T? maxBy<R extends Comparable>(R Function(T) selector) {
    if (isEmpty) return null;
    return reduce((a, b) => selector(a).compareTo(selector(b)) > 0 ? a : b);
  }
  
  T? minBy<R extends Comparable>(R Function(T) selector) {
    if (isEmpty) return null;
    return reduce((a, b) => selector(a).compareTo(selector(b)) < 0 ? a : b);
  }
}

extension IterableExtensions<T> on Iterable<T> {
  // Safe access
  T? get firstOrNull => isEmpty ? null : first;
  T? get lastOrNull => isEmpty ? null : last;
  T? get singleOrNull => length == 1 ? first : null;
  
  // Manipulation
  Iterable<T> distinctBy<K>(K Function(T) selector) {
    final seen = <K>{};
    return where((element) => seen.add(selector(element)));
  }
  
  Iterable<R> mapIndexed<R>(R Function(int index, T element) transform) sync* {
    int index = 0;
    for (final element in this) {
      yield transform(index++, element);
    }
  }
  
  Iterable<T> whereIndexed(bool Function(int index, T element) test) sync* {
    int index = 0;
    for (final element in this) {
      if (test(index++, element)) yield element;
    }
  }
  
  // Conversion
  Map<K, V> toMap<K, V>({
    required K Function(T) key,
    required V Function(T) value,
  }) {
    return Map.fromEntries(
      map((e) => MapEntry(key(e), value(e))),
    );
  }
  
  String joinToString({
    String separator = ', ',
    String prefix = '',
    String suffix = '',
    String Function(T)? transform,
  }) {
    final buffer = StringBuffer(prefix);
    final iterator = this.iterator;
    
    if (iterator.moveNext()) {
      buffer.write(transform?.call(iterator.current) ?? iterator.current);
      while (iterator.moveNext()) {
        buffer.write(separator);
        buffer.write(transform?.call(iterator.current) ?? iterator.current);
      }
    }
    
    buffer.write(suffix);
    return buffer.toString();
  }
}

extension MapExtensions<K, V> on Map<K, V> {
  // Safe access
  V? getOrNull(K key) => this[key];
  
  V getOrElse(K key, V defaultValue) => this[key] ?? defaultValue;
  
  V getOrPut(K key, V Function() defaultValue) {
    return putIfAbsent(key, defaultValue);
  }
  
  // Manipulation
  Map<K, V> filter(bool Function(K key, V value) predicate) {
    return Map.fromEntries(
      entries.where((entry) => predicate(entry.key, entry.value)),
    );
  }
  
  Map<K2, V2> mapEntries<K2, V2>(
    MapEntry<K2, V2> Function(K key, V value) transform,
  ) {
    return map((key, value) => transform(key, value));
  }
  
  Map<K2, V> mapKeys<K2>(K2 Function(K key, V value) transform) {
    return Map.fromEntries(
      entries.map((e) => MapEntry(transform(e.key, e.value), e.value)),
    );
  }
  
  Map<K, V2> mapValues<V2>(V2 Function(K key, V value) transform) {
    return map((key, value) => MapEntry(key, transform(key, value)));
  }
  
  // Conversion
  List<T> toList<T>(T Function(K key, V value) transform) {
    return entries.map((e) => transform(e.key, e.value)).toList();
  }
}

extension SetExtensions<T> on Set<T> {
  // Safe operations
  bool addIfAbsent(T element) => add(element);
  
  bool removeIfPresent(T element) => remove(element);
  
  // Set operations
  Set<T> toggle(T element) {
    if (contains(element)) {
      remove(element);
    } else {
      add(element);
    }
    return this;
  }
  
  Set<T> symmetricDifference(Set<T> other) {
    return difference(other).union(other.difference(this));
  }
}