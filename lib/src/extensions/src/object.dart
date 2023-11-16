part of '../extensions.dart';

extension ObjectExt on Object? {
  T? asT<T>() => this is T ? this as T : null;

  bool isType<T>() => this is T;
  bool isNotType<T>() => this is! T;
  bool get isNull => this == null;
  bool get isBool => this is bool;
  bool get isNotBool => this is! bool;
  bool get isInt => this is int;
  bool get isNotInt => this is! int;
  bool get isDouble => this is double;
  bool get isNotDouble => this is! double;
  bool get isNum => this is num;
  bool get isNotNum => this is! num;
  bool get isString => this is String;
  bool get isNotString => this is! String;
  bool get isList => this is List;
  bool get isNotList => this is! List;
  bool get isEmptyList => this is List && (this as List).isEmpty;
  bool get isMap => this is Map;
  bool get isNotMap => this is! Map;
  bool get isEmptyMap => this is Map && (this as Map).isEmpty;
  bool get isSet => this is Set;
  bool get isNotSet => this is! Set;
  bool get isEmptySet => this is Set && (this as Set).isEmpty;
  bool get isIterable => this is Iterable;
  bool get isNotIterable => this is! Iterable;
  bool get isEmptyIterable => this is Iterable && (this as Iterable).isEmpty;
  bool get isDateTime => this is DateTime;
  bool get isNotDateTime => this is! DateTime;

  T? encode<T>() {
    try {
      return _v?.fromJson();
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  get _v => this;
}

void testObjectExt() {
  late final Test? test;
  test = const Test();
  debugPrint(test.encode<Test>().toString());
}

class Test {
  const Test();
  factory Test.fromRawJson(String str) => const Test();
  factory Test.fromJson(Map<String, dynamic> json) => const Test();
  Map<String, dynamic> toRawJson() => {};
  Map<String, dynamic> toJson() => {};
}
