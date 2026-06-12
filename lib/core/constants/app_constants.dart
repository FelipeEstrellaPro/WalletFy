/// App-wide constants for WalletFY.
class AppConstants {
  AppConstants._();

  // ── App Info ───────────────────────────────────────────────────
  static const String appName = 'WalletFY';
  static const String appTagline = 'Ahorro que Inspira. Crecimiento Claro.';
  static const String appVersion = '1.0.0';

  // ── Theme seed colors ──────────────────────────────────────────
  static const List<({String name, String hex, String emoji})> seedColors = [
    (name: 'Índigo', hex: '#6366F1', emoji: '💜'),
    (name: 'Esmeralda', hex: '#10B981', emoji: '💚'),
    (name: 'Ámbar', hex: '#F59E0B', emoji: '🧡'),
    (name: 'Rosa', hex: '#EC4899', emoji: '🩷'),
    (name: 'Lavanda', hex: '#8B5CF6', emoji: '🪻'),
    (name: 'Cielo', hex: '#0EA5E9', emoji: '🩵'),
  ];

  // ── Default emojis for goals ───────────────────────────────────
  static const List<String> goalEmojis = [
    '🎯', '🏠', '✈️', '🚗', '💻', '📱', '🎓', '💍',
    '🏋️', '🎸', '📷', '🌴', '⛵', '🐾', '🎮', '🧳',
    '💰', '🏦', '🎁', '🌟', '🔥', '🚀', '🌈', '💎',
    '🍕', '🍷', '☕', '🎬', '📚', '🎨',
  ];

  // ── Chat suggestions ───────────────────────────────────────────
  static const List<String> chatSuggestions = [
    '¿Cómo voy con mis metas?',
    '¿Cuánto debo ahorrar por semana?',
    'Dame un tip de ahorro',
    '¿Cuándo completaré mi meta más cercana?',
    'Analiza mis gastos recientes',
  ];

  // ── Analytics periods ──────────────────────────────────────────
  static const List<String> analyticsPeriods = [
    'Semana', 'Mes', 'Año', 'Todo',
  ];

  // ── Ollama defaults ────────────────────────────────────────────
  static const String defaultOllamaUrl = 'http://localhost:11434';
  static const String defaultOllamaModel = 'llama3';

  // ── Streak thresholds ──────────────────────────────────────────
  static const int streakFireThreshold = 7;
  static const int streakGoldThreshold = 30;
}
