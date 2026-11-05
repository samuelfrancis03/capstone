// Guarda a lista de favoritos e avisa as telas quando ela muda.
// A gravação no aparelho fica por conta do FavoritosService.

import 'package:flutter/foundation.dart';

import '../models/filme.dart';
import '../services/favoritos_service.dart';

class FavoritosProvider extends ChangeNotifier {
  List<Filme> favoritos = [];
  bool carregando = false;
  String? erro;

  // Lê os favoritos salvos (chamado quando o app abre)
  Future<void> carregar() async {
    carregando = true;
    erro = null;
    notifyListeners();

    try {
      favoritos = await FavoritosService.carregar();
    } catch (e) {
      erro = 'Não foi possível carregar os favoritos salvos.';
    }

    carregando = false;
    notifyListeners();
  }

  bool ehFavorito(int id) {
    return favoritos.any((f) => f.id == id);
  }

  // Adiciona ou remove o filme. Retorna true se ele virou favorito.
  // Se der erro ao salvar, desfaz a alteração e lança a exceção para a tela.
  Future<bool> alternar(Filme filme) async {
    final anterior = List<Filme>.from(favoritos);
    final adicionou = !ehFavorito(filme.id);

    if (adicionou) {
      favoritos = [...favoritos, filme];
    } else {
      favoritos = favoritos.where((f) => f.id != filme.id).toList();
    }
    notifyListeners();

    try {
      await FavoritosService.salvar(favoritos);
    } catch (e) {
      favoritos = anterior;
      notifyListeners();
      rethrow;
    }
    return adicionou;
  }
}
