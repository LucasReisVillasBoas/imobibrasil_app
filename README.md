<div align="center">

# ImobiBrasil App

**Plataforma imobiliária premium** · Flutter · Clean Architecture · Riverpod 2.x

[![CI](https://github.com/lucasreisvillasboas/imobibrasil_app/actions/workflows/ci.yml/badge.svg)](https://github.com/lucasreisvillasboas/imobibrasil_app/actions/workflows/ci.yml)
[![Flutter](https://img.shields.io/badge/Flutter-3.41.5-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

</div>

---

## Sobre o Projeto

App Flutter de listagem e gerenciamento de imóveis para o processo seletivo da **ImobiBrasil**. Apresenta uma interface premium com glassmorphism, suporte completo a dark/light mode via design tokens semânticos, animações fluidas e arquitetura escalável.

### Telas

| Tela | Descrição |
|------|-----------|
| **Login** | Autenticação com validação, glass card animado e toggle de tema |
| **Listagem** | Cards premium com Hero animation, shimmer loading, busca e filtros |
| **Detalhe** | SliverAppBar expandida 420px, galeria, características e contato |
| **Formulário** | Criação e edição de imóveis com validação e seções animadas |

---

## Demo

https://github-production-user-asset-6210df.s3.amazonaws.com/60412678/568168488-ce657ac0-81af-4304-9369-a26540e95d25.mp4?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAVCODYLSA53PQK4ZA%2F20260324%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20260324T064551Z&X-Amz-Expires=300&X-Amz-Signature=0c139d9540231f1cc872c1efd5d78e7d690537344486ed9a72f4faa70e19d187&X-Amz-SignedHeaders=host

---

## Arquitetura

Segue **Clean Architecture** com separação estrita de responsabilidades:

```
lib/
├── core/
│   ├── analytics/          # Firebase Analytics service
│   ├── constants/          # App constants (credenciais, assets)
│   ├── router/             # GoRouter + auth guard
│   ├── theme/              # AppColors, AppTheme, design tokens
│   └── utils/              # Formatters (BRL, área)
└── features/
    ├── auth/
    │   ├── data/           # AuthRepositoryImpl (mock 800ms)
    │   ├── domain/         # UserEntity, AuthRepository (abstract)
    │   └── presentation/   # AuthNotifier, LoginScreen
    └── imoveis/
        ├── data/           # ImovelModel, LocalDataSource (Hive + JSON)
        ├── domain/         # ImovelEntity, use cases
        └── presentation/   # ImoveisNotifier, 4 telas, widgets
```

### Design Tokens Semânticos

O sistema de cores usa `ThemeExtension<AppColorTokens>` registrado em ambos os temas. Sem condicionais `isDark` espalhadas pelo código — o Flutter resolve light/dark automaticamente:

```dart
// Antes
color: isDark ? AppColors.darkSurface : AppColors.surface

// Depois
color: context.colors.surface
```

---

## Começando

### Pré-requisitos

- Flutter `>=3.41.5` / Dart `>=3.0.0`
- Firebase project configurado (ou usar mock sem Firebase)

### Instalação

```bash
# Clone o repositório
git clone https://github.com/lucasreisvillasboas/imobibrasil_app.git
cd imobibrasil_app

# Instala dependências
make setup
# ou: flutter pub get
```

### Rodando

```bash
# Web (Chrome)
flutter run -d chrome

# iOS
flutter run -d ios

# Android
flutter run -d android
```

### Credenciais de teste

| Campo | Valor |
|-------|-------|
| E-mail | `corretor@imobibrasil.com.br` |
| Senha | `imobi2026` |

> A tela de login exibe um card "Preencher Automaticamente" para facilitar o acesso durante avaliação.

---

## Comandos de Desenvolvimento

```bash
make help       # Lista todos os comandos disponíveis
make check      # Lint + testes (ideal antes do commit)
make lint       # flutter analyze --fatal-infos --fatal-warnings
make test       # flutter test --reporter expanded
make coverage   # Testes com relatório de cobertura HTML
make build      # flutter build web --release --web-renderer canvaskit
make clean      # flutter clean && flutter pub get
```

---

## Testes

```bash
flutter test --reporter expanded
```

```
✓ AppFormatters toBRL — 6 casos (inteiro, decimal, milhão, negativo…)
✓ ImovelEntity — 3 casos (criação, copyWith, equatable)
✓ ImovelModel — 4 casos (fromJson, toJson, round-trip, defaults)
✓ ImovelFormNotifier — 7 casos (estado inicial, setters, isValid, toEntity)
✓ Widget smoke test — ImobiBrasilApp instancia sem crash

21 testes · 0 falhas
```

---

## CI/CD

Pipeline GitHub Actions com 4 jobs em sequência:

```
push/PR → 🔍 Lint & Format → 🧪 Unit Tests → 🌐 Build Web
                                           ↘ 🍎 Build iOS (só main)
```

| Arquivo | Trigger | Descrição |
|---------|---------|-----------|
| `.github/workflows/ci.yml` | push `main`/`develop`, PR | Pipeline completo |
| `.github/workflows/pr_check.yml` | todo PR aberto/atualizado | Quick check rápido |

---

## 📦 Stack Técnica

| Lib | Versão | Uso |
|-----|--------|-----|
| `flutter_riverpod` | 2.6.x | State management |
| `go_router` | 14.x | Navegação + auth guard |
| `hive_flutter` | 1.1.x | Persistência local |
| `firebase_core` | 3.x | Firebase init |
| `firebase_analytics` | 11.x | Analytics |
| `cached_network_image` | 3.x | Cache de imagens |
| `shimmer` | 3.x | Loading skeleton |
| `flutter_animate` | 4.x | Animações |
| `flutter_svg` | 2.x | Logo SVG |
| `google_fonts` | 6.x | Manrope + Space Grotesk |
| `intl` | 0.19.x | Formatação BRL |

---

## 💡 O que faria com mais tempo

- **Testes de widget e integração** — cobertura das telas principais
- **Internacionalização (i18n)** — suporte a múltiplos idiomas
- **Mapa interativo** — Google Maps na tela de detalhe
- **Galeria de fotos** — múltiplas imagens por imóvel com PageView
- **Filtros avançados** — faixa de preço, área mínima, quartos
- **Backend real** — API REST com autenticação JWT
- **Push notifications** — alertas via Firebase Messaging
- **Acessibilidade** — Semantics widgets e suporte a leitores de tela
- **Onboarding** — tela de boas-vindas animada

---

<div align="center">

Desenvolvido para o processo seletivo da **ImobiBrasil**

<sub>Clean Architecture • Riverpod 2.x • Flutter 3.41.5</sub>

</div>
