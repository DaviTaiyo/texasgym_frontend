import 'package:flutter/material.dart';
import 'package:texasgym_1/Controller/FichaController.dart';
import 'package:texasgym_1/View/TreinoView/TreinoView.dart';

class FichaTreinoScreen extends StatefulWidget {
  final int userId;
  final String name;
  final String phone;
  final String email;
  final String cpf;

  FichaTreinoScreen({
    required this.userId,
    required this.name,
    required this.phone,
    required this.email,
    required this.cpf,
  });

  @override
  _FichaTreinoScreenState createState() => _FichaTreinoScreenState();
}

class _FichaTreinoScreenState extends State<FichaTreinoScreen> {
  final FichaController _fichaController = FichaController();
  late Future<List<dynamic>> _fichasFuture;

  @override
  void initState() {
    super.initState();
    _fichasFuture = _fetchFichas();
  }

  Future<List<dynamic>> _fetchFichas() async {
    try {
      final fichas = await _fichaController.getFichasByUserId(widget.userId);
      return fichas ?? [];
    } catch (e) {
      print('Erro ao buscar fichas: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas Fichas'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<dynamic>>(
          future: _fichasFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Erro ao carregar as fichas. Tente novamente.'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text('Nenhuma ficha encontrada.'),
              );
            }

            final fichas = snapshot.data!;
            return ListView.builder(
              itemCount: fichas.length,
              itemBuilder: (context, index) {
                final ficha = fichas[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(ficha['observacao'] ?? 'Sem observação'),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TreinoScreen(fichaId: ficha['id']),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
