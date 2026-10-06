// Tela desenvolvida por Samuel Rocha

import 'package:flutter/material.dart';

import 'buscar_tarefa_screen.dart';
import 'metas_diarias_screen.dart';

class PrincipalScreen extends StatefulWidget {
  const PrincipalScreen({super.key});

  @override
  State<PrincipalScreen> createState() => _PrincipalScreenState();
}

class _PrincipalScreenState extends State<PrincipalScreen> {
  // Dados fixos
  List<String> tarefas = [
    'Estudar Flutter',
    'Fazer atividade da faculdade',
    'Revisar conteúdo',
  ];
  List<bool> concluidas = [false, false, false];

  final _novaTarefaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My daily to do list'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BuscarTarefaScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.flag),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MetasDiariasScreen(),
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
            // Cartão com o dia selecionado
            Card(
              color: Colors.teal[50],
              child: const ListTile(
                leading: Icon(Icons.calendar_today, color: Colors.teal),
                title: Text(
                  'Segunda-feira',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Suas tarefas de hoje'),
              ),
            ),
            const SizedBox(height: 12),

            // Adicionar tarefa
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _novaTarefaController,
                    decoration: const InputDecoration(
                      hintText: 'Nova tarefa',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (_novaTarefaController.text.isNotEmpty) {
                      setState(() {
                        tarefas.add(_novaTarefaController.text);
                        concluidas.add(false);
                      });
                      _novaTarefaController.clear();
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Lista de tarefas
            Expanded(
              child: ListView.builder(
                itemCount: tarefas.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: CheckboxListTile(
                      title: Text(
                        tarefas[index],
                        style: TextStyle(
                          // Risca o texto quando a tarefa está concluída
                          decoration: concluidas[index]
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      value: concluidas[index],
                      onChanged: (valor) {
                        setState(() {
                          concluidas[index] = valor!;
                        });
                      },
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
