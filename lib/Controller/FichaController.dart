import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FichaController {
  final String apiUrl = 'https://10.0.2.2:7208/api/Fichas';

  // Cliente HTTP customizado que ignora erros de SSL
  http.Client _getHttpClient() {
    final ioClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    return IOClient(ioClient);
  }

  // Obter todas as fichas
  Future<List<dynamic>?> getFichas() async {
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
        return json.decode(response.body);
      } else {
        print('Erro ao buscar fichas: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Erro de conexão: $e');
      return null;
    } finally {
      client.close();
    }
  }

  // Obter ficha por ID
  Future<Map<String, dynamic>?> getFichaById(int id) async {
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
        return json.decode(response.body);
      } else {
        print('Erro ao buscar ficha: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Erro de conexão: $e');
      return null;
    } finally {
      client.close();
    }
  }

  // Criar uma nova ficha
  Future<bool> criarFicha(Map<String, dynamic> fichaData) async {
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
        body: json.encode(fichaData),
      );

      return response.statusCode == 201; // Retorna true se a ficha foi criada com sucesso
    } catch (e) {
      print('Erro ao criar ficha: $e');
      return false;
    } finally {
      client.close();
    }
  }

  // Atualizar uma ficha existente
  Future<bool> atualizarFicha(int id, Map<String, dynamic> fichaData) async {
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
        body: json.encode(fichaData),
      );

      return response.statusCode == 204; // Retorna true se a ficha foi atualizada
    } catch (e) {
      print('Erro ao atualizar ficha: $e');
      return false;
    } finally {
      client.close();
    }
  }

  // Deletar uma ficha
  Future<bool> deletarFicha(int id) async {
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

      return response.statusCode == 200; // Retorna true se a ficha foi deletada
    } catch (e) {
      print('Erro ao deletar ficha: $e');
      return false;
    } finally {
      client.close();
    }
  }
  //pegar ficha pelo Id do usuario
  Future<List<dynamic>?> getFichasByUserId(int userId) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('jwt_token');

  if (token == null) {
    throw Exception('Token JWT não encontrado.');
  }

  // Atualize a URL para apontar para o endpoint correto
  final url = Uri.parse('https://10.0.2.2:7208/api/Fichas/usuario/$userId');
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
      return json.decode(response.body);
    } else {
      print('Erro ao buscar fichas: ${response.body}');
      return null;
    }
  } catch (e) {
    print('Erro de conexão: $e');
    return null;
  } finally {
    client.close();
  }
}

}
