// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oidc_init_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OIDCInitBody extends OIDCInitBody {
  @override
  final String? dollarSchema;
  @override
  final String loginURL;

  factory _$OIDCInitBody([void Function(OIDCInitBodyBuilder)? updates]) =>
      (OIDCInitBodyBuilder()..update(updates))._build();

  _$OIDCInitBody._({this.dollarSchema, required this.loginURL}) : super._();
  @override
  OIDCInitBody rebuild(void Function(OIDCInitBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OIDCInitBodyBuilder toBuilder() => OIDCInitBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OIDCInitBody &&
        dollarSchema == other.dollarSchema &&
        loginURL == other.loginURL;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, dollarSchema.hashCode);
    _$hash = $jc(_$hash, loginURL.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OIDCInitBody')
          ..add('dollarSchema', dollarSchema)
          ..add('loginURL', loginURL))
        .toString();
  }
}

class OIDCInitBodyBuilder
    implements Builder<OIDCInitBody, OIDCInitBodyBuilder> {
  _$OIDCInitBody? _$v;

  String? _dollarSchema;
  String? get dollarSchema => _$this._dollarSchema;
  set dollarSchema(String? dollarSchema) => _$this._dollarSchema = dollarSchema;

  String? _loginURL;
  String? get loginURL => _$this._loginURL;
  set loginURL(String? loginURL) => _$this._loginURL = loginURL;

  OIDCInitBodyBuilder() {
    OIDCInitBody._defaults(this);
  }

  OIDCInitBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _dollarSchema = $v.dollarSchema;
      _loginURL = $v.loginURL;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OIDCInitBody other) {
    _$v = other as _$OIDCInitBody;
  }

  @override
  void update(void Function(OIDCInitBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OIDCInitBody build() => _build();

  _$OIDCInitBody _build() {
    final _$result = _$v ??
        _$OIDCInitBody._(
          dollarSchema: dollarSchema,
          loginURL: BuiltValueNullFieldError.checkNotNull(
              loginURL, r'OIDCInitBody', 'loginURL'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
