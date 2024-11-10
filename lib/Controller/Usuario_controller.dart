import 'dart:convert';
import 'dart:io';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
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
      return "sucesso"; // Sinaliza que o registro foi bem-sucedido
    } else if (response.statusCode == 400) {
      // Se o backend retorna código 400 com mensagem específica
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
  Future<Usuario?> login(String email, String senha) async {
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

      // Decodificar o token JWT para extrair as informações do usuário
      final jwt = JWT.decode(token); // Decodifica o token sem verificar a assinatura
      final usuarioData = jwt.payload; // Pega os dados decodificados do payload do token

      // Extrair informações específicas do usuário
      return Usuario(
        email: usuarioData['email'],
        nome: usuarioData['nome'],
        administrador: usuarioData['administrador'] ?? false,
      );
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
}
