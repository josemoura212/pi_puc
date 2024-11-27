import 'package:asyncstate/asyncstate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pi_puc/src/models/contact.dart';
import 'package:pi_puc/src/modules/home/home_controller.dart';
import 'package:validatorless/validatorless.dart';

/// Pagina de adicionar e editar contato
class AddAndEditContactPage extends StatefulWidget {
  const AddAndEditContactPage({super.key, this.contact});

  /// contato a ser editado
  final Contact? contact;

  @override
  State<AddAndEditContactPage> createState() => _AddAndEditContactPageState();
}

class _AddAndEditContactPageState extends State<AddAndEditContactPage> {
  /// inicialização do controller
  final controller = Injector.get<HomeController>();

  /// chave do formulario
  final _formKey = GlobalKey<FormState>();

  /// controlador do campo de nome
  final _nameEC = TextEditingController();
  final _phoneEC = TextEditingController();
  final _emailEC = TextEditingController();

  @override
  void initState() {
    /// preencher os campos com os dados do contato
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
    final size = MediaQuery.of(context).size;

    /// função para adicionar e editar um contato
    Future<void> onSubmitted() async {
      if (_formKey.currentState!.validate()) {
        await controller
            .addAndEditContact(Contact(
              id: contact?.id,
              name: _nameEC.text,
              phone: _phoneEC.text,
              email: _emailEC.text,
            ))
            .asyncLoader();
        if (context.mounted) {
          Navigator.pop(context);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        /// operação ternaria para mudar o titulo da pagina
        title: Text(contact == null ? 'Adicionar Contato' : 'Editar Contato'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: SizedBox(
              height: size.height -
                  kToolbarHeight -
                  MediaQuery.of(context).padding.top,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 45),

                  /// TextFormFields para preencher o nome do contato
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Nome'),
                    controller: _nameEC,

                    /// ação ao clicar fora do campo
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),

                    /// ação do teclado ao perta ok
                    textInputAction: TextInputAction.next,

                    /// validação do campo
                    validator: Validatorless.multiple([
                      Validatorless.required('Campo obrigatório'),
                      Validatorless.min(3, 'Nome muito curto'),
                    ]),
                  ),
                  const SizedBox(height: 20),

                  /// TextFormFields para preencher o telefone do contato
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Telefone'),
                    controller: _phoneEC,

                    /// ação ao clicar fora do campo
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),

                    /// ação do teclado ao perta ok
                    textInputAction: TextInputAction.next,

                    /// validação do campo
                    validator: Validatorless.multiple([
                      Validatorless.required('Campo obrigatório'),
                      Validatorless.min(8, 'Telefone muito curto'),
                    ]),

                    /// Máscara para o campo de telefone
                    inputFormatters: [
                      /// Filtra apenas digitos
                      FilteringTextInputFormatter.digitsOnly,
                      MaskTextInputFormatter(
                        mask: '(##) # ####-####',
                        filter: {"#": RegExp(r'[0-9]')},
                      )
                    ],
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    controller: _emailEC,

                    /// ação ao clicar fora do campo
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),

                    /// ação do teclado ao perta ok
                    onFieldSubmitted: (_) => onSubmitted(),
                    textInputAction: TextInputAction.done,

                    /// tipo de teclado
                    keyboardType: TextInputType.emailAddress,

                    /// validação do campo
                    validator: Validatorless.multiple([
                      Validatorless.required('Campo obrigatório'),
                      Validatorless.email('Email inválido'),
                    ]),
                  ),
                  Spacer(),

                  /// Botão para adicionar a função de adicionar e editar um contato
                  ElevatedButton(
                    onPressed: () => onSubmitted(),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 45),
                    ),

                    /// operação ternaria para mudar o texto do botão
                    child: Text(contact == null ? 'Adicionar' : 'Editar'),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
