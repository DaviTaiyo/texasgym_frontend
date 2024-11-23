import 'package:flutter/material.dart';
import 'package:texasgym_1/Controller/Usuario_controller.dart';
import 'package:texasgym_1/View/userView/homePageScreen.dart';
import 'package:texasgym_1/View/admView/admHomePageScreen.dart';
import 'package:texasgym_1/View/views/registerScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final UsuarioController _usuarioController = UsuarioController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true;

  Future<void> _login() async {

    String email = emailController.text;
    String password = passwordController.text;

    String? token = await _usuarioController.login(email, password);

    if (token != null) {
      // Verifique se o usuário é administrador, faça isso com uma função que pega o valor do token JWT decodificado.
      bool isAdmin = await _verificarAdministrador(token);
      if (isAdmin) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminHomePageScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePageScreen()),
        );
      }
    } else {
      // Exibe um diálogo de erro em caso de falha no login
      _mostrarDialogo('Erro de Login', 'E-mail ou senha inválidos.');
    }
  }

  Future<bool> _verificarAdministrador(String token) async {
    // Aqui você decodifica o token JWT para verificar se o campo administrador é verdadeiro.
    // Adicione lógica para verificar o payload do token (se já estiver incluído o valor administrador).
    // Vamos simplificar isso no momento.
    return false; // Ajuste isso conforme a necessidade do seu sistema
  }

  void _mostrarDialogo(String titulo, String conteudo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(titulo),
        content: Text(conteudo),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
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
        title: Text('Login'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              Text(
                'TexasGym',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightBlue,
                ),
              ),
              SizedBox(height: 30),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                  ),
                ),
                obscureText: obscurePassword,
              ),
              SizedBox(height: 10),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                  );
                },
                child: Text(
                  'Cadastre-se',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
