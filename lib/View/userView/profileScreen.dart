import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:texasgym_1/View/userView/EditProfileScreen.dart';
import 'dart:io';
import 'package:texasgym_1/View/userView/Medidas_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String name;
  final String phone;
  final String email;
  final String cpf;
  final DateTime birthDate; // Alterado para usar a data de nascimento
  final File? profileImage;
  final int userId;

  ProfileScreen({
    required this.name,
    required this.phone,
    required this.email,
    required this.cpf,
    required this.birthDate, // Usando a data de nascimento diretamente
    required this.profileImage,
    required this.userId,
  });

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String name;
  late String phone;
  late String cpf;
  late String email;
  late DateTime birthDate; // Alterado para armazenar a data de nascimento
  late File? profileImage;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    name = widget.name;
    phone = widget.phone;
    email = widget.email;
    cpf = widget.cpf;
    birthDate = widget.birthDate;
    profileImage = widget.profileImage;
  }

  int _calculateAge(DateTime birthDate) {
    final currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month && currentDate.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: profileImage != null
                        ? FileImage(profileImage!)
                        : AssetImage('assets/default_avatar.png')
                            as ImageProvider,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Nome'),
              subtitle: Text(name),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Telefone'),
              subtitle: Text(phone),
            ),
            ListTile(
              leading: Icon(Icons.document_scanner),
              title: Text('CPF'),
              subtitle: Text(cpf),
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Email'),
              subtitle: Text(email),
            ),
            ListTile(
              leading: Icon(Icons.cake),
              title: Text('Idade'),
              subtitle: Text('${_calculateAge(birthDate)} anos'),
            ),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.blue,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        spacing: 10,
        spaceBetweenChildren: 10,
        children: [
          SpeedDialChild(
            child: Icon(Icons.dashboard),
            label: "Medidas",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MedidasScreen(userId: widget.userId),
                ),
              );
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.edit),
            label: 'Editar Perfil',
            onTap: () async {
              final updatedData = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(
                    userId: widget.userId, // Passa o ID do usuário
                    name: name,
                    cpf: cpf,
                    phone: phone,
                    email: email,
                    birthDate: birthDate, // Passa a data de nascimento para edição
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
