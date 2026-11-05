import 'package:capstone/main.dart';
import 'package:capstone/models/filme.dart';
import 'package:capstone/providers/favoritos_provider.dart';
import 'package:capstone/providers/filme_provider.dart';
import 'package:capstone/services/favoritos_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// JSON no mesmo formato que a API do TMDB retorna
final jsonExemplo = {
  'id': 157336,
  'title': 'Interestelar',
  'original_title': 'Interstellar',
  'release_date': '2014-11-05',
  'vote_average': 8.4,
  'overview': 'Uma equipe de exploradores viaja através de um buraco de minhoca.',
  'original_language': 'en',
  'poster_path': '/abc.jpg',
};

Widget criarApp() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => FilmeProvider()),
      ChangeNotifierProvider(create: (context) => FavoritosProvider()..carregar()),
    ],
    child: const MyApp(),
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Modelo Filme', () {
    test('lê o JSON da API', () {
      final filme = Filme.fromJson(jsonExemplo);
      expect(filme.titulo, 'Interestelar');
      expect(filme.ano, '2014');
      expect(filme.dataFormatada, '05/11/2014');
      expect(filme.urlPoster, 'https://image.tmdb.org/t/p/w500/abc.jpg');
    });

    test('filme sem data e sem imagem', () {
      final filme = Filme.fromJson({
        'id': 1,
        'title': 'Sem dados',
        'release_date': '',
        'vote_average': 0,
        'poster_path': null,
      });
      expect(filme.ano, '----');
      expect(filme.urlPoster, isNull);
    });
  });

  group('Favoritos', () {
    test('salva e recupera do SharedPreferences', () async {
      final provider = FavoritosProvider();
      await provider.alternar(Filme.fromJson(jsonExemplo));

      // Simula reabrir o app: outro provider lendo o armazenamento
      final reaberto = FavoritosProvider();
      await reaberto.carregar();
      expect(reaberto.favoritos.length, 1);
      expect(reaberto.favoritos.first.titulo, 'Interestelar');
      expect(reaberto.favoritos.first.sinopse, isNotNull);
    });

    test('não duplica e remove ao alternar de novo', () async {
      final provider = FavoritosProvider();
      final filme = Filme.fromJson(jsonExemplo);

      expect(await provider.alternar(filme), isTrue);
      expect(provider.ehFavorito(filme.id), isTrue);
      expect(await provider.alternar(filme), isFalse);
      expect(provider.favoritos, isEmpty);
      expect(await FavoritosService.carregar(), isEmpty);
    });
  });

  group('Fluxo de telas', () {
    testWidgets('login valida campos vazios', (tester) async {
      await tester.pumpWidget(criarApp());
      await tester.tap(find.text('Entrar'));
      await tester.pump();

      expect(find.text('Digite o seu nome ou usuário'), findsOneWidget);
      expect(find.text('Digite a sua senha'), findsOneWidget);
    });

    testWidgets('login -> principal -> busca -> favoritos sem crashar',
        (tester) async {
      await tester.pumpWidget(criarApp());

      await tester.enterText(find.byType(TextFormField).at(0), 'Samuel');
      await tester.enterText(find.byType(TextFormField).at(1), '123');
      await tester.tap(find.text('Entrar'));
      await tester.pumpAndSettle();

      // Nos testes o Flutter bloqueia a internet, então a tela mostra o erro tratado
      expect(find.text('Olá, Samuel!'), findsOneWidget);
      expect(find.text('Não foi possível carregar os filmes'), findsOneWidget);
      expect(find.text('Tentar novamente'), findsOneWidget);

      // Busca: validator impede pesquisa vazia
      await tester.tap(find.byTooltip('Buscar filme'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Pesquisar'));
      await tester.pump();
      expect(find.text('Digite o nome do filme'), findsOneWidget);

      // Volta e abre os favoritos (lista vazia)
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Meus favoritos'));
      await tester.pumpAndSettle();
      expect(find.text('Você ainda não favoritou nenhum filme'), findsOneWidget);
    });
  });
}
