import 'dart:math' as math;

import 'package:flutter/material.dart';

sealed class AppTheme {
  static const String fontFamily = 'BricolageGrotesque';

  static const double _corner = 16;
  static const double _cornerSmall = 12;
  static const double _cornerLarge = 24;

  static const Color _black = Color(0xFF0A0A0A);
  static const Color _white = Color(0xFFFFFFFF);
  static const Color _grey50 = Color(0xFFF7F7F8);
  static const Color _grey200 = Color(0xFFE6E7EA);
  static const Color _grey700 = Color(0xFF3B3F46);
  static const Color _grey900 = Color(0xFF141519);
  static const Color _green = Color(0xFF16A34A);
  static const Color _red = Color(0xFFDC2626);

  static const Color _onGreen = _white;
  static const Color _onRed = _white;

  static final ThemeData light = _build(
    scheme: const ColorScheme.light(
      primary: _green,
      onPrimary: _onGreen,
      secondary: _black,
      onSecondary: _white,
      tertiary: _grey700,
      onTertiary: _white,
      error: _red,
      onError: _onRed,
      surface: _white,
      onSurface: _black,
      surfaceContainerHighest: _grey50,
      outline: _grey200,
    ),
  );

  static final ThemeData dark = _build(
    scheme: const ColorScheme.dark(
      primary: _green,
      onPrimary: _onGreen,
      secondary: _white,
      onSecondary: _black,
      tertiary: _grey200,
      onTertiary: _black,
      error: _red,
      onError: _onRed,
      surface: _grey900,
      onSurface: _white,
      surfaceContainerHighest: Color(0xFF1B1D22),
      outline: Color(0xFF2C2F36),
    ),
  );

