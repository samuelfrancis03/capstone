// Tela desenvolvida por Samuel Rocha

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/filme_provider.dart';
import '../widgets/filme_card.dart';
import '../widgets/mensagem_widget.dart';
import 'buscar_filme_screen.dart';
import 'favoritos_screen.dart';

class PrincipalScreen extends StatefulWidget {
  final String nomeUsuario;

  const PrincipalScreen({super.key, required this.nomeUsuario});

  @override
  State<PrincipalScreen> createState() => _PrincipalScreenState();
}

class _PrincipalScreenState extends State<PrincipalScreen> {
  @override
  void initState() {
    super.initState();
    // Busca os filmes populares assim que a tela abre.
    // addPostFrameCallback evita chamar notifyListeners durante o build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FilmeProvider>().carregarPopulares();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FilmeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Movie List'),
        // Botão de sair no lugar da seta de voltar.
        // O logout em si é feito pela tela de login quando esta tela fecha.
        leading: IconButton(
          tooltip: 'Sair',
          icon: const Icon(Icons.logout),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            tooltip: 'Buscar filme',
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BuscarFilmeScreen(),
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Meus favoritos',
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritosScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho
            Text(
              'Olá, ${widget.nomeUsuario}!',
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.local_fire_department, color: Colors.orange),
                const SizedBox(width: 6),
                const Expanded(
                  child: Text(
                    'Filmes populares',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  tooltip: 'Atualizar',
                  icon: const Icon(Icons.refresh),
                  onPressed: provider.carregandoPopulares
                      ? null
                      : () => provider.carregarPopulares(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(child: _lista(provider)),
          ],
        ),
      ),
    );
  }

  Widget _lista(FilmeProvider provider) {
    if (provider.carregandoPopulares && provider.populares.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.erroPopulares != null) {
      return MensagemWidget(
        icone: Icons.wifi_off,
        titulo: 'Não foi possível carregar os filmes',
        texto: provider.erroPopulares,
        aoTentarNovamente: () => provider.carregarPopulares(),
      );
    }

    if (provider.populares.isEmpty) {
      return MensagemWidget(
        icone: Icons.movie_outlined,
        titulo: 'Nenhum filme disponível no momento',
        aoTentarNovamente: () => provider.carregarPopulares(),
      );
    }

    // Puxar a lista para baixo também atualiza
    return RefreshIndicator(
      onRefresh: () => provider.carregarPopulares(),
      child: ListView.builder(
        itemCount: provider.populares.length,
        itemBuilder: (context, index) {
          return FilmeCard(filme: provider.populares[index]);
        },
      ),
    );
  }
}
