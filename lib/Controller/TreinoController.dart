// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:http/io_client.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:texasgym_1/Model/Treino_model.dart';

// class TreinoController {
//   final String apiUrl = 'https://10.0.2.2:7208/api/Treinos'; // Substitua pelo URL correto da sua API

//   // Cliente HTTP customizado que ignora erros de SSL
//   http.Client _getHttpClient() {
//     final ioClient = HttpClient()
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//     return IOClient(ioClient);
//   }

//   // Obter cabeçalhos autenticados
//   Future<Map<String, String>> _getHeaders() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('jwt_token');

//     if (token == null) {
//       throw Exception('Token JWT não encontrado.');
//     }

//     return {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer $token',
//     };
//   }

//   // Obter treinos por ficha ID
//   Future<List<Treino>> getTreinosByFichaId(int fichaId) async {
//     try {
//       final headers = await _getHeaders();
//       final url = Uri.parse('$apiUrl/ficha/$fichaId');
//       final client = _getHttpClient();

//       final response = await client.get(url, headers: headers);

//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
//         return data.map((json) => Treino.fromJson(json)).toList();
//       } else {
//         throw Exception('Erro ao buscar treinos: ${response.statusCode} - ${response.body}');
//       }
//     } catch (e) {
//       throw Exception('Erro de conexão: $e');
//     }
//   }

//   // Criar novo treino
//   Future<bool> criarTreino(Treino treino, List<int> exerciciosIds) async {
//     try {
//       final headers = await _getHeaders();
//       final url = Uri.parse(apiUrl);
//       final client = _getHttpClient();

//       final body = jsonEncode({
//         ...treino.toJson(),
//         'exercicios': exerciciosIds,
//       });

//       final response = await client.post(url, headers: headers, body: body);

//       if (response.statusCode == 201) {
//         return true;
//       } else {
//         throw Exception('Erro ao criar treino: ${response.statusCode} - ${response.body}');
//       }
//     } catch (e) {
//       throw Exception('Erro de conexão ao criar treino: $e');
//     }
//   }

//   // Atualizar treino existente
//   Future<bool> updateTreino(Treino treino, List<int>? exerciciosIds) async {
//     try {
//       final headers = await _getHeaders();
//       final url = Uri.parse('$apiUrl/${treino.id}');
//       final client = _getHttpClient();

//       final body = jsonEncode({
//         ...treino.toJson(),
//         if (exerciciosIds != null) 'exercicios': exerciciosIds,
//       });

//       final response = await client.put(url, headers: headers, body: body);

//       if (response.statusCode == 204) {
//         return true;
//       } else {
//         throw Exception('Erro ao atualizar treino: ${response.statusCode} - ${response.body}');
//       }
//     } catch (e) {
//       throw Exception('Erro de conexão ao atualizar treino: $e');
//     }
//   }

//   // Deletar treino
//   Future<bool> deletarTreino(int treinoId) async {
//     try {
//       final headers = await _getHeaders();
//       final url = Uri.parse('$apiUrl/$treinoId');
//       final client = _getHttpClient();

//       final response = await client.delete(url, headers: headers);

//       if (response.statusCode == 200) {
//         return true;
//       } else {
//         throw Exception('Erro ao deletar treino: ${response.statusCode} - ${response.body}');
//       }
//     } catch (e) {
//       throw Exception('Erro de conexão ao deletar treino: $e');
//     }
//   }
// }

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
      final headers = await _getHeaders();
      final url = Uri.parse('$apiUrl/ficha/$fichaId');
      final client = _getHttpClient();

      final response = await client.get(url, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('Dados recebidos: $data'); // Inspecione os dados
        return data.map((json) {
          print('Tentando deserializar: $json'); // Inspecione cada item
          return Treino.fromJson(json);
        }).toList();
      } else {
        throw Exception(
            'Erro ao buscar treinos: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
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
}
