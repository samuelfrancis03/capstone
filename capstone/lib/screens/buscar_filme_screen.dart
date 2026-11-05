// Tela desenvolvida por Igor Rodrigues

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/filme_provider.dart';
import '../widgets/filme_card.dart';
import '../widgets/mensagem_widget.dart';

class BuscarFilmeScreen extends StatefulWidget {
  const BuscarFilmeScreen({super.key});

  @override
  State<BuscarFilmeScreen> createState() => _BuscarFilmeScreenState();
}

class _BuscarFilmeScreenState extends State<BuscarFilmeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _buscaController = TextEditingController();

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  void _pesquisar() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus(); // fecha o teclado
      context.read<FilmeProvider>().buscar(_buscaController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FilmeProvider>();

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
                textInputAction: TextInputAction.search,
                decoration: const InputDecoration(
                  labelText: 'Nome do filme',
                  hintText: 'Ex: Interestelar',
                  prefixIcon: Icon(Icons.search),
                ),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'Digite o nome do filme';
                  }
                  if (valor.trim().length < 2) {
                    return 'Digite pelo menos 2 letras';
                  }
                  return null;
                },
                onFieldSubmitted: (_) => _pesquisar(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton.icon(
                onPressed: provider.carregandoBusca ? null : _pesquisar,
                icon: const Icon(Icons.search),
                label: const Text('Pesquisar'),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(child: _resultados(provider)),
          ],
        ),
      ),
    );
  }

  Widget _resultados(FilmeProvider provider) {
    if (provider.ultimaBusca == null) {
      return const MensagemWidget(
        icone: Icons.manage_search,
        titulo: 'Pesquise um filme pelo nome',
        texto: 'Os resultados vêm direto do The Movie Database (TMDB).',
      );
    }

    if (provider.carregandoBusca) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.erroBusca != null) {
      return MensagemWidget(
        icone: Icons.wifi_off,
        titulo: 'Não foi possível buscar os filmes',
        texto: provider.erroBusca,
        aoTentarNovamente: () => provider.buscar(provider.ultimaBusca!),
      );
    }

    if (provider.resultadosBusca.isEmpty) {
      return MensagemWidget(
        icone: Icons.search_off,
        titulo: 'Nenhum filme encontrado',
        texto: 'Não achamos resultados para "${provider.ultimaBusca}".',
      );
    }

    return ListView.builder(
      itemCount: provider.resultadosBusca.length,
      itemBuilder: (context, index) {
        return FilmeCard(filme: provider.resultadosBusca[index]);
      },
    );
  }
}
