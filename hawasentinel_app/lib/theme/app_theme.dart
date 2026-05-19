import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Atmospheric Sentinel Design System ──────────────────────────────────
  // Background layers
  static const Color background           = Color(0xFF0D1512); // surface
  static const Color surfaceDim           = Color(0xFF0D1512);
  static const Color surfaceContainerLow  = Color(0xFF161D1A);
  static const Color surfaceContainer     = Color(0xFF19211E); // card bg
  static const Color surfaceContainerHigh = Color(0xFF242C28);
  static const Color surfaceContainerHighest = Color(0xFF2F3633);
  static const Color surfaceBright        = Color(0xFF333B37);

  // Primary – Teal Green
  static const Color primary              = Color(0xFF46F1C5);
  static const Color primaryContainer     = Color(0xFF00D4AA);
  static const Color onPrimary            = Color(0xFF00382B);
  static const Color onPrimaryContainer   = Color(0xFF005643);

  // Secondary – Violet
  static const Color secondary            = Color(0xFFD2BBFF);
  static const Color secondaryContainer   = Color(0xFF6001D1);

  // Tertiary – Amber/Orange
  static const Color tertiary             = Color(0xFFFFCEA6);
  static const Color tertiaryContainer    = Color(0xFFFFA858);

  // Status
  static const Color error                = Color(0xFFFFB4AB);
  static const Color errorContainer       = Color(0xFF93000A);

  // On-colors / text
  static const Color onSurface           = Color(0xFFDCE4DF);
  static const Color onSurfaceVariant    = Color(0xFFBACDC2);
  static const Color outline             = Color(0xFF85948D);
  static const Color outlineVariant      = Color(0xFF3B4A44);

  // Legacy aliases (kept for backward compat in old widgets)
  static const Color cardColor   = surfaceContainer;
  static const Color primaryGreen = primary;
  static const Color primaryRed   = error;
  static const Color textWhite    = onSurface;
  static const Color textGrey     = onSurfaceVariant;

  // ── AQI semantic colours ─────────────────────────────────────────────────
  static Color aqiColor(int aqi) {
    if (aqi == 0)   return onSurfaceVariant;
    if (aqi < 51)   return const Color(0xFF46F1C5); // Good – teal
    if (aqi < 101)  return const Color(0xFFFFCEA6); // Moderate – amber
    if (aqi < 151)  return const Color(0xFFFFA858); // Unhealthy for Sensitive
    if (aqi < 201)  return const Color(0xFFFF6B6B); // Unhealthy – red
    if (aqi < 301)  return const Color(0xFFD2BBFF); // Very Unhealthy – purple
    return const Color(0xFFFFB4AB);                  // Hazardous
  }

  // ── Theme ────────────────────────────────────────────────────────────────
  static ThemeData get darkTheme {
    final base = ThemeData.dark();
    return base.copyWith(
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        secondary: secondary,
        onSecondary: Color(0xFF3F008E),
        secondaryContainer: secondaryContainer,
        onSecondaryContainer: Color(0xFFC9AEFF),
        tertiary: tertiary,
        onTertiary: Color(0xFF4C2700),
        tertiaryContainer: tertiaryContainer,
        error: error,
        onError: Color(0xFF690005),
        errorContainer: errorContainer,
        surface: background,
        onSurface: onSurface,
        onSurfaceVariant: onSurfaceVariant,
        outline: outline,
        outlineVariant: outlineVariant,
      ),
      textTheme: _buildTextTheme(base.textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: onSurface),
        titleTextStyle: GoogleFonts.inter(
          color: onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: outlineVariant, width: 1),
        ),
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
      dividerColor: outlineVariant,
      dividerTheme: const DividerThemeData(color: outlineVariant, thickness: 1),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryContainer,
          foregroundColor: onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: outlineVariant),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceContainerLow,
        selectedItemColor: primary,
        unselectedItemColor: onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      listTileTheme: const ListTileThemeData(
        tileColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      expansionTileTheme: const ExpansionTileThemeData(
        backgroundColor: surfaceContainer,
        collapsedBackgroundColor: surfaceContainer,
        iconColor: primary,
        collapsedIconColor: onSurfaceVariant,
        textColor: onSurface,
        collapsedTextColor: onSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primary,
        linearTrackColor: outlineVariant,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceContainerHigh,
        labelStyle: GoogleFonts.jetBrainsMono(color: onSurfaceVariant, fontSize: 12),
        side: const BorderSide(color: outlineVariant),
        shape: const StadiumBorder(),
      ),
    );
  }

  static TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      displayLarge: GoogleFonts.inter(color: onSurface, fontSize: 48, fontWeight: FontWeight.w700, letterSpacing: -0.02 * 48),
      displayMedium: GoogleFonts.inter(color: onSurface, fontSize: 40, fontWeight: FontWeight.w700),
      displaySmall: GoogleFonts.inter(color: onSurface, fontSize: 32, fontWeight: FontWeight.w600),
      headlineLarge: GoogleFonts.inter(color: onSurface, fontSize: 28, fontWeight: FontWeight.w600),
      headlineMedium: GoogleFonts.inter(color: onSurface, fontSize: 24, fontWeight: FontWeight.w600),
      headlineSmall: GoogleFonts.inter(color: onSurface, fontSize: 20, fontWeight: FontWeight.w600),
      titleLarge: GoogleFonts.inter(color: onSurface, fontSize: 17, fontWeight: FontWeight.w600),
      titleMedium: GoogleFonts.inter(color: onSurface, fontSize: 15, fontWeight: FontWeight.w500),
      titleSmall: GoogleFonts.inter(color: onSurface, fontSize: 13, fontWeight: FontWeight.w500),
      bodyLarge: GoogleFonts.inter(color: onSurface, fontSize: 16, fontWeight: FontWeight.w400, height: 1.6),
      bodyMedium: GoogleFonts.inter(color: onSurfaceVariant, fontSize: 14, fontWeight: FontWeight.w400, height: 1.5),
      bodySmall: GoogleFonts.inter(color: onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.w400),
      labelLarge: GoogleFonts.jetBrainsMono(color: onSurface, fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.02 * 14),
      labelMedium: GoogleFonts.jetBrainsMono(color: onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.05 * 12),
      labelSmall: GoogleFonts.jetBrainsMono(color: onSurfaceVariant, fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.05 * 11),
    );
  }
}
