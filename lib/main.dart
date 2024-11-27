import 'package:flutter/material.dart';
import 'package:asyncstate/asyncstate.dart' as asyncstate;
import 'package:flutter_getit/flutter_getit.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:isar/isar.dart';
import 'package:pi_puc/src/core/bindings/pi_puc_application_bindings.dart';
import 'package:pi_puc/src/core/ui/loader.dart';
import 'package:pi_puc/src/core/ui/theme_manager.dart';
import 'package:pi_puc/src/core/ui/ui_config.dart';
import 'package:pi_puc/src/modules/home/home_module.dart';
import 'package:signals_flutter/signals_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Isar.initializeIsarCore();
  runApp(
    const PiPuc(),
  );
}

class PiPuc extends StatelessWidget {
  const PiPuc({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterGetIt(
      bindings: PiPucApplicationBindings(),
      modules: [
        HomeModule(),
      ],
      builder: (context, routes, isReady) {
        final themeManager = Injector.get<ThemeManager>()..getDarkMode();
        return asyncstate.AsyncStateBuilder(
          loader: PiPucLoader(),
          builder: (asyncNavigatorObserver) {
            return Watch(
              (_) => MaterialApp(
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('pt', 'BR'),
                ],
                debugShowCheckedModeBanner: false,
                title: 'PiPuc',
                theme: UiConfig.lightTheme,
                darkTheme: UiConfig.darkTheme,
                themeMode:
                    themeManager.isDarkMode ? ThemeMode.light : ThemeMode.light,
                navigatorObservers: [
                  asyncNavigatorObserver,
                ],
                routes: routes,
                initialRoute: "/home/",
              ),
            );
          },
        );
      },
    );
  }
}
