import 'package:flutter/material.dart' show BuildContext, Widget;

import 'package:flutter_riverpod/flutter_riverpod.dart' show ConsumerWidget, WidgetRef;

import '../../home/view/home.view.dart' show HomeView;

class AppRouter extends ConsumerWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const HomeView();
  }
}
