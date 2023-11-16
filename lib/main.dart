import 'package:flutter/material.dart' show WidgetsFlutterBinding, runApp;
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;

import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderScope;

import 'src/app.dart' show MyApp;
import 'src/db/isar.dart' show openDB;

void main() async => await _init().then((_) => runApp(const ProviderScope(child: MyApp())));

Future<void> _init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await openDB();
}
