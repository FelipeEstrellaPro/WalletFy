import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// WalletFY Material 3 Theme System.
class AppTheme {
  AppTheme._();

  // ── Color conversion helper ────────────────────────────────────
  static Color hexToColor(String hex) {
    final cleaned = hex.replaceAll('#', '').trim();
    final value = int.tryParse(cleaned, radix: 16) ?? 0xFF6366F1;
    return Color(value | 0xFF000000);
  }

  // ── Base text theme using Inter ────────────────────────────────
  static TextTheme _buildTextTheme(ColorScheme scheme) {
    return GoogleFonts.interTextTheme(
      TextTheme(
        displayLarge: TextStyle(
            fontSize: 57, fontWeight: FontWeight.w700, color: scheme.onSurface),
        displayMedium: TextStyle(
            fontSize: 45, fontWeight: FontWeight.w700, color: scheme.onSurface),
        displaySmall: TextStyle(
            fontSize: 36, fontWeight: FontWeight.w600, color: scheme.onSurface),
        headlineLarge: TextStyle(
            fontSize: 32, fontWeight: FontWeight.w700, color: scheme.onSurface),
        headlineMedium: TextStyle(
            fontSize: 28, fontWeight: FontWeight.w600, color: scheme.onSurface),
        headlineSmall: TextStyle(
            fontSize: 24, fontWeight: FontWeight.w600, color: scheme.onSurface),
        titleLarge: TextStyle(
            fontSize: 22, fontWeight: FontWeight.w600, color: scheme.onSurface),
        titleMedium: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w500, color: scheme.onSurface),
        titleSmall: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w500, color: scheme.onSurface),
        bodyLarge: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w400, color: scheme.onSurface),
        bodyMedium: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w400, color: scheme.onSurface),
        bodySmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: scheme.onSurfaceVariant),
        labelLarge: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: scheme.onSurface),
        labelMedium: TextStyle(
            fontSize: 12, fontWeight: FontWeight.w500, color: scheme.onSurface),
        labelSmall: TextStyle(
            fontSize: 11, fontWeight: FontWeight.w500, color: scheme.onSurface),
      ),
    );
  }

  // ── Build ThemeData from seed color + brightness ───────────────
  static ThemeData buildTheme({
    required String seedColorHex,
    required Brightness brightness,
  }) {
    final seedColor = hexToColor(seedColorHex);

    ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );

    final hsl = HSLColor.fromColor(seedColor);
    final h = hsl.hue;

    if (brightness == Brightness.dark) {
      scheme = scheme.copyWith(
        surface: HSLColor.fromAHSL(1.0, h, 0.20, 0.08).toColor(),
        surfaceContainerLowest: HSLColor.fromAHSL(1.0, h, 0.25, 0.05).toColor(),
        surfaceContainerLow: HSLColor.fromAHSL(1.0, h, 0.20, 0.12).toColor(),
        surfaceContainer: HSLColor.fromAHSL(1.0, h, 0.20, 0.16).toColor(),
        surfaceContainerHigh: HSLColor.fromAHSL(1.0, h, 0.20, 0.20).toColor(),
        surfaceContainerHighest: HSLColor.fromAHSL(1.0, h, 0.20, 0.24).toColor(),
        primary: HSLColor.fromAHSL(1.0, h, 0.85, 0.65).toColor(),
        tertiary: HSLColor.fromAHSL(1.0, (h + 40) % 360, 0.85, 0.65).toColor(),
      );
    } else {
      scheme = scheme.copyWith(
        surface: HSLColor.fromAHSL(1.0, h, 0.15, 0.98).toColor(),
        surfaceContainerLowest: HSLColor.fromAHSL(1.0, h, 0.15, 0.95).toColor(),
        surfaceContainerLow: HSLColor.fromAHSL(1.0, h, 0.15, 0.92).toColor(),
        surfaceContainer: HSLColor.fromAHSL(1.0, h, 0.15, 0.89).toColor(),
        surfaceContainerHigh: HSLColor.fromAHSL(1.0, h, 0.15, 0.86).toColor(),
        surfaceContainerHighest: HSLColor.fromAHSL(1.0, h, 0.15, 0.83).toColor(),
        primary: HSLColor.fromAHSL(1.0, h, 0.85, 0.45).toColor(),
        tertiary: HSLColor.fromAHSL(1.0, (h + 40) % 360, 0.85, 0.45).toColor(),
      );
    }

    final textTheme = _buildTextTheme(scheme);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      textTheme: textTheme,
      brightness: brightness,
      scaffoldBackgroundColor: scheme.surface,

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: scheme.onSurface,
        ),
      ),

      // Cards
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: scheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
      ),

      // Navigation Rail (desktop)
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: scheme.surfaceContainerLowest,
        indicatorColor: scheme.primaryContainer,
        selectedIconTheme: IconThemeData(color: scheme.onPrimaryContainer),
        unselectedIconTheme:
            IconThemeData(color: scheme.onSurfaceVariant),
        selectedLabelTextStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: scheme.primary,
        ),
        unselectedLabelTextStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: scheme.onSurfaceVariant,
        ),
        useIndicator: true,
        labelType: NavigationRailLabelType.all,
      ),

      // Buttons
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.inter(
              fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.inter(
              fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),

      // InputDecoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLowest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: TextStyle(color: scheme.onSurfaceVariant),
      ),

      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      // Chips
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: scheme.surfaceContainerLow,
        selectedColor: scheme.primaryContainer,
        labelStyle: GoogleFonts.inter(
            fontSize: 13, fontWeight: FontWeight.w500),
      ),

      // Dialogs
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        backgroundColor: scheme.surfaceContainerHigh,
        elevation: 6,
      ),

      // Dividers
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant.withValues(alpha: 0.5),
        thickness: 1,
        space: 1,
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: GoogleFonts.inter(
          color: scheme.onInverseSurface,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // List Tile
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),

      // Progress Indicator
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: scheme.surfaceContainerHighest,
        linearMinHeight: 8,
        circularTrackColor: scheme.surfaceContainerHighest,
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return scheme.primary;
          return scheme.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return scheme.primaryContainer;
          }
          return scheme.surfaceContainerHighest;
        }),
      ),
    );
  }

  // ── Light theme ────────────────────────────────────────────────
  static ThemeData light(String seedColorHex) =>
      buildTheme(seedColorHex: seedColorHex, brightness: Brightness.light);

  // ── Dark theme ─────────────────────────────────────────────────
  static ThemeData dark(String seedColorHex) =>
      buildTheme(seedColorHex: seedColorHex, brightness: Brightness.dark);
}
