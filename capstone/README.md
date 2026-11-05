# 🎬 My Movie List

Catálogo de filmes em Flutter que usa a API oficial do **The Movie Database (TMDB)**.
Projeto Capstone da disciplina de **Desenvolvimento para Ambientes Móveis**.

---

## 1. Identificação

| Campo | Informação |
|---|---|
| Aplicativo | My Movie List |
| Integrantes | Samuel Rocha — 72200812 — 72200812@faculdadecotemig.br|
|  | Igor Rodrigues — 72500085 — 725000852@faculdadecotemig.br |


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
| Login | `screens/login_screen.dart` | Formulário com usuário e senha (com validação) que autentica na API do Cotemig. |
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
| 2 | API REST com pacote `http` e `async/await`, dados reais | `services/tmdb_service.dart` (`/movie/popular`, `/search/movie`, `/movie/{id}`) e `services/cotemig_service.dart` (login: `/autenticacao`, `/perfil`, `/sair`). |
| 3 | Loading e erro visíveis na interface | `CircularProgressIndicator` / `LinearProgressIndicator` e `widgets/mensagem_widget.dart` (com "Tentar novamente") nas telas Principal, Busca, Detalhes e Favoritos; loading no botão e mensagem de erro no Login. |
| 4 | Formulário com `Form` e `validator` | `login_screen.dart` (usuário e senha) e `buscar_filme_screen.dart` (nome do filme). |
| 5 | Lista dinâmica com `ListView.builder` | `principal_screen.dart`, `buscar_filme_screen.dart` e `favoritos_screen.dart`. |
| 6 | `SharedPreferences` persistindo dados ao reabrir | `services/favoritos_service.dart` (salva/lê) + `providers/favoritos_provider.dart` (carrega ao abrir o app). |
| 7 | Provider separando telas, HTTP e preferências | `providers/auth_provider.dart`, `providers/filme_provider.dart` e `providers/favoritos_provider.dart`, registrados no `MultiProvider` em `main.dart`. As telas só falam com os providers. |
| 8 | App abrindo e percorrendo o fluxo sem crashar | Erros tratados em todas as chamadas; teste automatizado do fluxo em `test/app_test.dart`. |

---

## 4. API e dados remotos

- **API:** The Movie Database (TMDB) — <https://developer.themoviedb.org/>
- **Tipo:** API REST pública, respostas em JSON
- **URL base:** `https://api.themoviedb.org/3`
- **Imagens:** `https://image.tmdb.org/t/p/w500` + `poster_path`
- **Idioma:** todas as requisições usam `language=pt-BR`

| Endpoint | Método | Usado em | Dados usados |
|---|---|---|---|
| `/movie/popular` | GET | Tela Principal | `results[]` com `id`, `title`, `release_date`, `vote_average`, `poster_path` |
| `/search/movie?query={nome}` | GET | Buscar Filme | mesmos campos do item acima |
| `/movie/{id}` | GET | Detalhes | `title`, `original_title`, `release_date`, `vote_average`, `overview`, `original_language`, `poster_path` |

**Erros tratados:** sem internet, tempo esgotado (15 s), token inválido (401),
filme não encontrado (404) e outros códigos HTTP. Filmes sem capa mostram um ícone no lugar da imagem.

### API do Cotemig (login)

- **Documentação:** <https://api.cotemig.com.br/v1/doc/>
- **Tipo:** API REST, respostas em JSON
- **URL base:** `https://api.cotemig.com.br/v1`
- **Autenticação:** o usuário e a senha são enviados uma única vez com **Basic Auth**
  (`Authorization: Basic base64(usuario:senha)`) para gerar um **Bearer token** de 25 minutos
  (`longaDuracao: false`), usado nas chamadas seguintes. A senha não é salva.

| Endpoint | Método | Autenticação | Uso |
|---|---|---|---|
| `/autenticacao` | POST | Basic | Gera o token (`{"token": "..."}`) |
| `/perfil` | GET | Bearer | Busca o `nome` do usuário para mostrar na tela Principal |
| `/sair` | GET | Bearer | Invalida o token quando o usuário sai |

Em caso de erro a API responde `{"erro": 401, "codigo": ..., "detalhes": "mensagem"}` e o app mostra
o texto de `detalhes` na tela de login (ex.: "Usuário ou senha não conferem.").

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

### 5.3 Plataformas

O projeto foi criado com suporte a Android, iOS, Web, Windows, macOS e Linux.

---

## 6. Backend local

Este projeto **não possui backend próprio**. Os dados de filmes vêm da API pública do TMDB e o
login usa a API do Cotemig (o app não tem cadastro de usuários). Os favoritos ficam salvos
localmente no aparelho com `SharedPreferences`.

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
│   │   ├── cotemig_service.dart      # Login na API do Cotemig (autenticação, perfil e sair)
│   │   └── favoritos_service.dart    # Salva e lê os favoritos com SharedPreferences
│   ├── providers/
│   │   ├── auth_provider.dart        # Usuário logado (token e nome), entrar e sair
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

- Login com a conta do Cotemig (usuário e senha), com validação de campos e logout;
- Filmes populares do TMDB com atualização;
- Busca de filmes por nome;
- Detalhes completos do filme consultados pelo ID;
- Favoritar/desfavoritar em qualquer tela, sem duplicar filmes, com aviso (SnackBar);
- Favoritos salvos no aparelho e carregados quando o app abre;
- Mensagens de carregamento, erro (com "Tentar novamente") e lista vazia;
- Tema escuro com cores de cinema.

**Limitações**

- O login vale só enquanto o app está aberto: ao fechar o app é preciso entrar de novo;
- Só é carregada a primeira página de resultados da API (20 filmes);
- Os favoritos ficam somente no aparelho (não sincronizam entre dispositivos);
- Alguns filmes não têm sinopse em português no TMDB; nesse caso aparece um aviso.

