# 📱 Agenda AI — Frontend

> Aplicativo mobile cross-platform (Android & iOS) para o **Agenda AI** — plataforma de diretório de serviços que conecta clientes com pequenas empresas.

---

## 🛠️ Stack de Tecnologias

| Responsabilidade | Tecnologia |
| :--- | :--- |
| Framework | Flutter 3.x (stable) |
| Linguagem | Dart 3.x |
| Gerenciamento de estado | Riverpod 2 (code-gen) |
| Navegação | go_router |
| HTTP Client | Dio + interceptors |
| Armazenamento seguro | flutter_secure_storage |
| Fontes | Google Fonts — Inter |
| Imagens | cached_network_image |
| Skeleton loaders | shimmer |
| Autenticação social | google_sign_in + sign_in_with_apple |
| Modelos imutáveis | Freezed + json_serializable |
| Carrossel | smooth_page_indicator |

---

## 🏗️ Estrutura de Pastas

```
lib/
├── main.dart                         # Entry point — inicializa ProviderScope
├── app.dart                          # MaterialApp.router + tema + roteador
│
├── core/
│   ├── constants/
│   │   └── api_constants.dart        # URL base e chaves de storage
│   ├── network/
│   │   └── dio_client.dart           # Cliente Dio + AuthInterceptor (refresh automático)
│   ├── router/
│   │   └── app_router.dart           # Rotas go_router + auth guard + ShellRoute
│   ├── shell/
│   │   └── main_shell.dart           # Barra de navegação inferior persistente
│   └── theme/
│       └── app_theme.dart            # Design system: cores, tipografia, temas dark/light
│
├── data/
│   └── models/
│       ├── user_model.dart           # Freezed: User
│       ├── company_model.dart        # Freezed: Company (com Category aninhada)
│       ├── category_model.dart       # Freezed: Category
│       ├── banner_model.dart         # Freezed: Banner (carrossel da Home)
│       └── promotion_model.dart      # Freezed: Promotion
│
├── features/
│   ├── auth/
│   │   ├── providers/
│   │   │   └── auth_provider.dart    # AuthState Riverpod (email, OTP, Google, Apple)
│   │   └── screens/
│   │       ├── tela_login.dart       # Login com todos os métodos
│   │       ├── tela_cadastro.dart    # Cadastro + auto-login
│   │       └── tela_otp.dart         # Verificação de telefone em 2 passos
│   │
│   ├── home/
│   │   ├── screens/
│   │   │   └── tela_principal.dart   # Home com saudação, busca, banners, categorias, empresas
│   │   └── widgets/
│   │       ├── carrossel_banner.dart # PageView com auto-scroll e indicador de pontos
│   │       ├── categorias_rapidas.dart # Scroll horizontal de categorias
│   │       └── card_empresa.dart     # Card de empresa (dark/light)
│   │
│   ├── categories/
│   │   └── screens/
│   │       ├── tela_categorias.dart        # Grade 3 colunas de categorias
│   │       └── tela_detalhe_categoria.dart # Empresas filtradas por categoria
│   │
│   ├── promotions/
│   │   └── screens/
│   │       └── tela_promocoes.dart   # Promoções ativas com badge e validade
│   │
│   └── settings/
│       └── screens/
│           └── tela_configuracoes.dart # Perfil do usuário e logout
│
└── shared/
    └── widgets/
        ├── app_button.dart           # Botão primário com loading state
        ├── app_text_field.dart       # Campo de texto com label
        └── shimmer_list.dart         # Skeleton loaders (Box, Vertical, Horizontal)
```

---

## 🚀 Como Começar

### Pré-requisitos

- Flutter SDK 3.x — [flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
- Dart 3.x (incluído no Flutter SDK)
- Android Studio ou Xcode (para emuladores)
- Backend do Agenda AI rodando localmente

### Instalação

1. **Instale as dependências:**
   ```bash
   flutter pub get
   ```

2. **Gere os arquivos de código (Freezed + Riverpod):**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

3. **Configure a URL da API:**
   Em `lib/core/constants/api_constants.dart`, ajuste `baseUrl` conforme seu ambiente:
   ```dart
   // Emulador Android → localhost
   static const String baseUrl = 'http://10.0.2.2:3000/api/v1';

   // Simulador iOS → localhost
   // static const String baseUrl = 'http://localhost:3000/api/v1';
   ```

4. **Execute o app:**
   ```bash
   flutter run
   ```

---

## 🗺️ Navegação

O app usa uma barra de navegação inferior com **4 abas**, implementada via `ShellRoute` do `go_router` — o estado de cada aba é preservado ao alternar entre elas.

| Aba | Rota | Tela |
| :--- | :--- | :--- |
| Início | `/inicio` | Feed de descoberta com banners, categorias e empresas |
| Categorias | `/categorias` | Grade de todas as categorias de serviço |
| Promoções | `/promocoes` | Lista de promoções ativas |
| Perfil | `/perfil` | Dados do usuário e configurações |

Usuários **não autenticados** são redirecionados automaticamente para `/login`.

---

## 🔐 Autenticação

O `AuthInterceptor` do Dio injeta o `Bearer token` em todas as requisições e **renova o token automaticamente** ao receber um `401` — chamando `/auth/renovar` e reenviando a requisição original de forma transparente.

Métodos suportados:

- ✉️ E-mail + senha
- 📱 OTP via WhatsApp/SMS
- 🔵 Google Sign-In
- 🍎 Apple Sign-In *(obrigatório para App Store)*

---

## 🎨 Design System

O tema é definido em `lib/core/theme/app_theme.dart` e suporta **modo claro e escuro** automaticamente via `ThemeMode.system`.

| Token | Valor |
| :--- | :--- |
| Cor primária | `#6C63FF` (Índigo Violeta) |
| Destaque | `#FF6584` (Coral — promoções) |
| Sucesso | `#22C55E` |
| Fonte | **Inter** (Google Fonts) |
| Grid de espaçamento | 8pt |
| Raio dos cards | 16px |
| Raio dos inputs | 12px |

---

## 🔄 Geração de Código

Os arquivos `*.freezed.dart` e `*.g.dart` **não são versionados** (estão no `.gitignore`). Sempre que modificar um modelo Freezed ou um provider Riverpod, regenere:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Para observar e regenerar automaticamente durante o desenvolvimento:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

---

## 📄 Licença

Este projeto está licenciado sob a licença MIT.
