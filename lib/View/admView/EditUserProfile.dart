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
  final _formKey = GlobalKey<FormState>();
  final UsuarioController _usuarioController = UsuarioController();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _cpfController;
  bool _isProfessor = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.usuario.nome ?? '');
    _emailController = TextEditingController(text: widget.usuario.email);
    _phoneController = TextEditingController(text: widget.usuario.telefone ?? '');
    _cpfController = TextEditingController(text: widget.usuario.cpf ?? '');
    _isProfessor = widget.usuario.professor;
  }

  Future<void> _updateUser() async {
    if (_formKey.currentState!.validate()) {
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
          throw Exception('Erro ao atualizar o usuário.');
        }
      } catch (e) {
        print('Erro ao atualizar usuário: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar usuário: $e')),
        );
      }
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
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildInputField(
                controller: _nameController,
                label: "Nome",
                icon: Icons.person,
                keyboardType: TextInputType.text,
                validatorMessage: "Informe o nome",
              ),
              _buildInputField(
                controller: _cpfController,
                label: "CPF",
                icon: Icons.document_scanner,
                keyboardType: TextInputType.number,
                validatorMessage: "Informe o CPF",
              ),
              _buildInputField(
                controller: _phoneController,
                label: "Telefone",
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                validatorMessage: "Informe o telefone",
              ),
              _buildInputField(
                controller: _emailController,
                label: "Email",
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validatorMessage: "Informe o email",
              ),
              _buildSwitchField(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  textStyle: TextStyle(fontSize: 16),
                ),
                child: Text("Salvar Alterações"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required TextInputType keyboardType,
    required String validatorMessage,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 30, color: Colors.blue),
          SizedBox(width: 16),
          Expanded(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                labelText: label,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: keyboardType,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return validatorMessage;
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(Icons.school, size: 30, color: Colors.blue),
          SizedBox(width: 16),
          Expanded(
            child: SwitchListTile(
              title: Text('Professor'),
              value: _isProfessor,
              onChanged: (value) {
                setState(() {
                  _isProfessor = value;
                });
              },
              activeColor: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
