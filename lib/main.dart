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
  /// Garantir que o bindind dos widgets seja inicializado antes de qualquer codigo
  WidgetsFlutterBinding.ensureInitialized();

  /// inicia o isar (banco de dados local)
  Isar.initializeIsarCore();
  runApp(
    const PiPuc(),
  );
}

class PiPuc extends StatelessWidget {
  const PiPuc({super.key});

  @override
  Widget build(BuildContext context) {
    /// FlutterGetIt Gerenciador de dependencias
    return FlutterGetIt(
      /// Dependencias inicias do applicativo
      bindings: PiPucApplicationBindings(),
      modules: [
        /// Modulos do app
        HomeModule(),
      ],
      builder: (context, routes, isReady) {
        /// inicializa o theme data salvo localmente usando o sharedpreferences
        final themeManager = Injector.get<ThemeManager>()..getDarkMode();

        /// asyncstate gerenciamento de loader para requisiçoes assincronas
        return asyncstate.AsyncStateBuilder(
          /// loader personalizado
          loader: PiPucLoader(),
          builder: (asyncNavigatorObserver) {
            /// Widget de atualização de estado usando o SignalsFlutter
            return Watch(
              /// inicialização principal do app
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
                    themeManager.isDarkMode ? ThemeMode.dark : ThemeMode.light,
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
