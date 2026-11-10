// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enum_props.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EnumProps extends EnumProps {
  @override
  final BuiltList<ChoiceSpec>? choices;
  @override
  final String defaultValue;

  factory _$EnumProps([void Function(EnumPropsBuilder)? updates]) =>
      (EnumPropsBuilder()..update(updates))._build();

  _$EnumProps._({this.choices, required this.defaultValue}) : super._();
  @override
  EnumProps rebuild(void Function(EnumPropsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EnumPropsBuilder toBuilder() => EnumPropsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EnumProps &&
        choices == other.choices &&
        defaultValue == other.defaultValue;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, choices.hashCode);
    _$hash = $jc(_$hash, defaultValue.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EnumProps')
          ..add('choices', choices)
          ..add('defaultValue', defaultValue))
        .toString();
  }
}

class EnumPropsBuilder implements Builder<EnumProps, EnumPropsBuilder> {
  _$EnumProps? _$v;

  ListBuilder<ChoiceSpec>? _choices;
  ListBuilder<ChoiceSpec> get choices =>
      _$this._choices ??= ListBuilder<ChoiceSpec>();
  set choices(ListBuilder<ChoiceSpec>? choices) => _$this._choices = choices;

  String? _defaultValue;
  String? get defaultValue => _$this._defaultValue;
  set defaultValue(String? defaultValue) => _$this._defaultValue = defaultValue;

  EnumPropsBuilder() {
    EnumProps._defaults(this);
  }

  EnumPropsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _choices = $v.choices?.toBuilder();
      _defaultValue = $v.defaultValue;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EnumProps other) {
    _$v = other as _$EnumProps;
  }

  @override
  void update(void Function(EnumPropsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EnumProps build() => _build();

  _$EnumProps _build() {
    _$EnumProps _$result;
    try {
      _$result = _$v ??
          _$EnumProps._(
            choices: _choices?.build(),
            defaultValue: BuiltValueNullFieldError.checkNotNull(
                defaultValue, r'EnumProps', 'defaultValue'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'choices';
        _choices?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'EnumProps', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
