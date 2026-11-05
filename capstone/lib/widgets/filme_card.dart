// Card usado nas listas de filmes (principal, busca e favoritos)

import 'package:flutter/material.dart';

import '../models/filme.dart';
import '../screens/detalhe_filme_screen.dart';
import 'botao_favorito.dart';
import 'poster_filme.dart';

class FilmeCard extends StatelessWidget {
  final Filme filme;

  const FilmeCard({super.key, required this.filme});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        // Ao tocar no card, abre a tela de detalhes
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetalheFilmeScreen(filme: filme),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              // Capa (proporção 2:3, igual aos pôsteres de cinema)
              PosterFilme(url: filme.urlPoster, largura: 80, altura: 120),
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
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Colors.white54,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          filme.ano,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          filme.avaliacao.toStringAsFixed(1),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          ' / 10',
                          style: TextStyle(color: Colors.white54),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              BotaoFavorito(filme: filme),
            ],
          ),
        ),
      ),
    );
  }
}
