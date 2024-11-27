import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:texasgym_1/Model/Treino_model.dart';

class TreinoController {
  final String apiUrl =
      'https://10.0.2.2:7208/api/Treinos'; // Substitua pelo URL correto da sua API

  http.Client _getHttpClient() {
    final ioClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    return IOClient(ioClient);
  }

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) {
      throw Exception('Token JWT não encontrado.');
    }

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Obter treinos por ficha ID
  Future<List<Treino>> getTreinosByFichaId(int fichaId) async {
  try {
    final headers = await _getHeaders(); // Recupera os cabeçalhos
    final url = Uri.parse('$apiUrl/ficha/$fichaId'); // URL do endpoint
    final client = _getHttpClient();

    final response = await client.get(url, headers: headers);

    if (response.statusCode == 200) {
      // Decodifica o corpo da resposta
      final List<dynamic> data = json.decode(response.body);
      print('Dados recebidos: $data');

      // Converte para objetos Treino
      return data.map((json) {
        return Treino.fromJson(json);
      }).toList();
    } else {
      print('Erro no backend: ${response.body}');
      throw Exception(
          'Erro ao buscar treinos: ${response.statusCode} - ${response.body}');
    }
  } catch (e) {
    print('Erro de conexão ou parsing: $e');
    throw Exception('Erro de conexão: $e');
  }
}

  // Método para teste com dados fixos
  Future<bool> criarTreino(Treino treino, List<int> exerciciosIds) async {
    try {
      final headers = await _getHeaders();
      final url = Uri.parse(apiUrl);
      final client = _getHttpClient();

      // Construct the body of the POST request
      final body = jsonEncode({
        ...treino.toJson(),
        'exercicios': exerciciosIds, // Include exercises if any
      });

      final response = await client.post(url, headers: headers, body: body);

      if (response.statusCode == 201) {
        return true;
      } else {
        print('Failed to create treino: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error creating treino: $e');
      return false;
    }
  }

// Método para deletar um treino
Future<bool> deleteTreino(int treinoId) async {
  try {
    final headers = await _getHeaders(); // Recupera os cabeçalhos
    final url = Uri.parse('$apiUrl/$treinoId'); // URL do endpoint com o ID do treino
    final client = _getHttpClient();

    final response = await client.delete(url, headers: headers);

    if (response.statusCode == 200) {
      print('Treino deletado com sucesso.');
      return true;
    } else {
      print('Erro ao deletar treino: ${response.body}');
      return false;
    }
  } catch (e) {
    print('Erro de conexão ao deletar treino: $e');
    return false;
  }
}

Future<bool> updateTreino(Treino treino, List<int> exerciciosIds) async {
  try {
    final headers = await _getHeaders();
    final url = Uri.parse('$apiUrl/${treino.id}');
    final client = _getHttpClient();

    final body = jsonEncode({
      'id': treino.id,
      'fichaId': treino.fichaId, // Certifique-se de que isso seja um número inteiro
      'nome': treino.nome,
      'repeticoes': treino.repeticoes,
      'tempoDescanso': treino.tempoDescanso,
      'pesoUsado': treino.pesoUsado,
      'diasTreino': treino.diasTreino,
      'observacao': treino.observacao,
      'exercicios': exerciciosIds, // Lista de IDs de exercícios
    });

    final response = await client.put(url, headers: headers, body: body);

    if (response.statusCode == 204) {
      print('Treino atualizado com sucesso.');
      return true;
    } else {
      print('Erro ao atualizar treino: ${response.body}');
      return false;
    }
  } catch (e) {
    print('Erro ao atualizar treino: $e');
    return false;
  }
}



}
