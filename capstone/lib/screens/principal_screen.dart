// Tela desenvolvida por Samuel Rocha

import 'package:flutter/material.dart';

import '../models/filme.dart';
import '../services/filmes_service.dart';
import '../widgets/filme_card.dart';
import 'buscar_filme_screen.dart';
import 'favoritos_screen.dart';

class PrincipalScreen extends StatefulWidget {
  const PrincipalScreen({super.key});

  @override
  State<PrincipalScreen> createState() => _PrincipalScreenState();
}

class _PrincipalScreenState extends State<PrincipalScreen> {
  // Busca os filmes populares assim que a tela abre
  late Future<List<Filme>> _filmes = FilmesService.buscarPopulares();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Filmes'),
        actions: [
          IconButton(
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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Cartão de destaque
            Card(
              color: Colors.indigo[50],
              child: const ListTile(
                leading: Icon(Icons.local_movies, color: Colors.indigo),
                title: Text(
                  'Filmes populares',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Os filmes mais vistos do momento'),
              ),
            ),
            const SizedBox(height: 12),

            // Lista de filmes vinda da API
            Expanded(
              child: FutureBuilder<List<Filme>>(
                future: _filmes,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Não foi possível carregar os filmes'),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _filmes = FilmesService.buscarPopulares();
                              });
                            },
                            child: const Text('Tentar novamente'),
                          ),
                        ],
                      ),
                    );
                  }

                  final filmes = snapshot.data!;
                  return ListView.builder(
                    itemCount: filmes.length,
                    itemBuilder: (context, index) {
                      return FilmeCard(filme: filmes[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
