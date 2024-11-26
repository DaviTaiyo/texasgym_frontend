import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:texasgym_1/Controller/Usuario_controller.dart';
import 'package:texasgym_1/Model/Usuario_Model.dart';

class EditUserScreen extends StatefulWidget {
  final Usuario usuario;

  EditUserScreen({required this.usuario});

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final UsuarioController _usuarioController = UsuarioController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  bool _isProfessor = false;

  @override
  void initState() {
    super.initState();
    // Preenche os campos com os dados do usuário
    _nameController.text = widget.usuario.nome ?? '';
    _emailController.text = widget.usuario.email;
    _phoneController.text = widget.usuario.telefone ?? '';
    _cpfController.text = widget.usuario.cpf ?? '';
    _isProfessor = widget.usuario.professor;
  }

  Future<void> _updateUser() async {
    final updatedUser = Usuario(
      id: widget.usuario.id,
      nome: _nameController.text,
      email: _emailController.text,
      telefone: _phoneController.text,
      cpf: _cpfController.text,
      professor: _isProfessor,
    );

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      if (token == null) {
        throw Exception('Token JWT não encontrado.');
      }

      final success = await _usuarioController.atualizarUsuario(
        name: updatedUser.nome!,
        phone: updatedUser.telefone!,
        email: updatedUser.email,
        cpf: updatedUser.cpf!,
        birthDate: widget.usuario.dataNascimento ?? DateTime.now(),
        userId: updatedUser.id!,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuário atualizado com sucesso!')),
        );
        Navigator.pop(context); // Retorna à tela anterior
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar usuário.')),
        );
      }
    } catch (e) {
      print('Erro ao atualizar usuário: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar usuário: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Usuário'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'E-mail'),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Telefone'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: _cpfController,
              decoration: InputDecoration(labelText: 'CPF'),
              keyboardType: TextInputType.number,
            ),
            SwitchListTile(
              title: Text('Professor'),
              value: _isProfessor,
              onChanged: (value) {
                setState(() {
                  _isProfessor = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateUser,
              child: Text('Salvar Alterações'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
