# 🎬 My Movie List

Catálogo de filmes em Flutter que usa a API oficial do **The Movie Database (TMDB)**.
Projeto Capstone (A3) da disciplina de **Desenvolvimento para Ambientes Móveis**.

---

## 1. Identificação

| Campo | Informação |
|---|---|
| Aplicativo | My Movie List |
| Squad | _(preencher)_ |
| Integrantes | Samuel Rocha — matrícula _(preencher)_ — contato _(preencher)_ |
|  | Igor Rodrigues — matrícula _(preencher)_ — contato _(preencher)_ |
|  | _(adicionar demais integrantes, se houver)_ |

---

## 2. Sobre o projeto

O **My Movie List** permite que o usuário descubra filmes populares, pesquise títulos pelo nome,
veja informações detalhadas (capa, título, título original, data, avaliação, idioma e sinopse)
e monte a sua lista de filmes favoritos, que fica salva no aparelho.

**Público:** pessoas que gostam de cinema e querem uma forma simples de consultar filmes e
guardar os que querem assistir ou de que gostaram.

**Telas:**

| Tela | Arquivo | O que faz |
|---|---|---|
| Login | `screens/login_screen.dart` | Formulário com nome/usuário e senha (com validação). Não há autenticação real. |
| Principal | `screens/principal_screen.dart` | Lista os filmes populares do TMDB, com atualização (botão e "puxar para baixo"). |
| Buscar Filme | `screens/buscar_filme_screen.dart` | Formulário de pesquisa por nome com resultados da API. |
| Detalhes | `screens/detalhe_filme_screen.dart` | Consulta `/movie/{id}` e mostra todas as informações; botão de favoritar. |
| Favoritos | `screens/favoritos_screen.dart` | Lista dos filmes favoritos salvos no aparelho. |

**Fluxo de navegação** (sempre com `Navigator.push` e voltando com `Navigator.pop`/botão voltar):

```
Login ──► Principal ──► Buscar Filme ──► Detalhes
              │
              ├──────► Favoritos ──────► Detalhes
              │
              └──────► Detalhes
```

---

## 3. Requisitos atendidos

| # | Requisito | Onde foi implementado |
|---|---|---|
| 1 | Pelo menos 4 telas com `Navigator.push` e `pop` | 5 telas. `push` em `login_screen.dart`, `principal_screen.dart` e `widgets/filme_card.dart`; retorno pelo botão voltar da AppBar (`pop`). |
| 2 | API REST com pacote `http` e `async/await`, dados reais | `services/tmdb_service.dart` (`/movie/popular`, `/search/movie`, `/movie/{id}`). |
| 3 | Loading e erro visíveis na interface | `CircularProgressIndicator` / `LinearProgressIndicator` e `widgets/mensagem_widget.dart` (com "Tentar novamente") nas telas Principal, Busca, Detalhes e Favoritos. |
| 4 | Formulário com `Form` e `validator` | `login_screen.dart` (nome e senha) e `buscar_filme_screen.dart` (nome do filme). |
| 5 | Lista dinâmica com `ListView.builder` | `principal_screen.dart`, `buscar_filme_screen.dart` e `favoritos_screen.dart`. |
| 6 | `SharedPreferences` persistindo dados ao reabrir | `services/favoritos_service.dart` (salva/lê) + `providers/favoritos_provider.dart` (carrega ao abrir o app). |
| 7 | Provider separando telas, HTTP e preferências | `providers/filme_provider.dart` e `providers/favoritos_provider.dart`, registrados no `MultiProvider` em `main.dart`. As telas só falam com os providers. |
| 8 | App abrindo e percorrendo o fluxo sem crashar | Erros tratados em todas as chamadas; teste automatizado do fluxo em `test/app_test.dart`. |

---

## 4. API e dados remotos

- **API:** The Movie Database (TMDB) — <https://developer.themoviedb.org/>
- **Tipo:** API REST pública, respostas em JSON
- **URL base:** `https://api.themoviedb.org/3`
- **Imagens:** `https://image.tmdb.org/t/p/w500` + `poster_path`
- **Idioma:** todas as requisições usam `language=pt-BR`
- **Autenticação:** API Read Access Token enviado nos cabeçalhos:
  ```
  Authorization: Bearer SEU_TOKEN
  accept: application/json
  ```

| Endpoint | Método | Usado em | Dados usados |
|---|---|---|---|
| `/movie/popular` | GET | Tela Principal | `results[]` com `id`, `title`, `release_date`, `vote_average`, `poster_path` |
| `/search/movie?query={nome}` | GET | Buscar Filme | mesmos campos do item acima |
| `/movie/{id}` | GET | Detalhes | `title`, `original_title`, `release_date`, `vote_average`, `overview`, `original_language`, `poster_path` |

