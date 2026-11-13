import "package:material_ui/material_ui.dart";
import "package:theme_tailor_annotation/theme_tailor_annotation.dart";

// ignore_for_file: annotate_overrides - fields are supposed to be overridden

part "theme.tailor.dart";

// copyWith / lerp / == / hashCode generated in theme.tailor.dart
@TailorMixinComponent()
class const AppColors({
  required final Brightness brightness,
  required final Color primary,
  required final Color secondary,
  required final Color tertiary,
  required final Color success,
  required final Color error,
  required final Color crust,
  required final Color mantle,
  required final Color base,
  required final Color text,
  required final Color textMuted,
  final Color? onPrimaryOverride,
  final Color? onSecondaryOverride,
}) extends ThemeExtension<AppColors> with _$AppColorsTailorMixin;

// derived `on` colors
extension AppColorsDerived on AppColors {
  Color get onPrimary => onPrimaryOverride ?? text;
  Color get onSecondary => onSecondaryOverride ?? base;
}

extension AppThemeContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}

enum AppTheme(final AppColors colors) {
  dark(
    AppColors(
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
  ),
  catppuccinMocha(
    AppColors(
      brightness: .dark,
      primary: Color(0xFFCBA6F7), // Mauve
      secondary: Color(0xFF94E2D5), // Teal
      tertiary: Color(0xFFF9E2AF), // Yellow
      success: Color(0xFFA6E3A1),
      error: Color(0xFFF38BA8),
      crust: Color(0xFF11111B),
      mantle: Color(0xFF181825),
      base: Color(0xFF1E1E2E),
      text: Color(0xFFCDD6F4),
      textMuted: Color(0xFFA6ADC8),
      onPrimaryOverride: Color(0xFF1E1E2E),
    ),
  );

  ThemeData get theme => buildAppTheme(colors);
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
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colors.primary,
        textStyle: const TextStyle(fontWeight: .w500),
        enabledMouseCursor: SystemMouseCursors.click,
        disabledMouseCursor: SystemMouseCursors.forbidden,
      ),
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
    iconTheme: IconThemeData(color: colors.text),
    switchTheme: .new(
      trackColor: .resolveWith(
        (s) => switch (s.mainState) {
          .selected => colors.primary,
          _ => Colors.transparent,
        },
      ),
      thumbColor: .resolveWith(
        (s) => switch (s.mainState) {
          .selected => colors.onPrimary,
          .hovered => colors.primary,
          _ => colors.textMuted,
        },
      ),
      trackOutlineWidth: .all(2),
      trackOutlineColor: .resolveWith(
        (s) => switch (s.mainState) {
          _ when s.has(.hovered) && s.has(.selected) => colors.onPrimary,
          .selected => Colors.transparent,
          _ => colors.textMuted,
        },
      ),
      overlayColor: .all(Colors.transparent),
    ),
    tooltipTheme: .new(
      preferBelow: false,
      decoration: BoxDecoration(
        border: .all(color: colors.textMuted.withValues(alpha: 0.5)),
        borderRadius: const .all(.circular(4)),
        color: colors.crust,
      ),
      textStyle: .new(color: colors.text),
      padding: const .symmetric(horizontal: 12, vertical: 6),
    ),
  );
}

extension WidgetStateSetX on Set<WidgetState> {
  /// Returns the "most important" state from the set for use with switch().
  WidgetState? get mainState {
    // ordered in order of importance
    const priority = <WidgetState>[
      .disabled,
      .error,
      .dragged,
      .pressed,
      .selected,
      .hovered,
      .focused,
      .scrolledUnder,
    ];
    for (final state in priority) {
      if (contains(state)) return state;
    }
    return null;
  }

  /// Typed check function to see if a state exists.
  bool has(WidgetState state) => contains(state);
}
