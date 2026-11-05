// Guarda o usuário logado enquanto o app está aberto.
// O token fica só na memória: ao fechar o app é preciso entrar de novo.
// A senha não é guardada em lugar nenhum.

import 'package:flutter/foundation.dart';

import '../services/cotemig_service.dart';

class AuthProvider extends ChangeNotifier {
  String? token;
  String? nome;
  bool carregando = false;
  String? erro;

  // Faz o login. Retorna true se deu certo.
  Future<bool> entrar(String usuario, String senha) async {
    carregando = true;
    erro = null;
    notifyListeners();

    try {
      final novoToken = await CotemigService.autenticar(usuario, senha);
      final perfil = await CotemigService.buscarPerfil(novoToken);
      token = novoToken;
      nome = (perfil['nome'] ?? usuario) as String;
    } catch (e) {
      erro = e.toString();
    }

    carregando = false;
    notifyListeners();
    return erro == null;
  }

  Future<void> sair() async {
    final tokenAtual = token;
    token = null;
    nome = null;
    notifyListeners();

    // Avisa o servidor para invalidar o token. Se falhar (ex: sem internet),
    // o usuário sai do app do mesmo jeito.
    if (tokenAtual != null) {
      try {
        await CotemigService.sair(tokenAtual);
      } catch (e) {
        // ignora
      }
    }
  }
}
