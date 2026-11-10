// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'choice_spec.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ChoiceSpec extends ChoiceSpec {
  @override
  final String? icon;
  @override
  final String value;

  factory _$ChoiceSpec([void Function(ChoiceSpecBuilder)? updates]) =>
      (ChoiceSpecBuilder()..update(updates))._build();

  _$ChoiceSpec._({this.icon, required this.value}) : super._();
  @override
  ChoiceSpec rebuild(void Function(ChoiceSpecBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChoiceSpecBuilder toBuilder() => ChoiceSpecBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChoiceSpec && icon == other.icon && value == other.value;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, icon.hashCode);
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChoiceSpec')
          ..add('icon', icon)
          ..add('value', value))
        .toString();
  }
}

class ChoiceSpecBuilder implements Builder<ChoiceSpec, ChoiceSpecBuilder> {
  _$ChoiceSpec? _$v;

  String? _icon;
  String? get icon => _$this._icon;
  set icon(String? icon) => _$this._icon = icon;

  String? _value;
  String? get value => _$this._value;
  set value(String? value) => _$this._value = value;

  ChoiceSpecBuilder() {
    ChoiceSpec._defaults(this);
  }

  ChoiceSpecBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _icon = $v.icon;
      _value = $v.value;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChoiceSpec other) {
    _$v = other as _$ChoiceSpec;
  }

  @override
  void update(void Function(ChoiceSpecBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChoiceSpec build() => _build();

  _$ChoiceSpec _build() {
    final _$result = _$v ??
        _$ChoiceSpec._(
          icon: icon,
          value: BuiltValueNullFieldError.checkNotNull(
              value, r'ChoiceSpec', 'value'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
