// Tela desenvolvida por Igor Rodrigues

import 'package:flutter/material.dart';

import '../models/filme.dart';
import '../services/filmes_service.dart';
import '../widgets/filme_card.dart';

class BuscarFilmeScreen extends StatefulWidget {
  const BuscarFilmeScreen({super.key});

  @override
  State<BuscarFilmeScreen> createState() => _BuscarFilmeScreenState();
}

class _BuscarFilmeScreenState extends State<BuscarFilmeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _buscaController = TextEditingController();

  // Fica nulo até o usuário fazer a primeira busca
  Future<List<Filme>>? _resultados;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buscar Filme')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _buscaController,
                decoration: const InputDecoration(
                  labelText: 'Nome do filme',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (valor) {
                  if (valor == null || valor.isEmpty) {
                    return 'Digite o nome do filme';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: FilledButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _resultados = FilmesService.buscarPorNome(
                        _buscaController.text,
                      );
                    });
                  }
                },
                child: const Text('Buscar'),
              ),
            ),
            const SizedBox(height: 16),

            // A lista só aparece depois de buscar
            if (_resultados != null)
              Expanded(
                child: FutureBuilder<List<Filme>>(
                  future: _resultados,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('Não foi possível buscar os filmes'),
                      );
                    }

                    final filmes = snapshot.data!;
                    if (filmes.isEmpty) {
                      return const Center(
                        child: Text('Nenhum filme encontrado'),
                      );
                    }
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
