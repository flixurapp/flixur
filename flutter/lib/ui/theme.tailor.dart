// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'theme.dart';

// **************************************************************************
// TailorAnnotationsGenerator
// **************************************************************************

mixin _$AppColorsTailorMixin on ThemeExtension<AppColors> {
  Brightness get brightness;
  Color get primary;
  Color get secondary;
  Color get tertiary;
  Color get success;
  Color get error;
  Color get warn;
  Color get crust;
  Color get mantle;
  Color get base;
  Color get text;
  Color get textMuted;
  Color? get onPrimaryOverride;
  Color? get onSecondaryOverride;

  @override
  AppColors copyWith({
    Brightness? brightness,
    Color? primary,
    Color? secondary,
    Color? tertiary,
    Color? success,
    Color? error,
    Color? warn,
    Color? crust,
    Color? mantle,
    Color? base,
    Color? text,
    Color? textMuted,
    Color? onPrimaryOverride,
    Color? onSecondaryOverride,
  }) {
    return AppColors(
      brightness: brightness ?? this.brightness,
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      tertiary: tertiary ?? this.tertiary,
      success: success ?? this.success,
      error: error ?? this.error,
      warn: warn ?? this.warn,
      crust: crust ?? this.crust,
      mantle: mantle ?? this.mantle,
      base: base ?? this.base,
      text: text ?? this.text,
      textMuted: textMuted ?? this.textMuted,
      onPrimaryOverride: onPrimaryOverride ?? this.onPrimaryOverride,
      onSecondaryOverride: onSecondaryOverride ?? this.onSecondaryOverride,
    );
  }

  @override
  AppColors lerp(covariant ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this as AppColors;
    return AppColors(
      brightness: t < 0.5 ? brightness : other.brightness,
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      tertiary: Color.lerp(tertiary, other.tertiary, t)!,
      success: Color.lerp(success, other.success, t)!,
      error: Color.lerp(error, other.error, t)!,
      warn: Color.lerp(warn, other.warn, t)!,
      crust: Color.lerp(crust, other.crust, t)!,
      mantle: Color.lerp(mantle, other.mantle, t)!,
      base: Color.lerp(base, other.base, t)!,
      text: Color.lerp(text, other.text, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      onPrimaryOverride: Color.lerp(
        onPrimaryOverride,
        other.onPrimaryOverride,
        t,
      ),
      onSecondaryOverride: Color.lerp(
        onSecondaryOverride,
        other.onSecondaryOverride,
        t,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AppColors &&
            const DeepCollectionEquality().equals(
              brightness,
              other.brightness,
            ) &&
            const DeepCollectionEquality().equals(primary, other.primary) &&
            const DeepCollectionEquality().equals(secondary, other.secondary) &&
            const DeepCollectionEquality().equals(tertiary, other.tertiary) &&
            const DeepCollectionEquality().equals(success, other.success) &&
            const DeepCollectionEquality().equals(error, other.error) &&
            const DeepCollectionEquality().equals(warn, other.warn) &&
            const DeepCollectionEquality().equals(crust, other.crust) &&
            const DeepCollectionEquality().equals(mantle, other.mantle) &&
            const DeepCollectionEquality().equals(base, other.base) &&
            const DeepCollectionEquality().equals(text, other.text) &&
            const DeepCollectionEquality().equals(textMuted, other.textMuted) &&
            const DeepCollectionEquality().equals(
              onPrimaryOverride,
              other.onPrimaryOverride,
            ) &&
            const DeepCollectionEquality().equals(
              onSecondaryOverride,
              other.onSecondaryOverride,
            ));
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType.hashCode,
      const DeepCollectionEquality().hash(brightness),
      const DeepCollectionEquality().hash(primary),
      const DeepCollectionEquality().hash(secondary),
      const DeepCollectionEquality().hash(tertiary),
      const DeepCollectionEquality().hash(success),
      const DeepCollectionEquality().hash(error),
      const DeepCollectionEquality().hash(warn),
      const DeepCollectionEquality().hash(crust),
      const DeepCollectionEquality().hash(mantle),
      const DeepCollectionEquality().hash(base),
      const DeepCollectionEquality().hash(text),
      const DeepCollectionEquality().hash(textMuted),
      const DeepCollectionEquality().hash(onPrimaryOverride),
      const DeepCollectionEquality().hash(onSecondaryOverride),
    );
  }
}
