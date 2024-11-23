import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:texasgym_1/Model/Medida_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:texasgym_1/main.dart';

class MedidaController {
  final String apiUrl = 'https://10.0.2.2:7208/api'; // Substitua pelo seu URL base da API

  // Cliente HTTP customizado que ignora erros de SSL
  http.Client _getHttpClient() {
    final ioClient = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    return IOClient(ioClient);
  }

  // Método para buscar as medidas do usuário pelo ID
  Future<List<Medida>?> getMedidasByUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token'); // Obtém o token armazenado

    if (token == null) {
      print("Token JWT não encontrado.");
      return null;
    }

    final url = Uri.parse('$apiUrl/medidas/usuario/$userId'); // Supondo que o endpoint seja esse
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
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Medida.fromJson(json)).toList();
      } else {
        print("Erro ao buscar medidas: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Erro de conexão: $e");
      return null;
    } finally {
      client.close();
    }
  }

Future<void> postMedida(double altura, double peso, double gorduraCorporal, DateTime dataMedida, int usuarioId) async {
    final url = Uri.parse('$apiUrl/medidas');
    final body = jsonEncode({
      'altura': altura,
      'peso': peso,
      'gorduraCorporal': gorduraCorporal,
      'dataMedida': dataMedida.toIso8601String(),
      'usuarioId': usuarioId,
    });
    print("Enviando dados: $body");

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 201) {
      print("Medida criada com sucesso");
    } else {
      // Lança uma exceção com detalhes do erro
      print("Erro ao criar a medida: ${response.statusCode} - ${response.body}");
      throw Exception('Erro ao criar a medida: ${response.body}');
    }
  }

Future<Medida?> getLatestMedidaByUserId(int userId) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('jwt_token'); // Obtém o token armazenado

  if (token == null) {
    print("Token JWT não encontrado.");
    return null;
  }

  final url = Uri.parse('$apiUrl/medidas/usuario/$userId/latest');
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
      print("Response Body: ${response.body}");
      final data = json.decode(response.body);
      return Medida.fromJson(data); // Mapeia para o modelo
    } else {
      print("Erro ao buscar medida: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Erro de conexão: $e");
    return null;
  } finally {
    client.close();
  }
}

Future<void> saveOrUpdateMedida({
  required double altura,
  required double peso,
  required double gorduraCorporal,
  required DateTime dataMedida,
  required int usuarioId,
  Medida? existingMedida, // Passa a medida existente, se houver
}) async {
  final client = _getHttpClient();

  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) {
      throw Exception("Token de autenticação não encontrado.");
    }

    if (existingMedida == null) {
      // Criar nova medida
      final url = Uri.parse('$apiUrl/medidas');
      final body = jsonEncode({
        'altura': altura,
        'peso': peso,
        'gorduraCorporal': gorduraCorporal,
        'dataMedida': dataMedida.toIso8601String(),
        'usuarioId': usuarioId,
      });

      final response = await client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Inclui o token no cabeçalho
        },
        body: body,
      );

      if (response.statusCode == 201) {
        // Mensagem de sucesso e retorno à tela anterior
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          SnackBar(content: Text('Medida criada com sucesso!')),
        );
        navigatorKey.currentState!.pop(true); // Passa 'true' para indicar sucesso
      } else {
        throw Exception('Erro ao criar medida: ${response.body}');
      }
    } else {
      // Atualizar medida existente
      final url = Uri.parse('$apiUrl/Medidas/${existingMedida.id}');
      final body = jsonEncode({
        'id': existingMedida.id,
        'altura': altura,
        'peso': peso,
        'gorduraCorporal': gorduraCorporal,
        'dataMedida': dataMedida.toIso8601String(),
        'usuarioId': usuarioId,
      });

      final response = await client.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Inclui o token no cabeçalho
        },
        body: body,
      );

      if (response.statusCode == 204) {
        // Mensagem de sucesso e retorno à tela anterior
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          SnackBar(content: Text('Medida atualizada com sucesso!')),
        );
        navigatorKey.currentState!.pop(true); // Passa 'true' para indicar sucesso
      } else {
        throw Exception('Erro ao atualizar medida: ${response.body}');
      }
    }
  } catch (e) {
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      SnackBar(content: Text('Erro: $e')),
    );
    rethrow;
  } finally {
    client.close();
  }
}
}
