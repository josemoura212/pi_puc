import 'package:isar/isar.dart';

part "contact.g.dart";

/// Classe que representa um contato.
@collection
class Contact {
  Id? id = Isar.autoIncrement;

  String name;
  String phone;
  String email;
  Contact({
    this.id,
    required this.name,
    required this.phone,
    required this.email,
  });
}
