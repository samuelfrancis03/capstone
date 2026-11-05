// Mensagem centralizada com ícone, usada para erros e listas vazias.
// Se receber "aoTentarNovamente", mostra o botão "Tentar novamente".

import 'package:flutter/material.dart';

class MensagemWidget extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String? texto;
  final VoidCallback? aoTentarNovamente;

  const MensagemWidget({
    super.key,
    required this.icone,
    required this.titulo,
    this.texto,
    this.aoTentarNovamente,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icone, size: 64, color: Colors.white38),
            const SizedBox(height: 12),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (texto != null) ...[
              const SizedBox(height: 8),
              Text(
                texto!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white60),
              ),
            ],
            if (aoTentarNovamente != null) ...[
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: aoTentarNovamente,
                icon: const Icon(Icons.refresh),
                label: const Text('Tentar novamente'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
