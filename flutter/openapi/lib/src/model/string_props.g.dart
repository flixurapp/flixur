// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'string_props.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StringProps extends StringProps {
  @override
  final String? default_;
  @override
  final int? maxLength;
  @override
  final bool? secret;

  factory _$StringProps([void Function(StringPropsBuilder)? updates]) =>
      (StringPropsBuilder()..update(updates))._build();

  _$StringProps._({this.default_, this.maxLength, this.secret}) : super._();
  @override
  StringProps rebuild(void Function(StringPropsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StringPropsBuilder toBuilder() => StringPropsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StringProps &&
        default_ == other.default_ &&
        maxLength == other.maxLength &&
        secret == other.secret;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, default_.hashCode);
    _$hash = $jc(_$hash, maxLength.hashCode);
    _$hash = $jc(_$hash, secret.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StringProps')
          ..add('default_', default_)
          ..add('maxLength', maxLength)
          ..add('secret', secret))
        .toString();
  }
}

class StringPropsBuilder implements Builder<StringProps, StringPropsBuilder> {
  _$StringProps? _$v;

  String? _default_;
  String? get default_ => _$this._default_;
  set default_(String? default_) => _$this._default_ = default_;

  int? _maxLength;
  int? get maxLength => _$this._maxLength;
  set maxLength(int? maxLength) => _$this._maxLength = maxLength;

  bool? _secret;
  bool? get secret => _$this._secret;
  set secret(bool? secret) => _$this._secret = secret;

  StringPropsBuilder() {
    StringProps._defaults(this);
  }

  StringPropsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _default_ = $v.default_;
      _maxLength = $v.maxLength;
      _secret = $v.secret;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StringProps other) {
    _$v = other as _$StringProps;
  }

  @override
  void update(void Function(StringPropsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StringProps build() => _build();

  _$StringProps _build() {
    final _$result = _$v ??
        _$StringProps._(
          default_: default_,
          maxLength: maxLength,
          secret: secret,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
