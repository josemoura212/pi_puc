import 'package:asyncstate/asyncstate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:pi_puc/src/models/contact.dart';
import 'package:pi_puc/src/modules/home/home_controller.dart';

class AddAndEditContactPage extends StatefulWidget {
  const AddAndEditContactPage({super.key, this.contact});
  final Contact? contact;

  @override
  State<AddAndEditContactPage> createState() => _AddAndEditContactPageState();
}

class _AddAndEditContactPageState extends State<AddAndEditContactPage> {
  final controller = Injector.get<HomeController>();

  final _formKey = GlobalKey<FormState>();
  final _nameEC = TextEditingController();
  final _phoneEC = TextEditingController();
  final _emailEC = TextEditingController();

  @override
  void initState() {
    if (widget.contact != null) {
      _nameEC.text = widget.contact!.name;
      _phoneEC.text = widget.contact!.phone;
      _emailEC.text = widget.contact!.email;
    }
    super.initState();
  }

  @override
  void dispose() {
    _nameEC.dispose();
    _phoneEC.dispose();
    _emailEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contact = widget.contact;
    return Scaffold(
      appBar: AppBar(
        title: Text(contact == null ? 'Adicionar Contato' : 'Editar Contato'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 45),
              TextField(
                decoration: const InputDecoration(labelText: 'Nome'),
                controller: _nameEC,
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: const InputDecoration(labelText: 'Telefone'),
                controller: _phoneEC,
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: const InputDecoration(labelText: 'Email'),
                controller: _emailEC,
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await controller
                        .addAndEditContact(Contact(
                          name: _nameEC.text,
                          phone: _phoneEC.text,
                          email: _emailEC.text,
                        ))
                        .asyncLoader();
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 45),
                ),
                child: const Text('Adicionar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
