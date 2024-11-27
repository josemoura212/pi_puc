import 'package:flutter_getit/flutter_getit.dart';
import 'package:pi_puc/src/modules/home/home_page.dart';

class HomeModule extends FlutterGetItModule {
  @override
  String get moduleRouteName => "/home";

  @override
  List<FlutterGetItPageRouter> get pages => [
        FlutterGetItPageRouter(
          name: "/",
          builder: (context) => const HomePage(),
        ),
      ];
}
