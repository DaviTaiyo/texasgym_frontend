import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:texasgym_1/Controller/Medida_controller.dart';
import 'package:texasgym_1/Controller/Usuario_controller.dart';
import 'package:texasgym_1/Model/Medida_model.dart';
import 'package:texasgym_1/Model/Usuario_Model.dart';
import 'package:texasgym_1/View/paymentView/mercadopagoscreen.dart';
import 'package:texasgym_1/View/configView/settingsScreen.dart';
import 'package:texasgym_1/View/userView/trainingSheetScreen.dart';
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

  void _updateProgress(int treinos, int calorias, int horas) {
    setState(() {
      treinosCompletados += treinos;
      caloriasQueimadas += calorias;
      horasDeTreino += horas;
    });
  }

  // Função para calcular a idade com base na data de nascimento
  int calcularIdade(DateTime dataNascimento) {
    final hoje = DateTime.now();
    int idade = hoje.year - dataNascimento.year;

    if (hoje.month < dataNascimento.month ||
        (hoje.month == dataNascimento.month && hoje.day < dataNascimento.day)) {
      idade--;
    }
    return idade;
  }

  Future<void> _navigateToProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(
          userId: _usuario?.id ?? 0,
          name: _usuario?.nome ?? "Não disponível",
          cpf: _usuario?.cpf ?? "Não disponivel",
          phone: _usuario?.telefone ?? "Não disponível",
          email: _usuario?.email ?? "Não disponível",
          birthDate: _usuario?.dataNascimento ?? DateTime.now(), // Passa a data de nascimento
          profileImage: userProfileImage,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _usuario?.nome;
        _usuario?.email;
      });
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
                  MaterialPageRoute(builder: (context) => MercadoPagoScreen()),
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
                          _buildMotivationalCard(
                              'Mantenha-se Hidratado durante o treino!'),
                          _buildMotivationalCard(
                              'Não esqueça de alongar antes e depois dos treinos.'),
                          _buildMotivationalCard(
                              'Progrida aos poucos para evitar lesões.'),
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
      Usuario? usuario = await _usuarioController.getUsuario(token);
      if (usuario != null) {
        _fetchMedidas(usuario.id!); // Carrega as medidas do usuário logado
      }
      setState(() {
        _usuario = usuario;
      });
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
}
