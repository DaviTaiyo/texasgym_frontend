import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:texasgym_1/Model/exercicios_Model.dart';

class ExercicioController {
  final String apiUrl = 'https://10.0.2.2:7208/api/Exercicios';

  // Cliente HTTP customizado para ignorar certificados inválidos em desenvolvimento
  http.Client _getHttpClient() {
    final ioClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    return IOClient(ioClient);
  }

  // Criar um novo exercício
  Future<bool> criarExercicio(Map<String, dynamic> exercicioData) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) {
      throw Exception('Token JWT não encontrado.');
    }

    final url = Uri.parse(apiUrl);
    final client = _getHttpClient();

    try {
      final response = await client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(exercicioData),
      );

      return response.statusCode == 201; // Retorna true se o exercício foi criado com sucesso
    } catch (e) {
      print('Erro ao criar exercício: $e');
      return false;
    } finally {
      client.close();
    }
  }

 // Obter todos os exercícios
Future<List<Exercicio>> getExercicios() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('jwt_token');

  if (token == null) {
    throw Exception('Token JWT não encontrado.');
  }

  final url = Uri.parse(apiUrl);
  final client = _getHttpClient();

  try {
    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      // Converte a lista dinâmica para uma lista de Exercicio
      return data.map((e) => Exercicio.fromJson(e)).toList();
    } else {
      print('Erro ao buscar exercícios: ${response.body}');
      return [];
    }
  } catch (e) {
    print('Erro de conexão: $e');
    return [];
  } finally {
    client.close();
  }
}

  // Obter exercício por ID
  Future<Map<String, dynamic>?> getExercicioById(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) {
      throw Exception('Token JWT não encontrado.');
    }

    final url = Uri.parse('$apiUrl/$id');
    final client = _getHttpClient();

    try {
      final response = await client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Erro ao buscar exercício: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Erro de conexão: $e');
      return null;
    } finally {
      client.close();
    }
  }

  // Atualizar um exercício existente
  Future<bool> atualizarExercicio(int id, Map<String, dynamic> exercicioData) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) {
      throw Exception('Token JWT não encontrado.');
    }

    final url = Uri.parse('$apiUrl/$id');
    final client = _getHttpClient();

    try {
      final response = await client.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(exercicioData),
      );

      return response.statusCode == 204; // Retorna true se o exercício foi atualizado com sucesso
    } catch (e) {
      print('Erro ao atualizar exercício: $e');
      return false;
    } finally {
      client.close();
    }
  }

  // Deletar um exercício
  Future<bool> deletarExercicio(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) {
      throw Exception('Token JWT não encontrado.');
    }

    final url = Uri.parse('$apiUrl/$id');
    final client = _getHttpClient();

    try {
      final response = await client.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200; // Retorna true se o exercício foi deletado com sucesso
    } catch (e) {
      print('Erro ao deletar exercício: $e');
      return false;
    } finally {
      client.close();
    }
  }
}
