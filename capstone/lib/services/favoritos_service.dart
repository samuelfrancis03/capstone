// Salva e recupera os filmes favoritos no aparelho usando SharedPreferences

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/filme.dart';

class FavoritosService {
  static const String _chave = 'filmes_favoritos';

  // Lê os favoritos salvos. Cada filme fica guardado como um texto JSON.
  static Future<List<Filme>> carregar() async {
    final prefs = await SharedPreferences.getInstance();
    final lista = prefs.getStringList(_chave) ?? [];
    return lista
        .map((texto) => Filme.fromJson(jsonDecode(texto) as Map<String, dynamic>))
        .toList();
  }

  // Grava a lista inteira de favoritos
  static Future<void> salvar(List<Filme> filmes) async {
    final prefs = await SharedPreferences.getInstance();
    final lista = filmes.map((filme) => jsonEncode(filme.toJson())).toList();
    final ok = await prefs.setStringList(_chave, lista);
    if (!ok) {
      throw Exception('Não foi possível salvar os favoritos');
    }
  }
}
