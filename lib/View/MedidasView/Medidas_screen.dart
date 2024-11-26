import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:texasgym_1/Controller/Medida_controller.dart';
import 'package:texasgym_1/Model/Medida_model.dart';
import 'package:texasgym_1/View/MedidasView/CriarMedidasScreen.dart';

class MedidasScreen extends StatefulWidget {
  final int userId;

  MedidasScreen({required this.userId});

  @override
  _MedidasScreenState createState() => _MedidasScreenState();
}

class _MedidasScreenState extends State<MedidasScreen> {
  final MedidaController _medidaController = MedidaController();
  Medida? _medida; // Apenas uma medida
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLatestMedida(); // Busca apenas a última medida
  }

  Future<void> _fetchLatestMedida() async {
    setState(() {
      _isLoading = true;
    });

    Medida? medida = await _medidaController.getLatestMedidaByUserId(widget.userId);
    print("Medida carregada: ${medida?.altura}, ${medida?.peso}, ${medida?.gorduraCorporal}");
    setState(() {
      _medida = medida;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medida do Usuário'),
        backgroundColor: Colors.blue,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _medida == null
              ? Center(child: Text("Nenhuma medida encontrada"))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildMeasurementView(_medida!),
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
            child: Icon(Icons.add),
            label: 'Adicionar Medida',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CriarMedidasScreen()),
              );
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.refresh),
            label: 'Atualizar Medida',
            onTap: _fetchLatestMedida, // Atualiza a última medida ao pressionar
          ),
        ],
      ),
    );
  }

  Widget _buildMeasurementView(Medida medida) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blue[100],
            child: Icon(
              Icons.bar_chart,
              size: 50,
              color: Colors.blue,
            ),
          ),
        ),
        SizedBox(height: 16),
        _buildInfoRow(Icons.calendar_today, "Data", medida.dataMedida?.toLocal().toString().split(' ')[0] ?? "Não disponível"),
        _buildInfoRow(Icons.height, "Altura", "${medida.altura ?? "N/A"} m"),
        _buildInfoRow(Icons.monitor_weight, "Peso", "${medida.peso ?? "N/A"} kg"),
        _buildInfoRow(Icons.fitness_center, "Gordura Corporal", "${medida.gorduraCorporal ?? "N/A"} %"),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 30, color: Colors.blue),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
              ),
              Text(
                value,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
