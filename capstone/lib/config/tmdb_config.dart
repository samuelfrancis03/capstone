// Configurações de acesso à API do TMDB (https://developer.themoviedb.org/)

class TmdbConfig {
  // API Read Access Token (v4) do TMDB
  static const String token =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0MGE5NDMxNDc0NDQxOWNmM2FkNWY1OTVjM2RmZjgxNiIsIm5iZiI6MTc5MzkwNjk1Ni45MDQsInN1YiI6IjZhZWNkOTBjNjg1OWI3YmFhODhkNWFiOSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.vwKO9n3RL93y7f2f43Gg8aoLUub8VOf8Q4afoVWvZR0';

  // Endereço base da API
  static const String urlBase = 'https://api.themoviedb.org/3';

  // Endereço base das imagens (w500 = largura de 500 pixels)
  static const String urlImagens = 'https://image.tmdb.org/t/p/w500';

  // Idioma dos textos retornados pela API
  static const String idioma = 'pt-BR';
}
