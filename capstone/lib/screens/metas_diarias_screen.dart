// Tela desenvolvida por Igor Rodrigues

import 'package:flutter/material.dart';

class MetasDiariasScreen extends StatefulWidget {
  const MetasDiariasScreen({super.key});

  @override
  State<MetasDiariasScreen> createState() => _MetasDiariasScreenState();
}

class _MetasDiariasScreenState extends State<MetasDiariasScreen> {
  final _formKey = GlobalKey<FormState>();
  final _metaController = TextEditingController();

  // Metas fixas e o progresso de cada uma (de 0.0 a 1.0)
  List<String> metas = [
    'Estudar 2 horas',
    'Beber 2 litros de água',
    'Fazer atividade da faculdade',
  ];
  List<double> progresso = [0.5, 0.75, 0.2];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Metas Diárias')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: metas.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.flag, color: Colors.teal),
                      title: Text(metas[index]),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: LinearProgressIndicator(
                          value: progresso[index],
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      trailing: Text(
                        '${(progresso[index] * 100).toInt()}%',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Formulário para cadastrar uma nova meta
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text(
                        'Cadastrar nova meta',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _metaController,
                        decoration: const InputDecoration(
                          labelText: 'Nova meta',
                          border: OutlineInputBorder(),
                        ),
                        validator: (valor) {
                          if (valor == null || valor.isEmpty) {
                            return 'Digite uma meta';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                metas.add(_metaController.text);
                                progresso.add(0.0);
                              });
                              _metaController.clear();
                            }
                          },
                          child: const Text('Cadastrar meta'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
