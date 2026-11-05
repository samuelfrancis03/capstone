// Capa do filme. Mostra um ícone quando o filme não tem imagem.

import 'package:flutter/material.dart';

class PosterFilme extends StatelessWidget {
  final String? url;
  final double largura;
  final double altura;

  const PosterFilme({
    super.key,
    required this.url,
    required this.largura,
    required this.altura,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: largura,
        height: altura,
        child: url == null
            ? _semImagem()
            : Image.network(
                url!,
                fit: BoxFit.cover,
                // Enquanto a imagem carrega
                loadingBuilder: (context, child, progresso) {
                  if (progresso == null) return child;
                  return Container(
                    color: Colors.white10,
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                },
                errorBuilder: (context, erro, stack) => _semImagem(),
              ),
      ),
    );
  }

  Widget _semImagem() {
    return Container(
      color: Colors.white10,
      child: const Icon(Icons.movie_outlined, size: 40, color: Colors.white38),
    );
  }
}
