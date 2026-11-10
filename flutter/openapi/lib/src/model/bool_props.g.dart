// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bool_props.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BoolProps extends BoolProps {
  @override
  final bool defaultValue;

  factory _$BoolProps([void Function(BoolPropsBuilder)? updates]) =>
      (BoolPropsBuilder()..update(updates))._build();

  _$BoolProps._({required this.defaultValue}) : super._();
  @override
  BoolProps rebuild(void Function(BoolPropsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BoolPropsBuilder toBuilder() => BoolPropsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BoolProps && defaultValue == other.defaultValue;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, defaultValue.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BoolProps')
          ..add('defaultValue', defaultValue))
        .toString();
  }
}

class BoolPropsBuilder implements Builder<BoolProps, BoolPropsBuilder> {
  _$BoolProps? _$v;

  bool? _defaultValue;
  bool? get defaultValue => _$this._defaultValue;
  set defaultValue(bool? defaultValue) => _$this._defaultValue = defaultValue;

  BoolPropsBuilder() {
    BoolProps._defaults(this);
  }

  BoolPropsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _defaultValue = $v.defaultValue;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BoolProps other) {
    _$v = other as _$BoolProps;
  }

  @override
  void update(void Function(BoolPropsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BoolProps build() => _build();

  _$BoolProps _build() {
    final _$result = _$v ??
        _$BoolProps._(
          defaultValue: BuiltValueNullFieldError.checkNotNull(
              defaultValue, r'BoolProps', 'defaultValue'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
