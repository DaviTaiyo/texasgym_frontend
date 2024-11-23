import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:texasgym_1/Controller/Usuario_controller.dart';

class EditProfileScreen extends StatefulWidget {
  final String name;
  final String phone;
  final String cpf;
  final String email;
  final DateTime birthDate; // Ajustado para usar DateTime
  final int userId; // Adicionado ID do usuário

  EditProfileScreen({
    required this.name,
    required this.phone,
    required this.email,
    required this.cpf,
    required this.birthDate,
    required this.userId, // Recebe o ID do usuário
  });

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final UsuarioController _usuarioController = UsuarioController();

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController cpfController;
  late TextEditingController emailController;
  late TextEditingController birthDateController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    phoneController = TextEditingController(text: widget.phone);
    emailController = TextEditingController(text: widget.email);
    cpfController = TextEditingController(text: widget.cpf);
    birthDateController = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(widget.birthDate),
    );
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Converte a data do campo de texto para DateTime
        final DateTime birthDate =
            DateFormat('dd/MM/yyyy').parse(birthDateController.text);

        // Atualiza o perfil do usuário
        final updated = await _usuarioController.atualizarUsuario(
          name: nameController.text,
          phone: phoneController.text,
          cpf: cpfController.text,
          email: emailController.text,
          birthDate: birthDate,
          userId: widget.userId, // Passa o ID do usuário
        );

        if (updated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Perfil atualizado com sucesso!')),
          );
          Navigator.pop(context, {
            'name': nameController.text,
            'phone': phoneController.text,
            'cpf': cpfController.text,
            'email': emailController.text,
            'birthDate': birthDate,
          });
        } else {
          throw Exception('Erro ao atualizar o perfil.');
        }
      } catch (e) {
        print('Erro: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar o perfil.')),
        );
      }
    }
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        birthDateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Perfil'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildInputField(
                controller: nameController,
                label: "Nome",
                icon: Icons.person,
                keyboardType: TextInputType.text,
                validatorMessage: "Informe o nome",
              ),
              _buildInputField(
                  controller: cpfController,
                  label: "CPF",
                  icon: Icons.document_scanner,
                  keyboardType: TextInputType.number,
                  validatorMessage: "Informe o CPF"),
              _buildInputField(
                controller: phoneController,
                label: "Telefone",
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                validatorMessage: "Informe o telefone",
              ),
              _buildInputField(
                controller: emailController,
                label: "Email",
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validatorMessage: "Informe o email",
              ),
              _buildDateField(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateProfile,
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

  Widget _buildDateField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(Icons.calendar_today, size: 30, color: Colors.blue),
          SizedBox(width: 16),
          Expanded(
            child: TextFormField(
              controller: birthDateController,
              decoration: InputDecoration(
                labelText: "Data de Nascimento",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              readOnly: true,
              onTap: _pickDate,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Informe a data de nascimento';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
