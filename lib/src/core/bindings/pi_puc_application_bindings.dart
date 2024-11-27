import 'package:flutter_getit/flutter_getit.dart';
import 'package:pi_puc/src/core/local_storage/local_storage.dart';
import 'package:pi_puc/src/core/local_storage/local_storage_impl.dart';
import 'package:pi_puc/src/core/ui/theme_manager.dart';

class PiPucApplicationBindings extends ApplicationBindings {
  @override
  List<Bind<Object>> bindings() => [
        Bind.lazySingleton<ThemeManager>(
          (i) => ThemeManager(
            initialDarkMode: true,
            localStorage: i(),
          ),
        ),
        Bind.lazySingleton<LocalStorage>(
          (i) => SharedPreferenceImpl(),
        ),
      ];
}
