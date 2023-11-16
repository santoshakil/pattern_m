import 'package:flutter/material.dart' show BuildContext, MaterialApp, MediaQuery, TextScaler, Widget;
import 'package:flutter_gen/gen_l10n/app_localizations.dart' show AppLocalizations;
import 'package:flutter_riverpod/flutter_riverpod.dart' show ConsumerWidget, WidgetRef;

import 'constants/constants.dart' show appName;
import 'extensions/extensions.dart' show BuildContextExtension;
import 'localization/loalization.dart' show localizationsDelegates, onGenerateTitle, supportedLocales, t;
import 'modules/router/view/router.dart' show AppRouter;
import 'theme/model/theme.model.dart' show ThemeProfileExtension;
import 'theme/provider/theme.provider.dart' show themeProvider;

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      localizationsDelegates: localizationsDelegates,
      theme: ref.watch(themeProvider).theme,
      supportedLocales: supportedLocales,
      debugShowCheckedModeBanner: false,
      onGenerateTitle: onGenerateTitle,
      restorationScopeId: appName,
      home: const AppRouter(),
      builder: (context, child) {
        t = AppLocalizations.of(context)!;
        return MediaQuery(
          data: context.mq.copyWith(textScaler: const TextScaler.linear(1)),
          child: child ?? const AppRouter(),
        );
      },
    );
  }
}
