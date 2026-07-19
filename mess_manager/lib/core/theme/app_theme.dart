import 'package:flutter/material.dart';

/// Design tokens extracted from the approved mockups
/// (D:\Project\design\mess_manager_screens_2.html style guide).
class AppColors {
  AppColors._();

  // Teal — primary
  static const teal50 = Color(0xFFF0FAF8);
  static const teal100 = Color(0xFFE0F2F1);
  static const teal200 = Color(0xFFB2DFDB);
  static const teal400 = Color(0xFF4DB6AC);
  static const teal600 = Color(0xFF009688);
  static const teal700 = Color(0xFF007A6E);
  static const teal800 = Color(0xFF00564C);
  static const teal900 = Color(0xFF003D36);

  // Honey / amber — premium accent
  static const amber400 = Color(0xFFFFCA28);
  static const honey100 = Color(0xFFFBEFD4);
  static const honey300 = Color(0xFFF2C879);
  static const honey500 = Color(0xFFE0A537);
  static const honey600 = Color(0xFFC28720);
  static const honey700 = Color(0xFF9A6912);

  // Coral — dues / danger
  static const coral100 = Color(0xFFFFEBEE);
  static const coral400 = Color(0xFFEF5350);
  static const coral600 = Color(0xFFD2563F);
  static const coral700 = Color(0xFFC62828);

  // Neutral
  static const neutral50 = Color(0xFFF5F7F8);
  static const neutral100 = Color(0xFFECF0F2);
  static const neutral200 = Color(0xFFDAE2E6);
  static const neutral300 = Color(0xFFB0BEC5);
  static const neutral400 = Color(0xFF90A4AE);
  static const neutral500 = Color(0xFF607D8B);
  static const neutral600 = Color(0xFF475A63);
  static const neutral700 = Color(0xFF2E3840);
  static const neutral800 = Color(0xFF222930);
  static const neutral850 = Color(0xFF1A1F23);
  static const neutral900 = Color(0xFF111518);
  static const neutral950 = Color(0xFF0A0E11);

  // Paper / ink
  static const paper50 = Color(0xFFFBF9F4);
  static const paper100 = Color(0xFFF4F1E9);
  static const paper200 = Color(0xFFE8E3D5);
  static const ink900 = Color(0xFF15201D);

  static const heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00867A), Color(0xFF007A6E), Color(0xFF00564C), Color(0xFF003D36)],
    stops: [0.0, 0.35, 0.70, 1.0],
  );

  static const accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFD25A), Color(0xFFE0A537), Color(0xFFC28720)],
    stops: [0.0, 0.55, 1.0],
  );
}

class AppRadius {
  AppRadius._();
  static const sm = 10.0;
  static const md = 12.0;
  static const lg = 14.0;
  static const xl = 16.0;
  static const xxl = 20.0;
  static const pill = 999.0;
}

/// Money is always rendered in JetBrains Mono so columns align in tables/lists.
const moneyFontFamily = 'JetBrainsMono';

