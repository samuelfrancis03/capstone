// Tela de detalhes do filme

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/filme.dart';
import '../providers/filme_provider.dart';
import '../widgets/botao_favorito.dart';
import '../widgets/poster_filme.dart';

class DetalheFilmeScreen extends StatefulWidget {
  // Filme vindo da lista. Usamos o id dele para buscar os detalhes completos.
  final Filme filme;

  const DetalheFilmeScreen({super.key, required this.filme});

  @override
  State<DetalheFilmeScreen> createState() => _DetalheFilmeScreenState();
}

class _DetalheFilmeScreenState extends State<DetalheFilmeScreen> {
  late Future<Filme> _detalhes;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  void _carregar() {
    _detalhes = context.read<FilmeProvider>().buscarDetalhes(widget.filme.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Filme>(
      future: _detalhes,
      builder: (context, snapshot) {
        // Enquanto carrega (ou se der erro), mostra os dados que já temos
        final filme = snapshot.data ?? widget.filme;
        final carregando = snapshot.connectionState == ConnectionState.waiting;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Detalhes'),
            actions: [BotaoFavorito(filme: filme)],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (carregando) const LinearProgressIndicator(),
                if (snapshot.hasError) _avisoErro(snapshot.error.toString()),
                const SizedBox(height: 8),
                Center(
                  child: PosterFilme(
                    url: filme.urlPoster,
                    largura: 200,
                    altura: 300,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  filme.titulo,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (filme.tituloOriginal != null &&
                    filme.tituloOriginal != filme.titulo)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Título original: ${filme.tituloOriginal}',
                      style: const TextStyle(color: Colors.white60),
                    ),
                  ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _etiqueta(
                      Icons.star,
                      '${filme.avaliacao.toStringAsFixed(1)} / 10',
                      Colors.amber,
                    ),
                    _etiqueta(
                      Icons.calendar_today,
                      filme.dataFormatada,
                      Colors.white70,
                    ),
                    if (filme.idiomaOriginal != null)
                      _etiqueta(
                        Icons.language,
                        'Idioma: ${filme.idiomaOriginal!.toUpperCase()}',
                        Colors.white70,
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Sinopse',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  (filme.sinopse == null || filme.sinopse!.isEmpty)
                      ? 'Sinopse não disponível em português.'
                      : filme.sinopse!,
                  style: const TextStyle(fontSize: 15, height: 1.5),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Pequeno "chip" com ícone e texto
  Widget _etiqueta(IconData icone, String texto, Color cor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icone, size: 16, color: cor),
          const SizedBox(width: 6),
          Text(texto),
        ],
      ),
    );
  }

  Widget _avisoErro(String mensagem) {
    return Card(
      color: Colors.red.shade900,
      child: ListTile(
        leading: const Icon(Icons.error_outline, color: Colors.white),
        title: const Text('Não foi possível carregar todos os detalhes'),
        subtitle: Text(mensagem),
        trailing: IconButton(
          tooltip: 'Tentar novamente',
          icon: const Icon(Icons.refresh, color: Colors.white),
          onPressed: () => setState(_carregar),
        ),
      ),
    );
  }
}
