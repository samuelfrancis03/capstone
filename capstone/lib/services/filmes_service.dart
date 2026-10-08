// Serviço de filmes com dados fictícios (ainda sem API)

import '../models/filme.dart';

class FilmesService {
  // Filmes fixos usados no app. As fotos são imagens aleatórias do picsum.photos
  static final List<Filme> _filmes = [
    Filme(
      id: 1,
      titulo: 'O Último Horizonte',
      ano: 2023,
      avaliacao: 8.4,
      urlPoster: 'https://picsum.photos/seed/filme1/200/300',
    ),
    Filme(
      id: 2,
      titulo: 'Sombras de Neon',
      ano: 2021,
      avaliacao: 7.6,
      urlPoster: 'https://picsum.photos/seed/filme2/200/300',
    ),
    Filme(
      id: 3,
      titulo: 'A Viagem de Clara',
      ano: 2019,
      avaliacao: 7.9,
      urlPoster: 'https://picsum.photos/seed/filme3/200/300',
    ),
    Filme(
      id: 4,
      titulo: 'Código Vermelho',
      ano: 2024,
      avaliacao: 6.8,
      urlPoster: 'https://picsum.photos/seed/filme4/200/300',
    ),
    Filme(
      id: 5,
      titulo: 'Entre Marés',
      ano: 2018,
      avaliacao: 8.1,
      urlPoster: 'https://picsum.photos/seed/filme5/200/300',
    ),
    Filme(
      id: 6,
      titulo: 'O Guardião da Floresta',
      ano: 2022,
      avaliacao: 7.3,
      urlPoster: 'https://picsum.photos/seed/filme6/200/300',
    ),
    Filme(
      id: 7,
      titulo: 'Noite em São Paulo',
      ano: 2020,
      avaliacao: 6.9,
      urlPoster: 'https://picsum.photos/seed/filme7/200/300',
    ),
    Filme(
      id: 8,
      titulo: 'Planeta Silencioso',
      ano: 2025,
      avaliacao: 8.7,
      urlPoster: 'https://picsum.photos/seed/filme8/200/300',
    ),
  ];

  // Filmes da tela principal
  static Future<List<Filme>> buscarPopulares() async {
    return _filmes;
  }

  // Filtra os filmes pelo nome, sem diferenciar maiúsculas de minúsculas
  static Future<List<Filme>> buscarPorNome(String nome) async {
    return _filmes
        .where((f) => f.titulo.toLowerCase().contains(nome.toLowerCase()))
        .toList();
  }
}
