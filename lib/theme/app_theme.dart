import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/message.dart';

/// Consistent spacing scale used across the app instead of magic numbers.
class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
}

/// Consistent corner-radius scale used across the app instead of magic numbers.
class AppRadius {
  static const sm = 10.0;
  static const md = 16.0;
  static const lg = 20.0;
  static const xl = 28.0;
}

/// Semantic colors for each message [Tone], independent of light/dark theme,
/// so the meaning of a tone stays recognizable (and accessible) everywhere
/// it's shown: the tone selector, message bubbles, symbol tiles.
class ToneColors {
  static const Map<Tone, Color> _base = {
    Tone.neutral: Color(0xFF64748B), // slate
    Tone.happy: Color(0xFFCA8A04), // amber
    Tone.urgent: Color(0xFFEA580C), // orange
    Tone.sad: Color(0xFF4F46E5), // indigo
    Tone.question: Color(0xFF9333EA), // purple
    Tone.angry: Color(0xFFDC2626), // red
  };

  static Color of(Tone tone) => _base[tone]!;
}

/// Semantic colors for symbol-board categories, so each category is
/// instantly recognizable by color as well as label/icon.
class CategoryColors {
  static const Map<String, Color> _base = {
    'all': Color(0xFF0D9488),
    'quick': Color(0xFFCA8A04),
    'needs': Color(0xFF0D9488),
    'emergency': Color(0xFFDC2626),
    'emotions': Color(0xFF9333EA),
    'family': Color(0xFF2563EB),
    'work': Color(0xFF4F46E5),
    'weather': Color(0xFF0284C7),
    'money': Color(0xFF16A34A),
    'tech': Color(0xFF9333EA),
    'general': Color(0xFF64748B),
  };

  static Color of(String category) => _base[category] ?? _base['general']!;
}

class AppTheme {
  AppTheme._();

  static const _seed = Color(0xFF0D9488); // teal-600, matches brand identity

  static ThemeData light({String languageCode = 'en'}) => _build(Brightness.light, languageCode);
  static ThemeData dark({String languageCode = 'en'}) => _build(Brightness.dark, languageCode);

  static ThemeData _build(Brightness brightness, String languageCode) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: brightness,
    );

    // Atkinson Hyperlegible is purpose-built for readability, including for
    // low-vision readers — a fitting default body/display face for an AAC
    // communication app used and read by a wide range of people.
    final baseTextTheme = brightness == Brightness.light
        ? Typography.material2021().black
        : Typography.material2021().white;
    var textTheme = GoogleFonts.atkinsonHyperlegibleTextTheme(baseTextTheme);

    // Atkinson Hyperlegible has no Bengali glyphs — fall back to the
    // bundled Noto Sans Bengali face for that locale.
    if (languageCode == 'bn') {
      textTheme = textTheme.apply(fontFamily: 'NotoSansBengali');
    }

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: colorScheme.surface,
      visualDensity: VisualDensity.standard,

      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: colorScheme.surfaceTint,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        elevation: 3,
        height: 68,
        surfaceTintColor: colorScheme.surfaceTint,
        indicatorColor: colorScheme.primaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return textTheme.labelMedium?.copyWith(
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
          );
        }),
      ),

      cardTheme: CardThemeData(
        elevation: 0,
        color: colorScheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        margin: EdgeInsets.zero,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          disabledBackgroundColor: colorScheme.onSurface.withValues(alpha: 0.12),
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
          textStyle: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),

      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 2,
        shape: const CircleBorder(),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHigh,
        selectedColor: colorScheme.primaryContainer,
        labelStyle: textTheme.labelLarge,
        secondaryLabelStyle: textTheme.labelLarge?.copyWith(
          color: colorScheme.onPrimaryContainer,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
        side: BorderSide.none,
        showCheckmark: false,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerLow,
        contentPadding: const EdgeInsets.all(AppSpacing.lg),
        hintStyle: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
      ),

      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xs,
        ),
      ),

      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        space: 1,
        thickness: 1,
      ),

      splashFactory: InkSparkle.splashFactory,
    );
  }
}
