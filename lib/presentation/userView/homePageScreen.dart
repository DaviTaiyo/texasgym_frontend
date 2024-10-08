import 'package:flutter/material.dart';
import 'package:texasgym_1/presentation/paymentView/paymentScreen.dart';
import 'package:texasgym_1/presentation/configView/settingsScreen.dart';
import 'package:texasgym_1/presentation/userView/trainingSheetScreen.dart';
import 'dart:io';
import 'profileScreen.dart';
import 'package:texasgym_1/presentation/views/loginScreen.dart';

class HomePageScreen extends StatefulWidget {
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  int treinosCompletados = 0;
  int caloriasQueimadas = 0;
  int horasDeTreino = 0;

  String userName = 'Guilherme';
  String userEmail = 'gui@email.com';
  File? userProfileImage;

  void _updateProgress(int treinos, int calorias, int horas) {
    setState(() {
      treinosCompletados += treinos;
      caloriasQueimadas += calorias;
      horasDeTreino += horas;
    });
  }

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
        title: Text('Home'),
        backgroundColor: Colors.blue,
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
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: Icon(Icons.person, color: Colors.black),
              title: Text('Perfil'),
              onTap: _navigateToProfile,
            ),
            ListTile(
              leading: Icon(Icons.fitness_center, color: Colors.black),
              title: Text('Treinos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TrainingSheetScreen(
                      onTrainingCompleted: _updateProgress,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.payment, color: Colors.black),
              title: Text('Pagamentos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaymentOptionsScreen()),
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
                'Bem-vindo de volta!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Aqui estão suas atividades recentes:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Dicas Motivacionais',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildMotivationalCard('Mantenha-se Hidratado durante o treino!'),
                    _buildMotivationalCard('Não esqueça de alongar antes e depois dos treinos.'),
                    _buildMotivationalCard('Progrida aos poucos para evitar lesões.'),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Resumo do Progresso',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              _buildProgressSummary(),
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
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildMotivationalCard(String text) {
    return Container(
      width: 200,
      margin: EdgeInsets.only(right: 10),
      child: Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressSummary() {
    return Column(
      children: [
        _buildProgressCard(
          'Treinos completados',
          '$treinosCompletados sessões',
          Icons.fitness_center,
          Colors.green,
        ),
        SizedBox(height: 10),
        _buildProgressCard(
          'Calorias queimadas',
          '$caloriasQueimadas kcal',
          Icons.local_fire_department,
          Colors.red,
        ),
        SizedBox(height: 10),
        _buildProgressCard(
          'Horas de treino',
          '$horasDeTreino horas',
          Icons.timer,
          Colors.orange,
        ),
      ],
    );
  }

  Widget _buildProgressCard(String title, String data, IconData icon, Color iconColor) {
  return Card(
    elevation: 2, // Reduzindo a elevação para um sombreamento mais sutil
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconColor.withOpacity(0.2),
            ),
            padding: EdgeInsets.all(8),
            child: Icon(icon, color: iconColor, size: 40),
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 5),
              Text(
                data,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}