# 💊 PharmaIA — Gestão inteligente de clientes

![Flutter](https://img.shields.io/badge/Flutter-3.16+-02569B?style=for-the-badge&logo=flutter&logoColor=white) ![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart&logoColor=white) ![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

**PharmaIA** é um sistema web em Flutter para gerenciamento de clientes em farmácias: cadastro unificado, busca rápida, histórico e ações estratégicas com UI responsiva e design system baseado em Material 3.

---

## 🔎 Conteúdo

- Sobre
- Funcionalidades
- Tecnologias
- Quickstart
- Arquitetura (resumo)
- Como contribuir
- Licença & Contato

---

## Sobre

Hub centralizado para dados de clientes com foco em personalização, produtividade e decisões baseadas em dados. Código organizado para ser testável e escalável (Clean Architecture).

---

## Funcionalidades principais

- Cadastro, edição, visualização e exclusão de clientes
- Busca instantânea + filtros simples
- Histórico e status de cliente
- Feedbacks visuais (snackbars, loading, empty states)
- Layout responsivo (mobile / tablet / desktop)
- Design system (tipografia, paleta, 8pt grid)

---

## Tecnologias

- **Flutter 3.16+**, **Dart 3.0+**
- Material Design 3, Google Fonts
- Recomendações: VS Code / Android Studio, Flutter DevTools

---

## 🏗️ Arquitetura

O projeto implementa **Clean Architecture** com separação clara de responsabilidades:

```
┌─────────────────────────────────────────────┐
│          PRESENTATION LAYER                 │
│  ┌────────────┐  ┌──────────┐  ┌─────────┐ │
│  │   Pages    │  │ Widgets  │  │Controller│ │
│  └────────────┘  └──────────┘  └─────────┘ │
├─────────────────────────────────────────────┤
│            DOMAIN LAYER                     │
│  ┌────────────┐  ┌──────────────────────┐  │
│  │  Entities  │  │ Repository Contracts │  │
│  └────────────┘  └──────────────────────┘  │
├─────────────────────────────────────────────┤
│             DATA LAYER                      │
│  ┌────────────┐  ┌──────────────────────┐  │
│  │   Models   │  │Repository Implements │  │
│  └────────────┘  └──────────────────────┘  │
└─────────────────────────────────────────────┘
```

### 🎯 Princípios Aplicados

#### SOLID

- **S**ingle Responsibility: Cada classe tem uma responsabilidade única
- **O**pen/Closed: Aberto para extensão, fechado para modificação
- **L**iskov Substitution: Subtipos substituíveis por tipos base
- **I**nterface Segregation: Interfaces específicas e coesas
- **D**ependency Inversion: Dependa de abstrações, não implementações

#### DRY (Don't Repeat Yourself)

- Widgets reutilizáveis em `presentation/widgets/`
- Utilitários compartilhados em `core/utils/`
- Constantes centralizadas em `core/constants/`

#### Separation of Concerns

- UI desacoplada da lógica de negócio
- Regras de negócio independentes de frameworks
- Facilita testes e manutenção

## 📦 Instalação

### Pré-requisitos

Certifique-se de ter instalado:

- ✅ [Flutter SDK](https://docs.flutter.dev/get-started/install) `3.16+`
- ✅ [Dart SDK](https://dart.dev/get-dart) `3.0+`
- ✅ Editor de código (VS Code ou Android Studio)
- ✅ [Git](https://git-scm.com/) para controle de versão

### Verificar Instalação

```bash
flutter doctor -v
```

### Passo a Passo

#### 1️⃣ Clone o Repositório

```bash
git clone https://github.com/emanuelabreudev/PharmaIA-Cliente.git
cd PharmaIA-Cliente
```

#### 2️⃣ Instale Dependências

```bash
flutter pub get
```

#### 3️⃣ Execute o Projeto

```bash
# Web (desenvolvimento rápido)
flutter run -d chrome

# Desktop
flutter run -d macos     # macOS
flutter run -d windows   # Windows
flutter run -d linux     # Linux

# Mobile (emulador/dispositivo conectado)
flutter run
```

### 🔧 Configuração Opcional

Crie `.env` na raiz para variáveis de ambiente:

```env
API_BASE_URL=http://localhost:8080
API_TIMEOUT=30000
DEBUG_MODE=true
```

## 📁 Estrutura de Pastas

```
lib/
├── main.dart                          # 🚀 Entry point
├── app/
│   ├── app.dart                       # 🎯 MaterialApp config
│   └── theme/
│       └── app_theme.dart             # 🎨 Theme Material 3
├── core/                              # 🔧 Código compartilhado
│   ├── config/
│   │   └── api_config.dart            # ⚙️ Configurações API
│   ├── constants/
│   │   └── app_colors.dart            # 🎨 Design tokens
│   └── utils/
│       ├── date_formatter.dart        # 📅 Formatação de datas
│       ├── error_message_helper.dart  # 💬 Mensagens de erro
│       ├── phone_formatter.dart       # 📞 Máscaras telefone
│       └── validators.dart            # ✅ Validação de forms
└── features/
    └── clientes/                      # 👥 Feature de clientes
        ├── data/                      # 💾 Camada de dados
        │   ├── models/
        │   │   └── cliente_model.dart # 📊 DTO/Serialização
        │   └── repositories/
        │       └── cliente_repository_impl.dart # 🔌 Implementação
        ├── domain/                    # 🧠 Lógica de negócio
        │   ├── entities/
        │   │   └── cliente.dart       # 🎯 Entidade pura
        │   └── repositories/
        │       └── cliente_repository.dart # 📝 Contrato
        └── presentation/              # 🎨 Interface do usuário
            ├── controllers/
            │   └── clientes_controller.dart # 🎮 State management
            ├── pages/                 # 📄 Telas completas
            │   ├── clientes_page.dart       # 📋 Lista principal
            │   ├── client_details_page.dart # 👁️ Visualização
            │   ├── edit_client_page.dart    # ✏️ Edição
            │   ├── new_client_page.dart     # ➕ Cadastro
            │   └── delete_confirmation_page.dart # 🗑️ Confirmação
            └── widgets/               # 🧩 Componentes reutilizáveis
                ├── app_bar_widget.dart      # 🔝 AppBar custom
                ├── client_card_mobile.dart  # 📱 Card mobile
                ├── client_form.dart         # 📝 Formulário
                ├── empty_state_widget.dart  # 📭 Estado vazio
                ├── labeled_field.dart       # 🏷️ Input com label
                ├── loading_overlay.dart     # ⏳ Loading fullscreen
                ├── loading_state_widget.dart # ⏳ Loading inline
                └── status_badge.dart        # 🟢 Badge status
```

### 📂 Descrição das Pastas

| Pasta           | Responsabilidade                                |
| --------------- | ----------------------------------------------- |
| `app/`          | Configuração geral da aplicação                 |
| `core/`         | Código compartilhado (utils, constants, config) |
| `features/`     | Módulos de funcionalidades isolados             |
| `data/`         | Acesso a dados (API, database)                  |
| `domain/`       | Regras de negócio puras                         |
| `presentation/` | UI e lógica de apresentação                     |

---

---

## Como contribuir

1. Fork → clone
2. Branch: `feature/x` ou `fix/x`
3. Código limpo + testes quando aplicável
4. PR com descrição e passos de teste

Use Conventional Commits (`feat:`, `fix:`, `docs:` etc.).

---

## Contato

- Issues / Discussions: `https://github.com/emanuelabreudev/PharmaIA-Cliente`
- Email: `emanuelabreudev@gmail.com`

---

**[⬆ Voltar ao topo](#-pharmaia---plataforma-inteligente-de-gestão-farmacêutica)**