**Erros tratados:** sem internet, tempo esgotado (15 s), token inválido (401),
filme não encontrado (404) e outros códigos HTTP. Filmes sem capa mostram um ícone no lugar da imagem.

---

## 5. Como rodar

**Versão do Flutter usada:** Flutter 3.47.2 (canal stable), Dart SDK `^3.13.2`.

### 5.1 Token do TMDB

O token da API já está configurado em `lib/config/tmdb_config.dart`. Para usar outro token,
gere um em <https://www.themoviedb.org/settings/api> (**API Read Access Token**) e troque o valor
da constante `token` nesse arquivo.

### 5.2 Comandos

```bash
cd capstone
flutter pub get
flutter run
```

Para rodar os testes automatizados:

```bash
flutter test
```

### 5.3 Plataformas

O projeto foi criado com suporte a Android, iOS, Web, Windows, macOS e Linux.

O que foi verificado até agora:

- `flutter analyze` sem nenhum problema;
- `flutter test` com 6 testes passando (modelo, persistência dos favoritos, validação do login e navegação entre as telas);
- compilação para **Web** (`flutter build web`) concluída com sucesso;
- chamadas reais ao TMDB pelo `TmdbService` com o token do projeto: populares, busca e detalhes
  retornando dados em português; token inválido (401) e filme inexistente (404) tratados.

> ⚠️ _(Atualizar esta seção depois de testar o app com um token válido em um emulador/celular Android ou no Chrome.)_

> No **Windows**, rodar o app como aplicativo desktop exige ativar o **Modo de Desenvolvedor**
> (`start ms-settings:developers`), porque o plugin `shared_preferences` precisa de links simbólicos.
> Para Android e Chrome isso não é necessário.

---

## 6. Backend local

Este projeto **não possui backend próprio**. Todos os dados de filmes vêm da API pública do TMDB.
O login é apenas um formulário com validação (não existe cadastro nem verificação de senha), e os
favoritos ficam salvos localmente no aparelho com `SharedPreferences`.

---

## 7. Estrutura do código

```
capstone/
├── lib/
│   ├── main.dart                     # Inicia o app, registra os Providers e define o tema
│   ├── config/
│   │   └── tmdb_config.dart          # URL base, URL das imagens, idioma e token
│   ├── models/
│   │   └── filme.dart                # Classe Filme (fromJson / toJson, ano, data, URL da capa)
│   ├── services/
│   │   ├── tmdb_service.dart         # Requisições HTTP ao TMDB e tratamento de erros
│   │   └── favoritos_service.dart    # Salva e lê os favoritos com SharedPreferences
│   ├── providers/
│   │   ├── filme_provider.dart       # Estado dos populares, da busca e acesso aos detalhes
│   │   └── favoritos_provider.dart   # Estado da lista de favoritos (adicionar/remover)
│   ├── screens/
│   │   ├── login_screen.dart
│   │   ├── principal_screen.dart
│   │   ├── buscar_filme_screen.dart
│   │   ├── detalhe_filme_screen.dart
│   │   └── favoritos_screen.dart
│   └── widgets/
│       ├── filme_card.dart           # Card da lista (capa, título, ano, nota, favorito)
│       ├── poster_filme.dart         # Capa com carregamento e ícone para filme sem imagem
│       ├── botao_favorito.dart       # Coração que favorita/desfavorita
│       └── mensagem_widget.dart      # Mensagens de erro e lista vazia
├── test/
│   └── app_test.dart                 # Testes automatizados
└── pubspec.yaml                      # Dependências: http, provider, shared_preferences
```

**Separação de responsabilidades:**
Telas (interface) → Providers (estado, `ChangeNotifier`) → Services (HTTP e SharedPreferences).

---

## 8. Observações

**Funcionalidades implementadas**

- Login com validação de campos;
- Filmes populares do TMDB com atualização;
- Busca de filmes por nome;
- Detalhes completos do filme consultados pelo ID;
- Favoritar/desfavoritar em qualquer tela, sem duplicar filmes, com aviso (SnackBar);
- Favoritos salvos no aparelho e carregados quando o app abre;
- Mensagens de carregamento, erro (com "Tentar novamente") e lista vazia;
- Tema escuro com cores de cinema.

**Limitações**

- O login não é real (não existe cadastro nem conferência de senha);
- Só é carregada a primeira página de resultados da API (20 filmes);
- Os favoritos ficam somente no aparelho (não sincronizam entre dispositivos);
- Alguns filmes não têm sinopse em português no TMDB; nesse caso aparece um aviso.

**Melhorias futuras**

- Paginação ("carregar mais") nas listas;
- Uso do endpoint `/discover/movie` para filtrar por gênero e ano;
- Mostrar elenco, gêneros e trailer na tela de detalhes;
- Login real com conta do TMDB.
