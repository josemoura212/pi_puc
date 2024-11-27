import 'package:asyncstate/asyncstate.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pi_puc/src/core/helpers/messages.dart';
import 'package:pi_puc/src/models/contact.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// Controller da tela Home
class HomeController with MessageStateMixin {
  /// inicialização tardia do banco de dados local
  late Isar _isar;

  /// sinal de lista de contatos
  final Signal<List<Contact>> _contactSignal = Signal([]);

  /// lista de contatos
  List<Contact> get contacts => _contactSignal.value;

  /// função para buscar todos os contatos
  Future<void> getAllContacts() async {
    _contactSignal.set(await _isar.contacts.where().findAll(), force: true);
  }

  /// função para adicionar e editar um contato
  Future<void> addAndEditContact(Contact contact) async {
    await _isar.writeTxn(() async {
      await _isar.contacts.put(contact);
    });
    await getAllContacts();
    showSuccess('Contato Salvo');
  }

  /// função para deletar um contato
  Future<void> deleteContact(Contact contact) async {
    await _isar.writeTxn(() async {
      await _isar.contacts.delete(contact.id!);
    });
    await getAllContacts();
    showSuccess('Contato Excluido');
  }

  /// função para inicializar o banco de dados local
  Future<void> initState() async {
    final dir = await getApplicationDocumentsDirectory();

    _isar = await Isar.open([ContactSchema], directory: dir.path);
  }

  /// função para mostrar informações de um contato
  Future<void> showInfoContact(Contact contact, BuildContext context) async {
    final size = MediaQuery.of(context).size;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(contact.name),
        content: SizedBox(
          width: size.width * 0.9,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Telefone: ${contact.phone}',
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'Email: ${contact.email}',
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () async {
              final result = await showDialog(
                  context: context,
                  builder: (_) {
                    /// Dialogo de confirmação de exclusão
                    return AlertDialog(
                      title: const Text('Confirmação'),
                      content: SizedBox(
                        width: size.width * 0.9,
                        child: const Text(
                            'Deseja realmente excluir este contato?'),
                      ),
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
                          child: Text("Cancelar"),
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
            child: const Text(
              'Excluir',
              style: TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () async {
              await Navigator.pushNamed(context, "/home/edit",
                  arguments: contact);
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text(
              'Editar',
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Fechar',
            ),
          ),
        ],
      ),
    );
  }
}
