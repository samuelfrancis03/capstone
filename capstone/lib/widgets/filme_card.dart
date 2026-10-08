// Card usado nas listas de filmes (principal, busca e favoritos)

import 'package:flutter/material.dart';

import '../models/filme.dart';
import '../services/favoritos_service.dart';

class FilmeCard extends StatelessWidget {
  final Filme filme;

  const FilmeCard({super.key, required this.filme});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          // Foto do filme
          SizedBox(
            width: 80,
            height: 120,
            child: filme.urlPoster != null
                ? Image.network(
                    filme.urlPoster!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, erro, stack) =>
                        const Icon(Icons.broken_image, size: 40),
                  )
                : Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.movie, size: 40),
                  ),
          ),
          const SizedBox(width: 12),

          // Nome, ano e avaliação
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  filme.titulo,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${filme.ano}',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(filme.avaliacao.toStringAsFixed(1)),
                  ],
                ),
              ],
            ),
          ),

          // Botão de favoritar
          ValueListenableBuilder(
            valueListenable: FavoritosService.favoritos,
            builder: (context, favoritos, child) {
              final favorito = FavoritosService.ehFavorito(filme);
              return IconButton(
                icon: Icon(
                  favorito ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: () => FavoritosService.alternar(filme),
              );
            },
          ),
        ],
      ),
    );
  }
}
