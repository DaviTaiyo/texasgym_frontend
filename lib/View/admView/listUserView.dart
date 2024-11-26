import 'package:flutter/material.dart';
import 'package:texasgym_1/Controller/Usuario_controller.dart';
import 'package:texasgym_1/Model/Usuario_Model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:texasgym_1/View/admView/EditOptionView.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final UsuarioController _usuarioController = UsuarioController();
  late Future<List<Usuario>> _usuariosFuture;

  @override
  void initState() {
    super.initState();
    _usuariosFuture = _fetchUsuarios();
  }

  Future<List<Usuario>> _fetchUsuarios() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      if (token == null) {
        throw Exception('Token JWT não encontrado. Por favor, faça login novamente.');
      }

      final usuarios = await _usuarioController.listarUsuarios(token);
      return usuarios ?? [];
    } catch (e) {
      print('Erro ao buscar usuários: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Usuários'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Usuario>>(
          future: _usuariosFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Erro ao carregar os usuários: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text('Nenhum usuário encontrado.'),
              );
            }

            final usuarios = snapshot.data!;
            return ListView.builder(
              itemCount: usuarios.length,
              itemBuilder: (context, index) {
                final usuario = usuarios[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(usuario.nome ?? 'Nome não disponível'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('E-mail: ${usuario.email}'),
                        Text('Telefone: ${usuario.telefone ?? 'Não especificado'}'),
                        Text('Professor: ${usuario.professor ? 'Sim' : 'Não'}'),
                      ],
                    ),
                    trailing: Icon(Icons.edit),
                    onTap: () {
                      // Navegar para a tela de opções ao selecionar um usuário
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditOptionsScreen(usuario: usuario),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
