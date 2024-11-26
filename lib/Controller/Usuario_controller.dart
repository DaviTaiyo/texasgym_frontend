import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:texasgym_1/Model/Usuario_Model.dart';

class UsuarioController {
  final String apiUrl = 'https://10.0.2.2:7208/api/Usuario';

  // Cliente HTTP customizado que ignora erros de SSL
  http.Client _getHttpClient() {
    final ioClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    return IOClient(ioClient);
  }

  Future<String?> registrarUsuario(Usuario usuario) async {
  final url = Uri.parse('$apiUrl/registrar');
  final client = _getHttpClient();

  final body = jsonEncode(usuario.toJsonRegistro());

  try {
    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      return "sucesso";
    } else if (response.statusCode == 400) {
      final errorResponse = response.body;
      return errorResponse;
    } else {
      final errorResponse = json.decode(response.body);
      return errorResponse['message'] ?? 'Erro desconhecido.';
    }
  } catch (e) {
    return "Erro de conexão: $e";
  } finally {
    client.close();
  }
}

  // Método para login
Future<String?> login(String email, String senha) async {
  final url = Uri.parse('$apiUrl/login');
  final client = _getHttpClient();

  final body = jsonEncode({
    'email': email,
    'senha': senha,
  });

  try {
    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final token = responseData['token'];

      // Salva o token usando SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);

      return token; // Retorna o token para indicar que o login foi bem-sucedido
    } else {
      return null; // Retorna null em caso de erro de autenticação
    }
  } catch (e) {
    print("Erro de conexão: $e");
    return null;
  } finally {
    client.close();
  }
}

  // Método para atualizar a senha do usuário
  Future<String?> atualizarSenha(int id, String novaSenha) async {
    final url = Uri.parse('$apiUrl/atualizar-senha/$id');
    final client = _getHttpClient();

    final body = jsonEncode(novaSenha);

    try {
      final response = await client.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        return "Senha atualizada com sucesso.";
      } else {
        return _parseError(response);
      }
    } catch (e) {
      return "Erro de conexão: $e";
    } finally {
      client.close();
    }
  }

  // Método para deletar usuário
  Future<String?> deletarUsuario(int id) async {
    final url = Uri.parse('$apiUrl/deletar/$id');
    final client = _getHttpClient();

    try {
      final response = await client.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return "Usuário deletado com sucesso.";
      } else {
        return _parseError(response);
      }
    } catch (e) {
      return "Erro de conexão: $e";
    } finally {
      client.close();
    }
  }

  // Método para listar todos os usuários
  Future<List<Usuario>?> listarUsuarios() async {
    final url = Uri.parse('$apiUrl/listar');
    final client = _getHttpClient();

    try {
      final response = await client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Usuario.fromJson(json)).toList();
      } else {
        print(_parseError(response));
        return null;
      }
    } catch (e) {
      print("Erro de conexão: $e");
      return null;
    } finally {
      client.close();
    }
  }

  // Função auxiliar para processar erros
  String _parseError(http.Response response) {
    if (response.body.isNotEmpty) {
      final errorResponse = json.decode(response.body);
      if (errorResponse is String) {
        return errorResponse;
      } else if (errorResponse['errors'] != null) {
        final errors = errorResponse['errors'] as Map<String, dynamic>;
        String errorMessage = '';
        errors.forEach((field, messages) {
          errorMessage += '${field}: ${messages.join(", ")}\n';
        });
        return errorMessage.trim();
      } else {
        return errorResponse['title'] ?? "Erro desconhecido.";
      }
    } else {
      return "Erro: Resposta do servidor está vazia.";
    }
  }

  //Função para pegar todos os usuarios
  Future<Usuario?> getUsuario(String token) async {
    final url = Uri.parse('$apiUrl/me');
    final client = _getHttpClient();

    try {
      final response = await client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Inclui o token no cabeçalho
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Usuario.fromJson(data); // Converte a resposta JSON para um objeto Usuario
      } else {
        print("Erro ao buscar usuário: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Erro de conexão: $e");
      return null;
    } finally {
      client.close();
    }
  }

  Future<Usuario?> getUserByToken(String token) async {
    final response = await http.get(
      Uri.parse('$apiUrl/me'), // Certifique-se de que o endpoint seja correto
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Retorna o objeto Usuario com base na resposta JSON
      return Usuario.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      print('Token inválido ou expirado');
      return null;
    } else {
      print('Erro ao buscar usuário: ${response.statusCode}');
      return null;
    }
  }

Future<bool> atualizarUsuario({
  required String name,
  required String phone,
  required String email,
  required String cpf,
  required DateTime birthDate,
  required int userId, // Adiciona o ID do usuário
}) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('jwt_token');

  if (token == null) {
    throw Exception('Token JWT não encontrado.');
  }
  final url = Uri.parse('$apiUrl/atualizar/$userId'); // Inclui o ID na rota
  final body = jsonEncode({
  'nome': name,
  'telefone': phone,
  'email': email,
  'cpf': cpf,
  'dataNascimento': DateFormat('yyyy-MM-dd').format(birthDate),
  'senha': "1"
});

  try {
    final response = await _getHttpClient().put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    return response.statusCode == 200;
  } catch (e) {
    print('Erro ao atualizar perfil: $e');
    return false;
  }
}
}
