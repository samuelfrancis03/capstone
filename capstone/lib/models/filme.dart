// Modelo de um filme

class Filme {
  final int id;
  final String titulo;
  final int ano;
  final double avaliacao;
  final String? urlPoster;

  Filme({
    required this.id,
    required this.titulo,
    required this.ano,
    required this.avaliacao,
    this.urlPoster,
  });
}
