// Tela desenvolvida por Igor Rodrigues

import 'package:flutter/material.dart';

class BuscarTarefaScreen extends StatefulWidget {
  const BuscarTarefaScreen({super.key});

  @override
  State<BuscarTarefaScreen> createState() => _BuscarTarefaScreenState();
}

class _BuscarTarefaScreenState extends State<BuscarTarefaScreen> {
  final _formKey = GlobalKey<FormState>();
  bool buscou = false;

  // Resultados fixos
  List<String> resultados = [
    'Estudar Flutter',
    'Fazer atividade',
    'Ir à academia',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buscar Tarefa')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nome da tarefa',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (valor) {
                  if (valor == null || valor.isEmpty) {
                    return 'Digite o nome da tarefa';
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
                      buscou = true;
                    });
                  }
                },
                child: const Text('Buscar'),
              ),
            ),
            const SizedBox(height: 16),

            // A lista só aparece depois de buscar
            if (buscou)
              Expanded(
                child: ListView.builder(
                  itemCount: resultados.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.task_alt, color: Colors.teal),
                        title: Text(resultados[index]),
                      ),
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
