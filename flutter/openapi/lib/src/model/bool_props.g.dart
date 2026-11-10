// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bool_props.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BoolProps extends BoolProps {
  @override
  final bool default_;

  factory _$BoolProps([void Function(BoolPropsBuilder)? updates]) =>
      (BoolPropsBuilder()..update(updates))._build();

  _$BoolProps._({required this.default_}) : super._();
  @override
  BoolProps rebuild(void Function(BoolPropsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BoolPropsBuilder toBuilder() => BoolPropsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BoolProps && default_ == other.default_;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, default_.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BoolProps')
          ..add('default_', default_))
        .toString();
  }
}

class BoolPropsBuilder implements Builder<BoolProps, BoolPropsBuilder> {
  _$BoolProps? _$v;

  bool? _default_;
  bool? get default_ => _$this._default_;
  set default_(bool? default_) => _$this._default_ = default_;

  BoolPropsBuilder() {
    BoolProps._defaults(this);
  }

  BoolPropsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _default_ = $v.default_;
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
          default_: BuiltValueNullFieldError.checkNotNull(
              default_, r'BoolProps', 'default_'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
