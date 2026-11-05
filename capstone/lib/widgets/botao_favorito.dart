// Botão de coração que adiciona ou remove o filme dos favoritos

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/filme.dart';
import '../providers/favoritos_provider.dart';

class BotaoFavorito extends StatelessWidget {
  final Filme filme;

  const BotaoFavorito({super.key, required this.filme});

  Future<void> _alternar(BuildContext context) async {
    final mensageiro = ScaffoldMessenger.of(context);
    final provider = context.read<FavoritosProvider>();

    String mensagem;
    try {
      final adicionou = await provider.alternar(filme);
      mensagem = adicionou
          ? '"${filme.titulo}" adicionado aos favoritos'
          : '"${filme.titulo}" removido dos favoritos';
    } catch (e) {
      mensagem = 'Erro ao salvar os favoritos. Tente novamente.';
    }

    mensageiro.hideCurrentSnackBar();
    mensageiro.showSnackBar(
      SnackBar(content: Text(mensagem), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // watch: o botão se redesenha quando a lista de favoritos muda
    final favorito = context.watch<FavoritosProvider>().ehFavorito(filme.id);

    return IconButton(
      tooltip: favorito ? 'Remover dos favoritos' : 'Adicionar aos favoritos',
      icon: Icon(
        favorito ? Icons.favorite : Icons.favorite_border,
        color: favorito ? Colors.redAccent : Colors.white70,
      ),
      onPressed: () => _alternar(context),
    );
  }
}
