// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_choice.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SettingsChoice extends SettingsChoice {
  @override
  final bool? hasDescription;
  @override
  final String? icon;
  @override
  final String value;

  factory _$SettingsChoice([void Function(SettingsChoiceBuilder)? updates]) =>
      (SettingsChoiceBuilder()..update(updates))._build();

  _$SettingsChoice._({this.hasDescription, this.icon, required this.value})
      : super._();
  @override
  SettingsChoice rebuild(void Function(SettingsChoiceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SettingsChoiceBuilder toBuilder() => SettingsChoiceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SettingsChoice &&
        hasDescription == other.hasDescription &&
        icon == other.icon &&
        value == other.value;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, hasDescription.hashCode);
    _$hash = $jc(_$hash, icon.hashCode);
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SettingsChoice')
          ..add('hasDescription', hasDescription)
          ..add('icon', icon)
          ..add('value', value))
        .toString();
  }
}

class SettingsChoiceBuilder
    implements Builder<SettingsChoice, SettingsChoiceBuilder> {
  _$SettingsChoice? _$v;

  bool? _hasDescription;
  bool? get hasDescription => _$this._hasDescription;
  set hasDescription(bool? hasDescription) =>
      _$this._hasDescription = hasDescription;

  String? _icon;
  String? get icon => _$this._icon;
  set icon(String? icon) => _$this._icon = icon;

  String? _value;
  String? get value => _$this._value;
  set value(String? value) => _$this._value = value;

  SettingsChoiceBuilder() {
    SettingsChoice._defaults(this);
  }

  SettingsChoiceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _hasDescription = $v.hasDescription;
      _icon = $v.icon;
      _value = $v.value;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SettingsChoice other) {
    _$v = other as _$SettingsChoice;
  }

  @override
  void update(void Function(SettingsChoiceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SettingsChoice build() => _build();

  _$SettingsChoice _build() {
    final _$result = _$v ??
        _$SettingsChoice._(
          hasDescription: hasDescription,
          icon: icon,
          value: BuiltValueNullFieldError.checkNotNull(
              value, r'SettingsChoice', 'value'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
