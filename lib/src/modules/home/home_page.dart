import 'package:asyncstate/asyncstate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:pi_puc/src/core/helpers/messages.dart';
import 'package:pi_puc/src/core/ui/theme_manager.dart';
import 'package:pi_puc/src/modules/home/home_controller.dart';
import 'package:signals_flutter/signals_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with MessageViewMixin {
  /// inicialização do controller
  final controller = Injector.get<HomeController>();

  /// instancia do tema
  final themeManager = Injector.get<ThemeManager>();

  @override
  void initState() {
    super.initState();

    /// adiciona o listener de mensagens
    messageListener(controller);

    /// inicializa o banco de dados local e busca todos os contatos
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.initState();
      await controller.getAllContacts().asyncLoader();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.getAllContacts().asyncLoader();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lista De Contatos'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.brightness_6),
              onPressed: () => themeManager.toggleTheme(),
            ),
          ],
        ),
        body: Watch(
          (_) => CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: const SizedBox(height: 30),
              ),
              SliverList.builder(
                itemCount: controller.contacts.length,
                itemBuilder: (_, index) {
                  final contact = controller.contacts[index];
                  return ListTile(
                    title: Text(contact.name),
                    subtitle: Text(contact.phone),
                    onTap: () => controller.showInfoContact(contact, context),
                  );
                },
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add',
          shape: CircleBorder(
            side: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/home/edit');
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
