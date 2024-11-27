import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class RelatorioController {
  final String baseUrl = 'https://10.0.2.2:7208/api/Relatorio'; // Certifique-se de que a rota da API esteja correta

  // Cliente HTTP customizado que ignora erros de SSL
  http.Client _getHttpClient() {
    final HttpClient httpClient = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        // Ignora erros de certificado SSL para hosts locais
        return true;
      };
    return IOClient(httpClient);
  }

  // Relatório simples de usuários
  Future<List<dynamic>> getRelatorioUsuariosSimples(String token) async {
    final client = _getHttpClient();
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/RelatorioUsuariosSimples'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Erro ao buscar RelatorioUsuariosSimples: ${response.body}');
      }
    } finally {
      client.close(); // Fecha o cliente para liberar recursos
    }
  }

  // Relatório de treinos por usuário
  Future<List<dynamic>> getRelatorioTreinosPorUsuario(String token) async {
    final client = _getHttpClient();
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/RelatorioTreinosPorUsuario'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Erro ao buscar RelatorioTreinosPorUsuario: ${response.body}');
      }
    } finally {
      client.close(); // Fecha o cliente para liberar recursos
    }
  }

  // Relatório completo
  Future<List<dynamic>> getRelatorioCompleto(String token) async {
    final client = _getHttpClient();
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/RelatorioCompleto'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Erro ao buscar RelatorioCompleto: ${response.body}');
      }
    } finally {
      client.close(); // Fecha o cliente para liberar recursos
    }
  }
}
