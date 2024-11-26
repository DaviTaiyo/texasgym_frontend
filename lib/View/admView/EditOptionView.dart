import 'package:flutter/material.dart';
import 'package:texasgym_1/Model/Usuario_Model.dart';
import 'package:texasgym_1/View/TreinoView/FichaDeTreino.dart';
import 'package:texasgym_1/View/admView/EditUserProfile.dart';
import 'package:texasgym_1/View/fichaView/FichaView.dart';

class EditOptionsScreen extends StatelessWidget {
  final Usuario usuario;

  EditOptionsScreen({required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Usuário: ${usuario.nome}'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selecione uma opção para editar:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Editar Perfil do Usuário'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditUserScreen(usuario: usuario),
                  ),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.fitness_center),
              title: Text('Editar Treinos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FichaTreinoScreen(
                      userId: usuario.id!,
                      name: usuario.nome!,
                      phone: usuario.telefone!,
                      email: usuario.email!,
                      cpf: usuario.cpf!,
                    ),
                  ),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.note),
              title: Text('Editar Fichas'),
              onTap: () {
                Navigator.push(
                  context, MaterialPageRoute(
                    builder: (context) => UserFichasScreen(
                      userId: usuario.id!,
                      name: usuario.nome!,
                      phone: usuario.telefone!,
                      email: usuario.email!,
                      cpf: usuario.cpf!,
                    ),
                  ),
                  
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
