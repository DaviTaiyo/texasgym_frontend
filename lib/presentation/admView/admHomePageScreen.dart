import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:texasgym_1/presentation/admView/paymentManagerScreen.dart';
import 'package:texasgym_1/presentation/admView/userManageScreen.dart';
import 'package:texasgym_1/presentation/configView/settingsScreen.dart';
import 'dart:io';
import 'package:texasgym_1/presentation/userView/profileScreen.dart';
import 'package:texasgym_1/presentation/admView/workoutManagerScreen.dart';
import 'package:texasgym_1/presentation/views/loginScreen.dart';

class AdminHomePageScreen extends StatefulWidget {
  @override
  _AdminHomePageScreenState createState() => _AdminHomePageScreenState();
}

class _AdminHomePageScreenState extends State<AdminHomePageScreen> {
  String userName = 'Adm';
  String userEmail = 'adm@gmail.com';
  File? userProfileImage;

  Future<void> _navigateToProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(
          name: userName,
          phone: '123-456-7890',
          email: userEmail,
          age: 25,
          height: 1.75,
          weight: 70.0,
          profileImage: userProfileImage,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        userName = result['name'];
        userEmail = result['email'];
        userProfileImage = result['profileImage'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Administração TexasGym'),
        backgroundColor: Color(0xFF007BFF),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(userName),
              accountEmail: Text(userEmail),
              currentAccountPicture: CircleAvatar(
                backgroundImage: userProfileImage != null
                    ? FileImage(userProfileImage!)
                    : AssetImage('assets/default_avatar.png') as ImageProvider,
                child: userProfileImage == null ? Text(userName[0]) : null,
              ),
              decoration: BoxDecoration(
                color: Color(0xFF007BFF),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person, color: Colors.black),
              title: Text('Perfil'),
              onTap: _navigateToProfile,
            ),
            ListTile(
              leading: Icon(Icons.payment, color: Colors.black),
              title: Text('Gerenciar Pagamentos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaymentManagementScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.fitness_center, color: Colors.black),
              title: Text('Criar Treinos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SendTrainingScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.people, color: Colors.black),
              title: Text('Gerenciar Usuários'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserManagerScreen())
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.black),
              title: Text('Configurações'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.red),
              title: Text('Sair'),
              onTap: () {
                _showExitConfirmationDialog(context);
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bem-vindo, Admin!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Gerencie as operações do aplicativo de ginástica aqui.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 20),
              _buildAdminOptionCard(
                'Criar Treinos para Usuários',
                Icons.fitness_center,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SendTrainingScreen()),
                  );
                },
              ),
              _buildAdminOptionCard(
                'Gerenciar Pagamentos dos Usuários',
                Icons.payment,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PaymentManagementScreen()),
                  );
                },
              ),
              _buildAdminOptionCard(
                'Configurações do Sistema',
                Icons.settings,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmação'),
          content: Text('Deseja realmente sair?'),
          actions: [
            TextButton(
              child: Text('Não'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Sim'),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildAdminOptionCard(String text, IconData icon, VoidCallback onTap) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(icon, color: Color(0xFF007BFF)),
        title: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
