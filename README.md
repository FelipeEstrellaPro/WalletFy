# WalletFY 💰
> **Ahorro que Inspira. Crecimiento Claro.**

Una aplicación de escritorio Flutter para gestión de ahorros, metas financieras y motivación, con integración de IA local mediante Ollama.

![WalletFY Logo](assets/images/logo.png)

## ✨ Características

- 🎯 **Planes de ahorro múltiples** con metas personalizables (emoji, color, fecha límite)
- 🔥 **Sistema de rachas** con lógica de gracia (congelación 1 día, reset a los 2 días)
- 📊 **Analíticas completas** — barras, líneas y dona con fl_chart
- 🤖 **Chat con IA local** via Ollama — asesor financiero personalizado
- 🌙 **Temas dinámicos** — 6 seed colors + modo claro/oscuro/sistema (Material 3)
- 📤 **Exportación** a CSV y PDF
- 🔔 **Recordatorios diarios** de ahorro

## 🛠 Stack Tecnológico

| Capa | Tecnología |
|------|-----------|
| Framework | Flutter 3.x (Desktop: Windows/macOS/Linux) |
| Estado | Riverpod 2 + riverpod_generator |
| Base de datos | Drift (SQLite) + drift_flutter |
| Gráficas | fl_chart |
| IA local | Ollama via Dio |
| Animaciones | flutter_animate |
| UI | Material Design 3 + Google Fonts (Inter) |

## 🏗 Arquitectura

```
lib/
├── core/           # Constantes, errores, tema
├── data/           # DB (Drift), DAOs, repos concretos
├── domain/         # Entidades, repos abstractos
└── presentation/   # Providers (Riverpod), páginas, widgets
```

## 🚀 Inicio Rápido

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run -d windows
```

## 🤖 Configuración de Ollama

1. Instala [Ollama](https://ollama.ai)
2. Ejecuta: `ollama pull llama3`
3. En WalletFY → Perfil → Configuración IA, ajusta la URL y modelo

## 📄 Licencia

MIT — Felipe Estrella 2026
