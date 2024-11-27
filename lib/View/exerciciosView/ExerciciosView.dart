import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:texasgym_1/View/exerciciosView/CriarExerciciosView.dart';
import 'package:texasgym_1/Controller/ExerciciosController.dart';
import 'package:texasgym_1/Model/exercicios_Model.dart';

class ExerciciosScreen extends StatefulWidget {
  final int userId;

  ExerciciosScreen({required this.userId});

  @override
  _ExerciciosScreenState createState() => _ExerciciosScreenState();
}

class _ExerciciosScreenState extends State<ExerciciosScreen> {
  final ExercicioController _exercicioController = ExercicioController();
  late Future<List<Exercicio>> _exerciciosFuture;

  @override
  void initState() {
    super.initState();
    _exerciciosFuture = _fetchExercicios();
  }

  Future<List<Exercicio>> _fetchExercicios() async {
    try {
      final exercicios = await _exercicioController.getExercicios();
      return exercicios;
    } catch (e) {
      print('Erro ao buscar exercícios: $e');
      return [];
    }
  }

  Future<void> _refreshExercicios() async {
    setState(() {
      _exerciciosFuture = _fetchExercicios();
    });
  }

  Future<void> _deleteExercicio(int exercicioId) async {
    try {
      final success = await _exercicioController.deletarExercicio(exercicioId);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Exercício deletado com sucesso.')),
        );
        _refreshExercicios();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao deletar o exercício.')),
        );
      }
    } catch (e) {
      print('Erro ao deletar exercício: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro de conexão ao deletar o exercício.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Exercícios'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Exercicio>>(
          future: _exerciciosFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Erro ao carregar os exercícios.'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text('Nenhum exercício encontrado.'),
              );
            }

            final exercicios = snapshot.data!;
            return ListView.builder(
              itemCount: exercicios.length,
              itemBuilder: (context, index) {
                final exercicio = exercicios[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(exercicio.nome),
                    subtitle: Text(exercicio.descricao ?? "Sem descrição"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _confirmDelete(context, exercicio.id!);
                          },
                        ),
                        Icon(Icons.play_arrow),
                      ],
                    ),
                    onTap: () {
                      _showExercicioDetails(context, exercicio);
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
        children: [
          SpeedDialChild(
            child: Icon(Icons.refresh),
            label: "Recarregar",
            onTap: _refreshExercicios,
          ),
          SpeedDialChild(
            child: Icon(Icons.add),
            label: 'Novo Exercício',
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CreateExercicioScreen(userId: widget.userId),
                ),
              );
              if (result == true) {
                _refreshExercicios();
              }
            },
          ),
        ],
      ),
    );
  }

  void _showExercicioDetails(BuildContext context, Exercicio exercicio) {
    final videoId = YoutubePlayer.convertUrlToId(exercicio.linkYoutube ?? '');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(exercicio.nome),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(exercicio.descricao ?? "Sem descrição"),
              SizedBox(height: 16),
              if (videoId != null)
                YoutubePlayer(
                  controller: YoutubePlayerController(
                    initialVideoId: videoId,
                    flags: YoutubePlayerFlags(autoPlay: false),
                  ),
                )
              else
                Text('Nenhum vídeo disponível.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Fechar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Fecha o diálogo
                _confirmDelete(context, exercicio.id!); // Confirma exclusão
              },
              child: Text(
                'Deletar',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, int exercicioId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmar Exclusão'),
          content: Text('Tem certeza que deseja excluir este exercício?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Fecha o diálogo
                await _deleteExercicio(exercicioId); // Chama o método de exclusão
              },
              child: Text(
                'Excluir',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
