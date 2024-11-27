import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:texasgym_1/Controller/RelatorioController.dart';

class RelatorioScreen extends StatefulWidget {
  @override
  _RelatorioScreenState createState() => _RelatorioScreenState();
}

class _RelatorioScreenState extends State<RelatorioScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final RelatorioController _controller = RelatorioController();

  List<dynamic>? _usuariosSimples;
  List<dynamic>? _treinosPorUsuario;
  List<dynamic>? _relatorioCompleto;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchReports();
  }

  Future<void> _fetchReports() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      if (token == null) throw Exception('Token não encontrado. Faça login.');

      final usuariosSimples = await _controller.getRelatorioUsuariosSimples(token);
      final treinosPorUsuario = await _controller.getRelatorioTreinosPorUsuario(token);
      final relatorioCompleto = await _controller.getRelatorioCompleto(token);

      setState(() {
        _usuariosSimples = usuariosSimples;
        _treinosPorUsuario = treinosPorUsuario;
        _relatorioCompleto = relatorioCompleto;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar relatórios: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildTabContent(List<dynamic>? data, String emptyMessage) {
    if (data == null || data.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        return Card(
          margin: EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(
              item['Nome'] ?? 'Sem nome',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                ...item.entries.map((entry) {
                  if (entry.key == 'Nome') return SizedBox.shrink();
                  return Text('${entry.key}: ${entry.value}');
                }).toList(),
              ],
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Relatórios'),
        backgroundColor: Colors.blue,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Usuários Simples'),
            Tab(text: 'Treinos por Usuário'),
            Tab(text: 'Relatório Completo'),
          ],
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildTabContent(
                  _usuariosSimples,
                  'Nenhum dado disponível para usuários simples.',
                ),
                _buildTabContent(
                  _treinosPorUsuario,
                  'Nenhum dado disponível para treinos por usuário.',
                ),
                _buildTabContent(
                  _relatorioCompleto,
                  'Nenhum dado disponível para relatório completo.',
                ),
              ],
            ),
    );
  }
}