ThemeData buildAppTheme({required Brightness brightness, required String localeCode}) {
  final isDark = brightness == Brightness.dark;
  final isBangla = localeCode == 'bn';

  final primaryFont = isBangla ? 'HindSiliguri' : 'DMSans';
  final fallbackFont = isBangla ? 'DMSans' : 'HindSiliguri';

  final colorScheme = isDark
      ? const ColorScheme.dark(
          primary: AppColors.teal400,
          onPrimary: AppColors.neutral950,
          primaryContainer: AppColors.teal800,
          onPrimaryContainer: AppColors.teal100,
          secondary: AppColors.amber400,
          onSecondary: AppColors.neutral950,
          secondaryContainer: AppColors.honey700,
          onSecondaryContainer: AppColors.honey100,
          tertiary: AppColors.coral400,
          onTertiary: Colors.white,
          error: AppColors.coral400,
          onError: Colors.white,
          surface: AppColors.neutral900,
          onSurface: AppColors.neutral100,
          surfaceContainerHighest: AppColors.neutral800,
          outline: AppColors.neutral700,
          outlineVariant: AppColors.neutral800,
        )
      : const ColorScheme.light(
          primary: AppColors.teal700,
          onPrimary: Colors.white,
          primaryContainer: AppColors.teal100,
          onPrimaryContainer: AppColors.teal900,
          secondary: AppColors.honey600,
          onSecondary: Colors.white,
          secondaryContainer: AppColors.honey100,
          onSecondaryContainer: AppColors.honey700,
          tertiary: AppColors.coral600,
          onTertiary: Colors.white,
          error: AppColors.coral600,
          onError: Colors.white,
          surface: AppColors.paper50,
          onSurface: AppColors.ink900,
          surfaceContainerHighest: AppColors.paper100,
          outline: AppColors.paper200,
          outlineVariant: AppColors.paper200,
        );

  final scaffoldBg = isDark ? AppColors.neutral950 : const Color(0xFFEDEAE2);
  final cardBg = isDark ? AppColors.neutral900 : const Color(0xFFFFFEFB);

  // Soft, brand-tinted shadows read as "lifted" without the generic grey
  // haze a default Material shadow gives — light mode only; dark surfaces
  // get their depth from the border instead, since shadows barely read on
  // a dark background.
  final cardShadowColor = isDark ? Colors.transparent : AppColors.teal900.withValues(alpha: 0.12);
  final navShadowColor = isDark ? Colors.transparent : AppColors.teal900.withValues(alpha: 0.10);

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: scaffoldBg,
    fontFamily: primaryFont,
    fontFamilyFallback: [fallbackFont],
    splashFactory: InkSparkle.splashFactory,
    appBarTheme: AppBarTheme(
      backgroundColor: scaffoldBg,
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
      // Stays flush with the page at rest, but lifts subtly once content
      // scrolls beneath it — a cheap, purely theme-level "premium" cue
      // that needs no per-screen wiring.
      scrolledUnderElevation: isDark ? 0 : 3,
      shadowColor: navShadowColor,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: primaryFont,
        fontFamilyFallback: [fallbackFont],
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: colorScheme.onSurface,
      ),
    ),
    cardTheme: CardThemeData(
      color: cardBg,
      elevation: isDark ? 0 : 3,
      shadowColor: cardShadowColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        side: BorderSide(color: colorScheme.outline, width: 1),
      ),
      margin: EdgeInsets.zero,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
        textStyle: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700, letterSpacing: 0.1),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.onSurface,
        side: BorderSide(color: colorScheme.outline, width: 1.5),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
        textStyle: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700, letterSpacing: 0.1),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
        textStyle: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: cardBg,
      side: BorderSide(color: colorScheme.outline),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
      labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: colorScheme.onSurface),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: cardBg,
      indicatorColor: colorScheme.primaryContainer,
      elevation: isDark ? 0 : 8,
      shadowColor: navShadowColor,
      surfaceTintColor: Colors.transparent,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: states.contains(WidgetState.selected) ? colorScheme.primary : colorScheme.onSurfaceVariant,
        ),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      elevation: isDark ? 0 : 4,
      focusElevation: isDark ? 0 : 4,
      hoverElevation: isDark ? 0 : 6,
      highlightElevation: isDark ? 0 : 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xl)),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: cardBg,
      elevation: isDark ? 0 : 6,
      modalElevation: isDark ? 0 : 6,
      surfaceTintColor: Colors.transparent,
      showDragHandle: true,
      dragHandleColor: colorScheme.outline,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: cardBg,
      elevation: isDark ? 1 : 6,
      surfaceTintColor: Colors.transparent,
      // Matches the radius most call sites already set explicitly on their
      // own AlertDialog — this theme default only actually applies to the
      // couple that don't, but keeping it the same value avoids introducing
      // a second radius into the app's dialog language.
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xl)),
      titleTextStyle: TextStyle(
        fontFamily: primaryFont,
        fontFamilyFallback: [fallbackFont],
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: colorScheme.onSurface,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: isDark ? AppColors.neutral800 : AppColors.ink900,
      contentTextStyle: const TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w600),
      behavior: SnackBarBehavior.floating,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: colorScheme.primary,
      circularTrackColor: colorScheme.primary.withValues(alpha: 0.12),
      linearTrackColor: colorScheme.primary.withValues(alpha: 0.12),
    ),
    textTheme: Typography.material2021(platform: TargetPlatform.android).black.apply(
          fontFamily: primaryFont,
          fontFamilyFallback: [fallbackFont],
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
  );
}

/// Text style for all monetary values — use with [BdFormatter] output.
TextStyle moneyTextStyle({
  required double fontSize,
  FontWeight fontWeight = FontWeight.w700,
  Color? color,
}) {
  return TextStyle(
    fontFamily: moneyFontFamily,
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    letterSpacing: -0.3,
  );
}
