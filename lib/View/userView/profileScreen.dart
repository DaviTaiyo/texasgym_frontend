import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:texasgym_1/Model/Usuario_Model.dart';
import 'package:texasgym_1/View/userView/EditProfileScreen.dart';
import 'package:texasgym_1/View/MedidasView/Medidas_screen.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  final String name;
  final String phone;
  final String email;
  final String cpf;
  final DateTime birthDate;
  final File? profileImage;
  final int userId;
  final bool professor;

  ProfileScreen({
    required this.name,
    required this.phone,
    required this.email,
    required this.cpf,
    required this.birthDate,
    required this.profileImage,
    required this.userId,
    required this.professor,
  });

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String name;
  late String phone;
  late String cpf;
  late String email;
  late DateTime birthDate;
  late File? profileImage;
  late bool professor;

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
    professor = widget.professor;
  }

  int _calculateAge(DateTime birthDate) {
    final currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month &&
            currentDate.day < birthDate.day)) {
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
            ListTile(
              leading: Icon(Icons.school),
              title: Text('Professor'),
              subtitle: Text(professor ? 'Sim' : 'Não'),
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
                  builder: (context) => EditUserScreen(
                    usuario: Usuario(
                      id: widget.userId,
                      nome: name,
                      telefone: phone,
                      email: email,
                      cpf: cpf,
                      dataNascimento: birthDate,
                      professor: professor,
                    ),
                  ),
                ),
              );
              if (updatedData != null) {
                setState(() {
                  name = updatedData['name'];
                  phone = updatedData['phone'];
                  cpf = updatedData['cpf'];
                  email = updatedData['email'];
                  birthDate = updatedData['birthDate'];
                  professor = updatedData['professor'];
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
