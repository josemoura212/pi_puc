import 'package:asyncstate/asyncstate.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pi_puc/src/core/helpers/messages.dart';
import 'package:pi_puc/src/models/contact.dart';
import 'package:signals_flutter/signals_flutter.dart';

class HomeController with MessageStateMixin {
  late Isar _isar;
  final Signal<List<Contact>> _contactSignal = Signal([]);

  List<Contact> get contacts => _contactSignal.value;

  Future<void> getAllContacts() async {
    _contactSignal.set(await _isar.contacts.where().findAll(), force: true);
  }

  Future<void> addAndEditContact(Contact contact) async {
    await _isar.writeTxn(() async {
      await _isar.contacts.put(contact);
    });
    await getAllContacts();
    showSuccess('Contato adicionado');
  }

  Future<void> deleteContact(Contact contact) async {
    await _isar.writeTxn(() async {
      await _isar.contacts.delete(contact.id);
    });
    await getAllContacts();
    showSuccess('Contato removido');
  }

  Future<void> initState() async {
    final dir = await getApplicationDocumentsDirectory();

    _isar = await Isar.open([ContactSchema], directory: dir.path);
  }

  Future<void> showInfoContact(Contact contact, BuildContext context) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(contact.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Telefone: ${contact.phone}'),
            Text('Email: ${contact.email}'),
          ],
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () async {
              final result = await showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: const Text('Confirmação'),
                      content:
                          const Text('Deseja realmente excluir este contato?'),
                      actionsAlignment: MainAxisAlignment.spaceBetween,
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text(
                            "Excluir",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text("Editar"),
                        ),
                      ],
                    );
                  });
              if (result) {
                await deleteContact(contact).asyncLoader();
              }
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('Excluir'),
          ),
          TextButton(
            onPressed: () async {
              await Navigator.pushNamed(context, "/home/edit",
                  arguments: contact);
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('Editar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
}
