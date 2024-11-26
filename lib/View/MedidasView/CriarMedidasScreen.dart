import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:texasgym_1/Controller/Medida_controller.dart';
import 'package:texasgym_1/Controller/Usuario_controller.dart';
import 'package:texasgym_1/Model/Usuario_Model.dart';
import 'package:texasgym_1/Model/Medida_model.dart';

class CriarMedidasScreen extends StatefulWidget {
  @override
  _CriarMedidasScreenState createState() => _CriarMedidasScreenState();
}

class _CriarMedidasScreenState extends State<CriarMedidasScreen> {
  final _formKey = GlobalKey<FormState>();
  final MedidaController _medidaController = MedidaController();
  final UsuarioController _usuarioController = UsuarioController();

  Usuario? _usuario;
  Medida? _medida;

  final TextEditingController alturaController = TextEditingController();
  final TextEditingController pesoController = TextEditingController();
  final TextEditingController gorduraCorporalController = TextEditingController();
  final TextEditingController dataMedidaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token != null) {
      final usuario = await _usuarioController.getUsuario(token);
      setState(() {
        _usuario = usuario;
      });

      if (_usuario != null) {
        final medida = await _medidaController.getLatestMedidaByUserId(_usuario!.id!);
        setState(() {
          _medida = medida;
          if (_medida != null) {
            _preencherCampos(_medida!);
          }
        });
      }
    } else {
      print("Token JWT não encontrado.");
    }
  }

  void _preencherCampos(Medida medida) {
    alturaController.text = medida.altura?.toString() ?? '';
    pesoController.text = medida.peso?.toString() ?? '';
    gorduraCorporalController.text = medida.gorduraCorporal?.toString() ?? '';
    dataMedidaController.text = medida.dataMedida != null
        ? DateFormat('dd/MM/yyyy').format(medida.dataMedida!)
        : '';
  }

  Future<void> _saveMeasurement() async {
    if (_usuario == null) {
      print("Usuário não encontrado.");
      return;
    }

    final double altura = double.tryParse(alturaController.text) ?? 0.0;
    final double peso = double.tryParse(pesoController.text) ?? 0.0;
    final double gorduraCorporal = double.tryParse(gorduraCorporalController.text) ?? 0.0;
    final DateTime dataMedida = DateFormat('dd/MM/yyyy').parse(dataMedidaController.text);

    try {
      await _medidaController.saveOrUpdateMedida(
        altura: altura,
        peso: peso,
        gorduraCorporal: gorduraCorporal,
        dataMedida: dataMedida,
        usuarioId: _usuario!.id!,
        existingMedida: _medida,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_medida == null ? 'Medida criada com sucesso' : 'Medida atualizada com sucesso')),
      );
      Navigator.pop(context);
    } catch (e) {
      print("Erro ao salvar medida: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar medida')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar/Atualizar Medidas'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _usuario == null
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildInputField(Icons.height, "Altura (m)", alturaController,
                        "Informe a altura", TextInputType.number),
                    _buildInputField(Icons.monitor_weight, "Peso (kg)", pesoController,
                        "Informe o peso", TextInputType.number),
                    _buildInputField(Icons.fitness_center, "Gordura Corporal (%)",
                        gorduraCorporalController, "Informe a gordura corporal", TextInputType.number),
                    _buildDateField(),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _saveMeasurement();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        textStyle: TextStyle(fontSize: 16),
                      ),
                      child: Text('Salvar Medida'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildInputField(
    IconData icon,
    String label,
    TextEditingController controller,
    String validationMessage,
    TextInputType keyboardType,
  ) {
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
                  return validationMessage;
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
              controller: dataMedidaController,
              decoration: InputDecoration(
                labelText: "Data da Medida",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  setState(() {
                    dataMedidaController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
                  });
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Informe a data da medida';
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
