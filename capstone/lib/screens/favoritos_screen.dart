// Tela desenvolvida por Igor Rodrigues

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/favoritos_provider.dart';
import '../widgets/filme_card.dart';
import '../widgets/mensagem_widget.dart';

class FavoritosScreen extends StatelessWidget {
  const FavoritosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // A tela se atualiza sozinha quando um filme é favoritado/desfavoritado
    final provider = context.watch<FavoritosProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Filmes Favoritos')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _conteudo(provider),
      ),
    );
  }

  Widget _conteudo(FavoritosProvider provider) {
    if (provider.carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.erro != null) {
      return MensagemWidget(
        icone: Icons.error_outline,
        titulo: 'Erro nos favoritos',
        texto: provider.erro,
        aoTentarNovamente: () => provider.carregar(),
      );
    }

    if (provider.favoritos.isEmpty) {
      return const MensagemWidget(
        icone: Icons.favorite_border,
        titulo: 'Você ainda não favoritou nenhum filme',
        texto: 'Toque no coração de um filme para guardá-lo aqui.',
      );
    }

    return ListView.builder(
      itemCount: provider.favoritos.length,
      itemBuilder: (context, index) {
        return FilmeCard(filme: provider.favoritos[index]);
      },
    );
  }
}
