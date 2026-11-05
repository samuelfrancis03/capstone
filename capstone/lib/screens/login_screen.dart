// Tela desenvolvida por Samuel Rocha

import 'package:flutter/material.dart';

import 'principal_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _senhaController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  // Não existe autenticação real: só confere se os campos foram preenchidos
  void _entrar() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              PrincipalScreen(nomeUsuario: _nomeController.text.trim()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Icon(
                    Icons.movie_filter,
                    size: 90,
                    color: Color(0xFFE53935),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'My Movie List',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Descubra, pesquise e favorite seus filmes.',
                    style: TextStyle(color: Colors.white60),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _nomeController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Nome ou usuário',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (valor) {
                      if (valor == null || valor.trim().isEmpty) {
                        return 'Digite o seu nome ou usuário';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _senhaController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Senha',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (valor) {
                      if (valor == null || valor.isEmpty) {
                        return 'Digite a sua senha';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => _entrar(),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton(
                      onPressed: _entrar,
                      child: const Text('Entrar', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
