import 'dart:developer';

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

  Future<List<Contact>> getAllContacts() async {
    log('getAllContacts');
    final contacts = await _isar.contacts.where().findAll();
    log('contacts: $contacts');
    _contactSignal.set(contacts, force: true);
    return contacts;
  }

  Future<void> addContact(Contact contact) async {
    await _isar.writeTxn(() async {
      await _isar.contacts.put(contact);
    });
    _contactSignal.set(_contactSignal.value..add(contact), force: true);
    showSuccess('Contato adicionado');
  }

  Future<void> deleteContact(Contact contact) async {
    await _isar.writeTxn(() async {
      await _isar.contacts.delete(contact.id);
    });
    _contactSignal.set(_contactSignal.value..remove(contact), force: true);
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
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
          TextButton(
            onPressed: () async {
              final result = await showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: const Text('Confirmação'),
                      content:
                          const Text('Deseja realmente excluir este contato?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text("Cancelar"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text("Excluir"),
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
        ],
      ),
    );
  }
}
