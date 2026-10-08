// Tela desenvolvida por Igor Rodrigues

import 'package:flutter/material.dart';

import '../services/favoritos_service.dart';
import '../widgets/filme_card.dart';

class FavoritosScreen extends StatelessWidget {
  const FavoritosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Filmes Favoritos')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        // Atualiza a tela sempre que um filme é favoritado/desfavoritado
        child: ValueListenableBuilder(
          valueListenable: FavoritosService.favoritos,
          builder: (context, favoritos, child) {
            if (favoritos.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.favorite_border, size: 60, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('Você ainda não favoritou nenhum filme'),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: favoritos.length,
              itemBuilder: (context, index) {
                return FilmeCard(filme: favoritos[index]);
              },
            );
          },
        ),
      ),
    );
  }
}
