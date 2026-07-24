import "package:flutter/material.dart";

//TODO: use theme_tailor once it works??
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.brightness,
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.success,
    required this.error,
    required this.crust,
    required this.mantle,
    required this.base,
    required this.text,
    required this.textMuted,
  });
  final Brightness brightness;

  final Color primary;
  final Color secondary;
  final Color tertiary;
  final Color success;
  final Color error;
  final Color crust;
  final Color mantle;
  final Color base;
  final Color text;
  final Color textMuted;

  Color get onPrimary => text;

  // idc about these
  @override
  AppColors copyWith() => this;
  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) =>
      t < 0.5 ? this : (other as AppColors? ?? this);

  static AppColors of(AppThemeNames name) => switch (name) {
    .dark => const AppColors(
      brightness: .dark,
      primary: Color(0xFF3366DE),
      secondary: Color(0xFF5633DE),
      tertiary: Color(0xFF33BCDE),
      success: Color(0xFF33DE55),
      error: Color(0xFFDE5533),
      crust: Color(0xFF040607),
      mantle: Color(0xFF090C12),
      base: Color(0xFF21252D),
      text: Color(0xFFCED3E0),
      textMuted: Color(0xA5D9D9D9),
    ),

    .catppuccinMocha => const AppColors(
      brightness: .dark,
      primary: Color(0xFF89B4FA),
      secondary: Color(0xFF94E2D5),
      tertiary: Color(0xFFF9E2AF),
      success: Color(0xFFA6E3A1),
      error: Color(0xFFF38BA8),
      crust: Color(0xFF11111B),
      mantle: Color(0xFF181825),
      base: Color(0xFF1E1E2E),
      text: Color(0xFFCDD6F4),
      textMuted: Color(0xFFA6ADC8),
    ),
  };
}

enum AppThemeNames { dark, catppuccinMocha }

// add theme stuff to context
extension AppThemeContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}

ThemeData buildAppTheme(AppColors colors) {
  return ThemeData(
    brightness: colors.brightness,
    scaffoldBackgroundColor: colors.base,
    extensions: [colors],
    colorScheme: ColorScheme(
      brightness: colors.brightness,
      primary: colors.primary,
      onPrimary: colors.onPrimary,
      secondary: colors.secondary,
      onSecondary: colors.base,
      error: colors.error,
      onError: colors.base,
      surface: colors.mantle,
      onSurface: colors.text,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        enabledMouseCursor: SystemMouseCursors.click,
        disabledMouseCursor: SystemMouseCursors.forbidden,
      ),
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: colors.text),
      bodySmall: TextStyle(color: colors.textMuted),
    ),
  );
}
