// Modelo de um filme

import '../config/tmdb_config.dart';

class Filme {
  final int id;
  final String titulo;
  final String? tituloOriginal;
  final String? dataLancamento; // formato da API: "2024-05-30"
  final double avaliacao;
  final String? sinopse;
  final String? idiomaOriginal;
  final String? posterPath; // ex: "/abc123.jpg"

  Filme({
    required this.id,
    required this.titulo,
    this.tituloOriginal,
    this.dataLancamento,
    required this.avaliacao,
    this.sinopse,
    this.idiomaOriginal,
    this.posterPath,
  });

  // Cria um Filme a partir do JSON da API do TMDB.
  // Também é usado para ler os favoritos salvos, pois salvamos no mesmo formato.
  factory Filme.fromJson(Map<String, dynamic> json) {
    return Filme(
      id: json['id'] as int,
      titulo: (json['title'] ?? 'Sem título') as String,
      tituloOriginal: json['original_title'] as String?,
      dataLancamento: json['release_date'] as String?,
      avaliacao: ((json['vote_average'] ?? 0) as num).toDouble(),
      sinopse: json['overview'] as String?,
      idiomaOriginal: json['original_language'] as String?,
      posterPath: json['poster_path'] as String?,
    );
  }

  // Converte o filme em JSON para salvar no SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': titulo,
      'original_title': tituloOriginal,
      'release_date': dataLancamento,
      'vote_average': avaliacao,
      'overview': sinopse,
      'original_language': idiomaOriginal,
      'poster_path': posterPath,
    };
  }

  // Ano de lançamento, ou "----" quando a API não informa a data
  String get ano {
    if (dataLancamento == null || dataLancamento!.length < 4) return '----';
    return dataLancamento!.substring(0, 4);
  }

  // Data no formato brasileiro: 30/05/2024
  String get dataFormatada {
    final partes = (dataLancamento ?? '').split('-');
    if (partes.length != 3) return 'Data não informada';
    return '${partes[2]}/${partes[1]}/${partes[0]}';
  }

  // Endereço completo da capa, ou null quando o filme não tem imagem
  String? get urlPoster {
    if (posterPath == null || posterPath!.isEmpty) return null;
    return '${TmdbConfig.urlImagens}$posterPath';
  }
}
