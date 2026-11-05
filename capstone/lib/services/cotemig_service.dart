// Responsável pelas requisições HTTP de login à API do Cotemig
// Documentação: https://api.cotemig.com.br/v1/doc/

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class CotemigException implements Exception {
  final String mensagem;

  CotemigException(this.mensagem);

  @override
  String toString() => mensagem;
}

class CotemigService {
  static const String urlBase = 'https://api.cotemig.com.br/v1';

  // POST /autenticacao com Basic Auth (usuário:senha em base64).
  // Retorna o Bearer token, válido por 25 minutos (longaDuracao = false).
  static Future<String> autenticar(String usuario, String senha) async {
    final credenciais = base64Encode(utf8.encode('$usuario:$senha'));
    final json = await _requisicao(
      () => http.post(
        Uri.parse('$urlBase/autenticacao'),
        headers: {
          'Authorization': 'Basic $credenciais',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'longaDuracao': false}),
      ),
    );
    return json['token'] as String;
  }

  // GET /perfil com o Bearer token. Retorna os dados do usuário (nome, curso...)
  static Future<Map<String, dynamic>> buscarPerfil(String token) {
    return _requisicao(
      () => http.get(
        Uri.parse('$urlBase/perfil'),
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
  }

  // GET /sair: invalida o token no servidor
  static Future<void> sair(String token) async {
    await _requisicao(
      () => http.get(
        Uri.parse('$urlBase/sair'),
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
  }

  // Executa a requisição e trata os erros.
  // Em caso de erro a API responde {"erro": 401, "codigo": 102, "detalhes": "mensagem"}
  static Future<Map<String, dynamic>> _requisicao(
    Future<http.Response> Function() fazerRequisicao,
  ) async {
    final http.Response resposta;
    try {
      resposta = await fazerRequisicao().timeout(const Duration(seconds: 15));
    } on TimeoutException {
      throw CotemigException('O servidor demorou para responder. Tente novamente.');
    } catch (e) {
      throw CotemigException(
        'Sem conexão com a internet. Verifique sua rede e tente novamente.',
      );
    }

    Map<String, dynamic>? json;
    try {
      json = jsonDecode(utf8.decode(resposta.bodyBytes)) as Map<String, dynamic>;
    } catch (e) {
      json = null; // resposta sem JSON
    }

    if (resposta.statusCode == 200 && json != null) {
      return json;
    }
    throw CotemigException(
      json?['detalhes'] as String? ??
          'Erro ao acessar o Cotemig (código ${resposta.statusCode}).',
    );
  }
}
