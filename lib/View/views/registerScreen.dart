import 'package:flutter/material.dart';
import 'package:texasgym_1/Controller/Usuario_controller.dart';
import 'package:texasgym_1/Model/Usuario_Model.dart';
import 'package:texasgym_1/View/views/loginScreen.dart';
import 'package:texasgym_1/View/views/termsServiceScreen.dart';
import 'package:intl/intl.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final UsuarioController _usuarioController = UsuarioController();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController dataNascimentoController =
      TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isProfessor = false;
  bool isAdministrador = false;
  bool isChecked = false;

  Future<void> _registrarUsuario() async {
  if (!isChecked) {
    _mostrarDialogo('Termos de Serviço', 'Você deve aceitar os termos de serviço para se cadastrar.');
    return;
  }

  if (passwordController.text != confirmPasswordController.text) {
    _mostrarDialogo('Erro', 'As senhas não coincidem.');
    return;
  }

  Usuario novoUsuario = Usuario(
    nome: nomeController.text,
    email: emailController.text,
    cpf: cpfController.text,
    telefone: telefoneController.text,
    dataNascimento: dataNascimentoController.text.isNotEmpty
        ? DateFormat("dd/MM/yyyy").parse(dataNascimentoController.text)
        : null,
    senha: passwordController.text,
  );

  String? resultado = await _usuarioController.registrarUsuario(novoUsuario);

  if (resultado == "sucesso") {
    // Exibe mensagem de sucesso e navega para a página de login após o usuário confirmar
    _mostrarDialogo("Sucesso", "Usuário registrado com sucesso!", onOkPressed: () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  } else {
    // Exibe o erro retornado pelo controlador
    _mostrarDialogo("Alerta", resultado ?? 'Falha ao registrar o usuário.');
  }
}


  void _mostrarDialogo(String titulo, String conteudo, {VoidCallback? onOkPressed}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(titulo),
      content: Text(conteudo),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            if (onOkPressed != null) {
              onOkPressed();
            }
          },
          child: Text('OK'),
        ),
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'TexasGym',
                  style: TextStyle(
                    fontSize: 36,
                    color: Colors.lightBlueAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 30),
              TextField(
                controller: nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome completo',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),
              TextField(
                controller: dataNascimentoController,
                decoration: InputDecoration(
                  labelText: 'Data de Nascimento',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      dataNascimentoController.text =
                          DateFormat('dd/MM/yyyy').format(pickedDate);
                    });
                  }
                },
              ),
              SizedBox(height: 20),
              TextField(
                controller: cpfController,
                decoration: InputDecoration(
                  labelText: 'CPF',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.credit_card),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              TextField(
                controller: telefoneController,
                decoration: InputDecoration(
                  labelText: 'Telefone',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              TextField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirmar Senha',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value!;
                      });
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TermsOfServiceScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Aceitar os Termos de Serviço',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _registrarUsuario();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    child: Text(
                      'Cadastrar',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
