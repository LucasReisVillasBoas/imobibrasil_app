import 'package:flutter/material.dart';

// ── Tokens semânticos de cor ──────────────────────────────────────────────────
// Uso: context.colors.surface, context.colors.textPrimary, etc.
// O Flutter resolve light/dark automaticamente via Theme.of(context).

@immutable
class AppColorTokens extends ThemeExtension<AppColorTokens> {
  final Color background;
  final Color surface;
  final Color surfaceContainer;
  final Color surfaceContainerLow;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
  final Color textPrimary;
  final Color textSecondary;
  final Color outline;
  final Color outlineVariant;
  final Color cardBackground;
  final Color appBarBackground;
  final Color inputFill;
  final Color sectionBackground;
  final Color divider;
  final Color sectionBorder;
  final Color glassBackground;
  final Color glassBorder;
  final Color iconColor;
  final Color chipUnselected;

  const AppColorTokens({
    required this.background,
    required this.surface,
    required this.surfaceContainer,
    required this.surfaceContainerLow,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
    required this.textPrimary,
    required this.textSecondary,
    required this.outline,
    required this.outlineVariant,
    required this.cardBackground,
    required this.appBarBackground,
    required this.inputFill,
    required this.sectionBackground,
    required this.divider,
    required this.sectionBorder,
    required this.glassBackground,
    required this.glassBorder,
    required this.iconColor,
    required this.chipUnselected,
  });

  // ── LIGHT TOKENS ────────────────────────────────────────────────────────────
  static const light = AppColorTokens(
    background: Color(0xFFF9F9F9),
    surface: Color(0xFFF9F9F9),
    surfaceContainer: Color(0xFFEEEEEE),
    surfaceContainerLow: Color(0xFFF3F3F3),
    surfaceContainerHigh: Color(0xFFE8E8E8),
    surfaceContainerHighest: Color(0xFFE2E2E2),
    textPrimary: Color(0xFF1A1C1C),
    textSecondary: Color(0xFF3F4940),
    outline: Color(0xFF6F7A6F),
    outlineVariant: Color(0xFFBECABD),
    cardBackground: Color(0xFFFFFFFF),
    appBarBackground: Color(0xB3FFFFFF), // white 70%
    inputFill: Color(0xFFF3F3F3),
    sectionBackground: Color(0xFFFFFFFF),
    divider: Color(0x1ABECABD), // outlineVariant 10%
    sectionBorder: Color(0x26BECABD), // outlineVariant 15%
    glassBackground: Color(0xA6FFFFFF), // white 65%
    glassBorder: Color(0x66FFFFFF), // white 40%
    iconColor: Color(0xFF6F7A6F),
    chipUnselected: Color(0xFFF3F3F3),
  );

  // ── DARK TOKENS — Digital Biome ─────────────────────────────────────────────
  static const dark = AppColorTokens(
    background: Color(0xFF0A0A0A),
    surface: Color(0xFF0E0E0E),
    surfaceContainer: Color(0xFF1A1919),
    surfaceContainerLow: Color(0xFF131313),
    surfaceContainerHigh: Color(0xFF201F1F),
    surfaceContainerHighest: Color(0xFF262626),
    textPrimary: Color(0xFFF5F5F5),
    textSecondary: Color(0xFFADAAAA),
    outline: Color(0xFF777575),
    outlineVariant: Color(0xFF494847),
    cardBackground: Color(0xFF1A1919),
    appBarBackground: Color(0xCC0E0E0E), // surface 80%
    inputFill: Color(0xFF131313),
    sectionBackground: Color(0xFF1A1919),
    divider: Color(0x14FFFFFF), // white 8%
    sectionBorder: Color(0x0FFFFFFF), // white 6%
    glassBackground: Color(0x0DFFFFFF), // white 5%
    glassBorder: Color(0x14FFFFFF), // white 8%
    iconColor: Color(0xFFADAAAA),
    chipUnselected: Color(0xFF201F1F),
  );

  @override
  AppColorTokens copyWith({
    Color? background,
    Color? surface,
    Color? surfaceContainer,
    Color? surfaceContainerLow,
    Color? surfaceContainerHigh,
    Color? surfaceContainerHighest,
    Color? textPrimary,
    Color? textSecondary,
    Color? outline,
    Color? outlineVariant,
    Color? cardBackground,
    Color? appBarBackground,
    Color? inputFill,
    Color? sectionBackground,
    Color? divider,
    Color? sectionBorder,
    Color? glassBackground,
    Color? glassBorder,
    Color? iconColor,
    Color? chipUnselected,
  }) {
    return AppColorTokens(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceContainer: surfaceContainer ?? this.surfaceContainer,
      surfaceContainerLow: surfaceContainerLow ?? this.surfaceContainerLow,
      surfaceContainerHigh: surfaceContainerHigh ?? this.surfaceContainerHigh,
      surfaceContainerHighest:
          surfaceContainerHighest ?? this.surfaceContainerHighest,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      outline: outline ?? this.outline,
      outlineVariant: outlineVariant ?? this.outlineVariant,
      cardBackground: cardBackground ?? this.cardBackground,
      appBarBackground: appBarBackground ?? this.appBarBackground,
      inputFill: inputFill ?? this.inputFill,
      sectionBackground: sectionBackground ?? this.sectionBackground,
      divider: divider ?? this.divider,
      sectionBorder: sectionBorder ?? this.sectionBorder,
      glassBackground: glassBackground ?? this.glassBackground,
      glassBorder: glassBorder ?? this.glassBorder,
      iconColor: iconColor ?? this.iconColor,
      chipUnselected: chipUnselected ?? this.chipUnselected,
    );
  }

  @override
  AppColorTokens lerp(AppColorTokens? other, double t) {
    if (other is! AppColorTokens) return this;
    return AppColorTokens(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceContainer:
          Color.lerp(surfaceContainer, other.surfaceContainer, t)!,
      surfaceContainerLow:
          Color.lerp(surfaceContainerLow, other.surfaceContainerLow, t)!,
      surfaceContainerHigh:
          Color.lerp(surfaceContainerHigh, other.surfaceContainerHigh, t)!,
      surfaceContainerHighest: Color.lerp(
          surfaceContainerHighest, other.surfaceContainerHighest, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      outlineVariant: Color.lerp(outlineVariant, other.outlineVariant, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      appBarBackground:
          Color.lerp(appBarBackground, other.appBarBackground, t)!,
      inputFill: Color.lerp(inputFill, other.inputFill, t)!,
      sectionBackground:
          Color.lerp(sectionBackground, other.sectionBackground, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      sectionBorder: Color.lerp(sectionBorder, other.sectionBorder, t)!,
      glassBackground: Color.lerp(glassBackground, other.glassBackground, t)!,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t)!,
      iconColor: Color.lerp(iconColor, other.iconColor, t)!,
      chipUnselected: Color.lerp(chipUnselected, other.chipUnselected, t)!,
    );
  }
}

// ── Extension de acesso rápido ────────────────────────────────────────────────
// Uso: context.colors.textPrimary
extension AppColorsContext on BuildContext {
  AppColorTokens get colors =>
      Theme.of(this).extension<AppColorTokens>() ?? AppColorTokens.light;
}
