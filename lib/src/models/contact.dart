import 'package:isar/isar.dart';

part "contact.g.dart";

@collection
class Contact {
  Id id = Isar.autoIncrement;

  String name;
  String phone;
  String email;
  Contact({
    required this.name,
    required this.phone,
    required this.email,
  });
}
