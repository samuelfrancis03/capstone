// Guarda os filmes favoritados enquanto o app está aberto

import 'package:flutter/foundation.dart';

import '../models/filme.dart';

class FavoritosService {
  // As telas escutam essa lista para atualizar quando ela mudar
  static final ValueNotifier<List<Filme>> favoritos = ValueNotifier([]);

  static bool ehFavorito(Filme filme) {
    return favoritos.value.any((f) => f.id == filme.id);
  }

  static void alternar(Filme filme) {
    if (ehFavorito(filme)) {
      favoritos.value = favoritos.value.where((f) => f.id != filme.id).toList();
    } else {
      favoritos.value = [...favoritos.value, filme];
    }
  }
}
