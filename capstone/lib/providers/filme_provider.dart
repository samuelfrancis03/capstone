// Guarda o estado dos filmes populares e da busca, e avisa as telas quando muda

import 'package:flutter/foundation.dart';

import '../models/filme.dart';
import '../services/tmdb_service.dart';

class FilmeProvider extends ChangeNotifier {
  // ----- Filmes populares (tela principal) -----
  List<Filme> populares = [];
  bool carregandoPopulares = false;
  String? erroPopulares;

  // ----- Busca -----
  List<Filme> resultadosBusca = [];
  bool carregandoBusca = false;
  String? erroBusca;
  String? ultimaBusca; // fica nulo até o usuário pesquisar pela primeira vez

  Future<void> carregarPopulares() async {
    carregandoPopulares = true;
    erroPopulares = null;
    notifyListeners();

    try {
      populares = await TmdbService.buscarPopulares();
    } catch (e) {
      erroPopulares = e.toString();
    }

    carregandoPopulares = false;
    notifyListeners();
  }

  Future<void> buscar(String nome) async {
    ultimaBusca = nome;
    carregandoBusca = true;
    erroBusca = null;
    resultadosBusca = [];
    notifyListeners();

    try {
      resultadosBusca = await TmdbService.buscarPorNome(nome);
    } catch (e) {
      erroBusca = e.toString();
    }

    carregandoBusca = false;
    notifyListeners();
  }

  // Detalhes completos de um filme (usado na tela de detalhes)
  Future<Filme> buscarDetalhes(int id) {
    return TmdbService.buscarDetalhes(id);
  }
}
