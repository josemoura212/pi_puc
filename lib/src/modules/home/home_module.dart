import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:pi_puc/src/models/contact.dart';
import 'package:pi_puc/src/modules/home/home_controller.dart';
import 'package:pi_puc/src/modules/home/home_page.dart';
import 'package:pi_puc/src/modules/home/widgets/add_and_edit_contact_page.dart';

class HomeModule extends FlutterGetItModule {
  @override
  String get moduleRouteName => "/home";

  @override
  List<Bind<Object>> get bindings => [
        Bind.lazySingleton((i) => HomeController()),
      ];

  @override
  List<FlutterGetItPageRouter> get pages => [
        FlutterGetItPageRouter(
          name: "/",
          builder: (context) => const HomePage(),
        ),
        FlutterGetItPageRouter(
          name: "/edit",
          builder: (context) {
            final contact =
                ModalRoute.of(context)!.settings.arguments as Contact?;
            return AddAndEditContactPage(
              contact: contact,
            );
          },
        ),
      ];
}
