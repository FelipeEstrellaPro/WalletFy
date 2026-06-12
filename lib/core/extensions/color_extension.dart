import 'package:flutter/material.dart';

/// Extension to convert hex string ↔ Flutter Color.
extension ColorExtension on Color {
  /// Convert Color to hex string: #RRGGBB
  String toHex() {
    return '#${(value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }

  /// Lighten the color by [percent] (0–100).
  Color lighten(int percent) {
    final hsl = HSLColor.fromColor(this);
    return hsl
        .withLightness((hsl.lightness + percent / 100).clamp(0.0, 1.0))
        .toColor();
  }

  /// Darken the color by [percent] (0–100).
  Color darken(int percent) {
    final hsl = HSLColor.fromColor(this);
    return hsl
        .withLightness((hsl.lightness - percent / 100).clamp(0.0, 1.0))
        .toColor();
  }

  /// Whether to use white text on this background for good contrast.
  bool get needsWhiteText {
    final luminance = computeLuminance();
    return luminance < 0.35;
  }
}

/// Parse a hex string to Color.
extension HexColor on String {
  Color toColor() {
    final hex = replaceAll('#', '').trim();
    final value = int.tryParse(hex, radix: 16) ?? 0xFF6366F1;
    return Color(value | 0xFF000000);
  }
}
