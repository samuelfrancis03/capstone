import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/favoritos_provider.dart';
import 'providers/filme_provider.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(
    // Os providers ficam acima do MaterialApp para que todas as telas
    // consigam acessar o mesmo estado
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => FilmeProvider()),
        // Já carrega os favoritos salvos quando o app abre
        ChangeNotifierProvider(
          create: (context) => FavoritosProvider()..carregar(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

// Cores do app (tema escuro, lembrando uma sala de cinema)
const Color corPrincipal = Color(0xFFE53935); // vermelho cortina de cinema
const Color corFundo = Color(0xFF121218);
const Color corCard = Color(0xFF1E1E26);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Movie List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: corPrincipal,
          brightness: Brightness.dark,
          primary: corPrincipal,
          surface: corCard,
        ),
        scaffoldBackgroundColor: corFundo,
        appBarTheme: const AppBarTheme(
          backgroundColor: corFundo,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          color: corCard,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: corCard,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: corPrincipal,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
