import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:texasgym_1/Controller/FichaController.dart';
import 'package:texasgym_1/View/fichaView/CriarFichaView.dart';

class UserFichasScreen extends StatefulWidget {
  final int userId;
  final String name;
  final String phone;
  final String email;
  final String cpf;

  UserFichasScreen({
    required this.userId,
    required this.name,
    required this.phone,
    required this.email,
    required this.cpf,
  });

  @override
  _UserFichasScreenState createState() => _UserFichasScreenState();
}

class _UserFichasScreenState extends State<UserFichasScreen> {
  final FichaController _fichaController = FichaController();
  late Future<List<dynamic>?> _fichasFuture;

  @override
  void initState() {
    super.initState();
    _fichasFuture = _fetchFichas();
  }

  Future<List<dynamic>?> _fetchFichas() async {
    try {
      final fichas = await _fichaController.getFichasByUserId(widget.userId);
      return fichas;
    } catch (e) {
      print('Erro ao buscar fichas: $e');
      return null;
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
        child: FutureBuilder<List<dynamic>?>(
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
                    title: Text(ficha['observacao']),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      // Ação ao clicar na ficha (ex.: abrir detalhes)
                      _showFichaDetails(context, ficha);
                    },
                  ),
                );
              },
            );
          },
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
            child: Icon(Icons.refresh),
            label: "Recarregar",
            onTap: () {
              setState(() {
                _fichasFuture = _fetchFichas();
              });
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.add),
            label: 'Nova Ficha',
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CreateFichaScreen(userId: widget.userId),
                ),
              );
              if (result == true) {
                setState(() {
                  _fichasFuture =
                      _fetchFichas(); // Recarrega a lista após criar ficha
                });
              }
            },
          ),
        ],
      ),
    );
  }

  void _showFichaDetails(BuildContext context, Map<String, dynamic> ficha) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(ficha['observacao']),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Fechar'),
            ),
          ],
        );
      },
    );
  }
}
