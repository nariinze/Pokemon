import 'package:flutter/material.dart';

class AppColors {
  // ======== GANTI 5 WARNA INI UNTUK MENGUBAH TEMA ========
  static const bg = Color(0xFF0E1220); // latar belakang
  static const surface = Color(0xFF171D33); // kartu
  static const surface2 = Color(0xFF232C4D); // input / elemen lebih terang
  static const primary = Color(0xFFFFCB05); // warna utama (tombol, aksen)
  static const accent = Color(0xFFEF4444); // warna kedua
  // =======================================================

  static const muted = Color(0xFF8B93A7);

  static const _palette = [
    Color(0xFF55CC44),
    Color(0xFF44C8F5),
    Color(0xFFFF8A3D),
    Color(0xFFB06CFF),
    Color(0xFFFF5C93),
    Color(0xFFFFC857),
    Color(0xFF34D399),
    Color(0xFF38BDF8),
  ];

  /// Warna label/badge. Alive/Dead/Unknown punya warna khusus,
  /// selain itu warna dipilih konsisten dari teksnya.
  static Color badgeColor(String text) {
    switch (text.toLowerCase()) {
      case 'alive':
        return const Color(0xFF55CC44);
      case 'dead':
        return const Color(0xFFD63D2E);
      case 'unknown':
        return const Color(0xFF9E9E9E);
    }
    if (text.isEmpty) return muted;
    final h = text
        .toLowerCase()
        .codeUnits
        .fold<int>(0, (a, b) => (a * 31 + b) & 0x7fffffff);
    return _palette[h % _palette.length];
  }
}

ThemeData buildTheme() {
  final base = ThemeData.dark(useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: AppColors.surface,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bg,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w900,
        color: Colors.white,
        letterSpacing: .3,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface2,
      hintStyle: const TextStyle(color: AppColors.muted),
      labelStyle: const TextStyle(color: AppColors.muted),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.black,
        minimumSize: const Size.fromHeight(54),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      indicatorColor: AppColors.primary.withValues(alpha: .22),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (s) => TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: s.contains(WidgetState.selected)
              ? AppColors.primary
              : AppColors.muted,
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (s) => IconThemeData(
          color: s.contains(WidgetState.selected)
              ? AppColors.primary
              : AppColors.muted,
        ),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.surface2,
      contentTextStyle: const TextStyle(color: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
  );
}
