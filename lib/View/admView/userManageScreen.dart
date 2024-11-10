import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserManagerScreen extends StatelessWidget {
  final List<Map<String, dynamic>> users = [
    {
      'name': 'João Silva',
      'age': 30,
      'height': 1.80,
      'weight': 75.0,
      'entryDate': DateTime(2022, 1, 15),
      'favoriteWorkouts': ['Musculação', 'Shape'],
      'workoutData': [20, 15, 22, 18, 25, 20, 22, 30, 28, 30, 27, 26]
    },
    {
      'name': 'Maria Oliveira',
      'age': 25,
      'height': 1.65,
      'weight': 60.0,
      'entryDate': DateTime(2021, 6, 10),
      'favoriteWorkouts': ['Yoga', 'Pilates'],
      'workoutData': [22, 20, 23, 20, 24, 22, 21, 26, 23, 30, 28, 27]
    },
    {
      'name': 'Pedro Santos',
      'age': 35,
      'height': 1.90,
      'weight': 85.0,
      'entryDate': DateTime(2023, 3, 5),
      'favoriteWorkouts': ['Pernas', 'Ombros'],
      'workoutData': [18, 15, 20, 22, 26, 24, 25, 27, 25, 30, 29, 28]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciar Usuários'),
        backgroundColor: Color(0xFF007BFF),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              leading: Icon(Icons.person, color: Colors.blueAccent),
              title: Text(
                user['name'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Text(
                'Idade: ${user['age']} anos\nAltura: ${user['height']} m\nPeso: ${user['weight']} kg',
                style: TextStyle(fontSize: 14),
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
              onTap: () => _showUserDetails(context, user),
            ),
          );
        },
      ),
    );
  }

  void _showUserDetails(BuildContext context, Map<String, dynamic> user) {
    final now = DateTime.now();
    final entryDate = user['entryDate'];
    final duration = now.difference(entryDate);
    final formattedEntryDate = DateFormat('dd/MM/yyyy').format(entryDate);
    final monthsInGym = (duration.inDays / 30).floor();
    

    final avgAttendance = (user['workoutData'].map((e) => e as int).reduce((a, b) => a + b) / user['workoutData'].length).round();
    final avgAbsence = (30 - avgAttendance).round();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            user['name'],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.blueAccent,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(Icons.cake, 'Idade:', '${user['age']} anos'),
                _buildInfoRow(Icons.height, 'Altura:', '${user['height']} m'),
                _buildInfoRow(Icons.monitor_weight, 'Peso:', '${user['weight']} kg'),
                SizedBox(height: 10),
                _buildInfoRow(Icons.date_range, 'Data de entrada:', formattedEntryDate),
                _buildInfoRow(Icons.access_time, 'Tempo na academia:', '$monthsInGym meses'),
                _buildInfoRow(Icons.favorite, 'Treinos preferidos:', '${user['favoriteWorkouts'].join(', ')}'),
                SizedBox(height: 10),
                Divider(color: Colors.grey),
                SizedBox(height: 10),
                _buildInfoRow(Icons.fitness_center, 'Média de treinos por mês:', '$avgAttendance dias'),
                _buildInfoRow(Icons.calendar_today, 'Média de faltas por mês:', '$avgAbsence dias'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Fechar', style: TextStyle(color: Colors.blueAccent)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: ' $value',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