  static ThemeData _build({required ColorScheme scheme}) {
    final brightness = scheme.brightness;
    final isDark = brightness == Brightness.dark;

    final textTheme = _textTheme(
      onSurface: scheme.onSurface,
      brightness: brightness,
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      fontFamily: fontFamily,
      textTheme: textTheme,
    );

    return base.copyWith(
      dividerTheme: DividerThemeData(
        color: scheme.outline.withAlpha(153),
        thickness: 1,
        space: 24,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerHighest,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_cornerLarge),
          side: BorderSide(color: scheme.outline.withAlpha(isDark ? 140 : 204)),
        ),
        margin: EdgeInsets.zero,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_cornerLarge),
          side: BorderSide(color: scheme.outline.withAlpha(204)),
        ),
        titleTextStyle: textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: -0.4,
        ),
        contentTextStyle: textTheme.bodyLarge,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? const Color(0xFF0F1013) : _black,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_corner),
          side: BorderSide(color: scheme.outline.withAlpha(isDark ? 140 : 89)),
        ),
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: _white,
          fontWeight: FontWeight.w600,
        ),
        actionTextColor: _green,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(_cornerLarge),
          ),
          side: BorderSide(color: scheme.outline.withAlpha(204)),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_cornerLarge),
          side: BorderSide(color: scheme.outline.withAlpha(204)),
        ),
        textStyle: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F1013) : _black,
          borderRadius: BorderRadius.circular(_cornerSmall),
          border: Border.all(
            color: scheme.outline.withAlpha(isDark ? 140 : 89),
          ),
        ),
        textStyle: textTheme.labelMedium?.copyWith(color: _white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF111218) : _grey50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onSurface.withAlpha(140),
          fontWeight: FontWeight.w500,
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onSurface.withAlpha(191),
          fontWeight: FontWeight.w700,
        ),
        errorStyle: textTheme.labelMedium?.copyWith(
          color: scheme.error,
          fontWeight: FontWeight.w700,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_corner),
          borderSide: BorderSide(color: scheme.outline.withAlpha(230)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_corner),
          borderSide: BorderSide(color: scheme.outline.withAlpha(191)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_corner),
          borderSide: const BorderSide(color: _green, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_corner),
          borderSide: const BorderSide(color: _red, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_corner),
          borderSide: const BorderSide(color: _red, width: 1.4),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: _buttonStyle(
          scheme: scheme,
          background: scheme.primary,
          foreground: scheme.onPrimary,
          border: Colors.transparent,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: _buttonStyle(
          scheme: scheme,
          background: scheme.primary,
          foreground: scheme.onPrimary,
          border: Colors.transparent,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: _buttonStyle(
          scheme: scheme,
          background: Colors.transparent,
          foreground: scheme.onSurface,
          border: scheme.outline.withAlpha(isDark ? 191 : 230),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: _buttonStyle(
          scheme: scheme,
          background: Colors.transparent,
          foreground: scheme.onSurface,
          border: Colors.transparent,
          tight: true,
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: scheme.surfaceContainerHighest,
        shape: StadiumBorder(
          side: BorderSide(color: scheme.outline.withAlpha(204)),
        ),
        labelStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        secondaryLabelStyle: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  static ButtonStyle _buttonStyle({
    required ColorScheme scheme,
    required Color background,
    required Color foreground,
    required Color border,
    bool tight = false,
  }) {
    final height = tight ? 44.0 : 50.0;
    final padding = tight
        ? const EdgeInsets.symmetric(horizontal: 14)
        : const EdgeInsets.symmetric(horizontal: 18);

    return ButtonStyle(
      minimumSize: WidgetStatePropertyAll(Size(64, height)),
      padding: WidgetStatePropertyAll(padding),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_corner),
          side: BorderSide(color: border),
        ),
      ),
      textStyle: WidgetStatePropertyAll(
        TextStyle(
          fontFamily: fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (background == Colors.transparent) return background;
        if (states.contains(WidgetState.disabled)) {
          return background.withAlpha(115);
        }
        if (states.contains(WidgetState.pressed)) {
          return background.withAlpha(230);
        }
        return background;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return foreground.withAlpha(153);
        }
        return foreground;
      }),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered)) {
          return scheme.onSurface.withAlpha(15);
        }
        if (states.contains(WidgetState.focused)) {
          return scheme.onSurface.withAlpha(20);
        }
        if (states.contains(WidgetState.pressed)) {
          return scheme.onSurface.withAlpha(26);
        }
        return null;
      }),
    );
  }

  static TextTheme _textTheme({
    required Color onSurface,
    required Brightness brightness,
  }) {
    final base =
        (brightness == Brightness.dark
                ? Typography.whiteMountainView
                : Typography.blackMountainView)
            .apply(fontFamily: fontFamily);

    final themed = TextTheme(
      displayLarge: const TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.w800,
        height: 1.04,
        letterSpacing: -0.8,
      ),
      displayMedium: const TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w800,
        height: 1.06,
        letterSpacing: -0.7,
      ),
      displaySmall: const TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w800,
        height: 1.10,
        letterSpacing: -0.6,
      ),
      headlineLarge: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        height: 1.12,
        letterSpacing: -0.5,
      ),
      headlineMedium: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        height: 1.15,
        letterSpacing: -0.4,
      ),
      headlineSmall: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        height: 1.20,
        letterSpacing: -0.2,
      ),
      titleLarge: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        height: 1.25,
        letterSpacing: -0.1,
      ),
      titleMedium: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        height: 1.25,
      ),
      titleSmall: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.25,
      ),
      bodyLarge: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.45,
      ),
      bodyMedium: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.48,
      ),
      bodySmall: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.45,
      ),
      labelLarge: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        height: 1.10,
        letterSpacing: 0.2,
      ),
      labelMedium: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        height: 1.10,
        letterSpacing: 0.2,
      ),
      labelSmall: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        height: 1.10,
        letterSpacing: 0.2,
      ),
    );

    return base
        .merge(themed)
        .apply(displayColor: onSurface, bodyColor: onSurface);
  }
}

extension AppTextStylesX on TextTheme {
  TextStyle get header => headlineLarge ?? const TextStyle();
  TextStyle get tagline => titleLarge ?? const TextStyle();
  TextStyle get description => bodyLarge ?? const TextStyle();
  TextStyle get caption => bodySmall ?? const TextStyle();
}

sealed class AppLayout {
  static const double phoneMax = 600;
  static const double tabletMax = 1024;

  static const double maxContentWidth = 1120;

  static EdgeInsets pagePadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontal = width < 380
        ? 16.0
        : width < phoneMax
        ? 20.0
        : width < tabletMax
        ? 24.0
        : 32.0;
    final vertical = width < phoneMax ? 16.0 : 20.0;
    return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
  }

  static EdgeInsets dialogPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontal = width < phoneMax ? 20.0 : 28.0;
    return EdgeInsets.symmetric(horizontal: horizontal, vertical: 18);
  }

  static double contentWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontal = pagePadding(context).horizontal;
    return math.min(maxContentWidth, math.max(0.0, width - horizontal));
  }
}
