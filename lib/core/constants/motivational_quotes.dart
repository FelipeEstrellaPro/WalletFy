/// Pool de 35 frases motivacionales de ahorro.
/// Se rota diariamente usando dayOfYear % frases.length.
class MotivationalQuotes {
  MotivationalQuotes._();

  static const List<String> quotes = [
    'Un peso ahorrado hoy es dos pesos mañana. 💪',
    'La riqueza no es de quien gana más, sino de quien guarda mejor. 🏆',
    'El secreto del ahorro: empieza pequeño, piensa en grande. 🚀',
    'Cada depósito es un paso más cerca de tu sueño. 🎯',
    'No es cuánto ganas, sino cuánto conservas lo que construye riqueza. 💎',
    'El mejor momento para ahorrar fue ayer. El segundo mejor es hoy. ⏰',
    'Disciplina financiera hoy, libertad financiera mañana. 🌅',
    'Tu yo del futuro te lo agradecerá. Ahorra ahora. 🙏',
    'Pequeñas gotas llenan grandes océanos. 🌊',
    'El ahorro es la semilla de toda fortuna. 🌱',
    'Los sueños tienen precio. Tu ahorro lo paga. ✨',
    'Un hábito de ahorro diario vale más que mil resoluciones de año nuevo. 📅',
    'La constancia en el ahorro es la clave del éxito financiero. 🔑',
    'No gastes lo que no tienes para impresionar a quien no te importa. 😌',
    'Invierte en tu futuro, empieza con tu ahorro de hoy. 📈',
    'La independencia financiera comienza con una sola decisión: ahorrar. 🦅',
    'El dinero guardado es dinero ganado. 💰',
    'Cada meta alcanzada empieza con la decisión de intentarlo. 🏁',
    'El sacrificio de hoy es el éxito de mañana. 💪',
    'Ahorra como si no tuvieras ingresos, gasta como si no tuvieras ahorros. ⚖️',
    'Tu meta financiera te está esperando. Solo sigue ahorrando. 🌟',
    'La paciencia es el mejor instrumento del ahorrador. ⏳',
    'Cuida tus centavos y los pesos se cuidarán solos. 🪙',
    'El camino hacia la libertad financiera está pavimentado con ahorros. 🛤️',
    'Cada vez que ahorras, te estás pagando a ti primero. 🥇',
    'Vive hoy con moderación para vivir mañana con abundancia. 🌿',
    'El verdadero lujo es no preocuparse por el dinero. Ahorra para eso. 🏖️',
    'Una racha de ahorro construye más que mil intenciones. 🔥',
    'El dinero es un buen sirviente pero un mal amo. Tú decides quién manda. 👑',
    'Los millonarios construyeron su riqueza un ahorro a la vez. 🏗️',
    'La meta más importante es la que tienes frente a ti hoy. 🎖️',
    'Convierte el ahorro en un hábito, no en un esfuerzo. 🧘',
    'Cada porcentaje de progreso es una victoria que celebrar. 🎉',
    'Tu bienestar financiero futuro depende de las decisiones de hoy. 🌈',
    'Sé el héroe de tu propia historia financiera. 🦸',
  ];

  /// Returns the quote for today based on day of year.
  static String get todayQuote {
    final now = DateTime.now();
    final dayOfYear = int.parse(
      '${now.difference(DateTime(now.year)).inDays}',
    );
    return quotes[dayOfYear % quotes.length];
  }

  /// Returns quote for a specific index (for testing).
  static String quoteAt(int index) => quotes[index % quotes.length];
}
