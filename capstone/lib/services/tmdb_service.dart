// Responsável pelas requisições HTTP à API do TMDB

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/tmdb_config.dart';
import '../models/filme.dart';

// Erro com uma mensagem amigável para mostrar na tela
class TmdbException implements Exception {
  final String mensagem;

  TmdbException(this.mensagem);

  @override
  String toString() => mensagem;
}

class TmdbService {
  // GET /movie/popular
  static Future<List<Filme>> buscarPopulares() async {
    final json = await _get('/movie/popular', {});
    return _converterLista(json);
  }

  // GET /search/movie?query={nome}
  static Future<List<Filme>> buscarPorNome(String nome) async {
    final json = await _get('/search/movie', {'query': nome});
    return _converterLista(json);
  }

  // GET /movie/{id}
  static Future<Filme> buscarDetalhes(int id) async {
    final json = await _get('/movie/$id', {});
    return Filme.fromJson(json);
  }

  // Transforma o campo "results" da resposta em uma lista de filmes
  static List<Filme> _converterLista(Map<String, dynamic> json) {
    final resultados = json['results'] as List<dynamic>? ?? [];
    return resultados
        .map((item) => Filme.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  // Faz o GET e trata os possíveis erros
  static Future<Map<String, dynamic>> _get(
    String caminho,
    Map<String, String> parametros,
  ) async {
    final url = Uri.parse('${TmdbConfig.urlBase}$caminho').replace(
      queryParameters: {'language': TmdbConfig.idioma, ...parametros},
    );

    final http.Response resposta;
    try {
      resposta = await http
          .get(
            url,
            headers: {
              'Authorization': 'Bearer ${TmdbConfig.token}',
              'accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 15));
    } on TimeoutException {
      throw TmdbException('O servidor demorou para responder. Tente novamente.');
    } catch (e) {
      throw TmdbException(
        'Sem conexão com a internet. Verifique sua rede e tente novamente.',
      );
    }

    if (resposta.statusCode == 200) {
      return jsonDecode(utf8.decode(resposta.bodyBytes)) as Map<String, dynamic>;
    } else if (resposta.statusCode == 401) {
      throw TmdbException('Token do TMDB inválido ou sem autorização.');
    } else if (resposta.statusCode == 404) {
      throw TmdbException('Filme não encontrado.');
    } else {
      throw TmdbException(
        'Erro ao acessar a API (código ${resposta.statusCode}). Tente novamente.',
      );
    }
  }
}
