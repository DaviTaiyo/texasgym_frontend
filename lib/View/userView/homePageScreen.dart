import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:texasgym_1/Controller/Medida_controller.dart';
import 'package:texasgym_1/Controller/Usuario_controller.dart';
import 'package:texasgym_1/Model/Medida_model.dart';
import 'package:texasgym_1/Model/Usuario_Model.dart';
import 'package:texasgym_1/View/TreinoView/FichaDeTreino.dart';
import 'package:texasgym_1/View/admView/listUserView.dart';
import 'package:texasgym_1/View/admView/paymentManagerScreen.dart';
import 'package:texasgym_1/View/admView/workoutManagerScreen.dart';
import 'package:texasgym_1/View/fichaView/FichaView.dart';
import 'package:texasgym_1/View/paymentView/mercadopagoscreen.dart';
import 'dart:io';
import 'profileScreen.dart';
import 'package:texasgym_1/View/views/loginScreen.dart';

class HomePageScreen extends StatefulWidget {
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final UsuarioController _usuarioController = UsuarioController();
  final MedidaController _medidaController = MedidaController();
  Usuario? _usuario;
  List<Medida>? _medidas;
  bool _isLoading = true;

  int treinosCompletados = 0;
  int caloriasQueimadas = 0;
  int horasDeTreino = 0;

  @override
  void initState() {
    super.initState();
    _fetchUsuario();
  }

  File? userProfileImage;

  Future<void> _navigateToProfile() async {
    if (_usuario != null) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(
            userId: _usuario!.id!,
            name: _usuario!.nome!,
            cpf: _usuario!.cpf!,
            phone: _usuario!.telefone!,
            email: _usuario!.email!,
            birthDate: _usuario!.dataNascimento!,
            profileImage: userProfileImage,
          ),
        ),
      );

      if (result != null) {
        setState(() {
          _usuario?.nome = result['name'];
          _usuario?.email = result['email'];
        });
      }
    } else {
      print("Usuário não carregado.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Texas Gym'),
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(_usuario?.nome ?? "Não disponível"),
              accountEmail: Text(_usuario?.email ?? "Não disponível"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: userProfileImage != null
                    ? FileImage(userProfileImage!)
                    : AssetImage('assets/default_avatar.png') as ImageProvider,
                child: userProfileImage == null
                    ? Text((_usuario?.nome ?? "Não disponível")[0])
                    : null,
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
              leading: Icon(Icons.note_alt_rounded, color: Colors.black),
              title: Text('Fichas'),
              onTap: () {
                if (_usuario != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserFichasScreen(
                        userId: _usuario!.id!,
                        name: _usuario!.nome!,
                        phone: _usuario!.telefone!,
                        email: _usuario!.email!,
                        cpf: _usuario!.cpf!,
                      ),
                    ),
                  );
                } else {
                  print("Usuário não carregado.");
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.airline_seat_recline_extra_rounded,
                  color: Colors.black),
              title: Text('Exercícios'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FichaTreinoScreen(
                        userId: _usuario!.id!,
                        name: _usuario!.nome!,
                        phone: _usuario!.telefone!,
                        email: _usuario!.email!,
                        cpf: _usuario!.cpf!),
                  ),
                );
              },
            ),
            if (_usuario?.professor == true) ...[
              ListTile(
                leading: Icon(Icons.fitness_center, color: Colors.black),
                title: Text('Criar Treinos'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SendTrainingScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.payment, color: Colors.black),
                title: Text('Gerenciar Pagamentos'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaymentManagementScreen()),
                  );
                },
              ),
            ],
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Bem-vindo ',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          _usuario?.nome ?? "Não disponível",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    if (_usuario!.professor == true) ...[
                      _buildAdminOptionCard(
                        'Criar Treinos para Usuários',
                        Icons.fitness_center,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SendTrainingScreen()),
                          );
                        },
                      ),
                      _buildAdminOptionCard(
                        'Gerenciar Pagamentos dos Usuários',
                        Icons.payment,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PaymentManagementScreen()),
                          );
                        },
                      ),
                      _buildAdminOptionCard(
                        'Ver Usuarios',
                        Icons.person,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    UserListScreen()),
                          );
                        },
                      ),
                    ],
                    SizedBox(height: 20),
                    Text(
                      'Aqui estão suas atividades recentes:',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
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

  Widget _buildProgressCard(
      String title, String data, IconData icon, Color iconColor) {
    return Card(
      elevation: 2,
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

  Future<void> _fetchUsuario() async {
    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token != null) {
      try {
        Usuario? usuario = await _usuarioController.getUsuario(token);
        if (usuario != null) {
          setState(() {
            _usuario = usuario;
          });
          _fetchMedidas(usuario.id!); // Carrega as medidas do usuário logado
        } else {
          print("Erro ao buscar os dados do usuário.");
        }
      } catch (e) {
        print("Erro ao carregar usuário: $e");
      }
    } else {
      print("Token JWT não encontrado.");
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _fetchMedidas(int userId) async {
    List<Medida>? medidas = await _medidaController.getMedidasByUserId(userId);
    setState(() {
      _medidas = medidas;
    });
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
