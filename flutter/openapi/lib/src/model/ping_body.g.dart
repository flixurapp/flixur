// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ping_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PingBody extends PingBody {
  @override
  final String? dollarSchema;
  @override
  final bool isSetup;
  @override
  final int protocolVersion;
  @override
  final String supportsOIDCLogin;
  @override
  final bool supportsPasswordLogin;
  @override
  final String version;

  factory _$PingBody([void Function(PingBodyBuilder)? updates]) =>
      (PingBodyBuilder()..update(updates))._build();

  _$PingBody._(
      {this.dollarSchema,
      required this.isSetup,
      required this.protocolVersion,
      required this.supportsOIDCLogin,
      required this.supportsPasswordLogin,
      required this.version})
      : super._();
  @override
  PingBody rebuild(void Function(PingBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PingBodyBuilder toBuilder() => PingBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PingBody &&
        dollarSchema == other.dollarSchema &&
        isSetup == other.isSetup &&
        protocolVersion == other.protocolVersion &&
        supportsOIDCLogin == other.supportsOIDCLogin &&
        supportsPasswordLogin == other.supportsPasswordLogin &&
        version == other.version;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, dollarSchema.hashCode);
    _$hash = $jc(_$hash, isSetup.hashCode);
    _$hash = $jc(_$hash, protocolVersion.hashCode);
    _$hash = $jc(_$hash, supportsOIDCLogin.hashCode);
    _$hash = $jc(_$hash, supportsPasswordLogin.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PingBody')
          ..add('dollarSchema', dollarSchema)
          ..add('isSetup', isSetup)
          ..add('protocolVersion', protocolVersion)
          ..add('supportsOIDCLogin', supportsOIDCLogin)
          ..add('supportsPasswordLogin', supportsPasswordLogin)
          ..add('version', version))
        .toString();
  }
}

class PingBodyBuilder implements Builder<PingBody, PingBodyBuilder> {
  _$PingBody? _$v;

  String? _dollarSchema;
  String? get dollarSchema => _$this._dollarSchema;
  set dollarSchema(String? dollarSchema) => _$this._dollarSchema = dollarSchema;

  bool? _isSetup;
  bool? get isSetup => _$this._isSetup;
  set isSetup(bool? isSetup) => _$this._isSetup = isSetup;

  int? _protocolVersion;
  int? get protocolVersion => _$this._protocolVersion;
  set protocolVersion(int? protocolVersion) =>
      _$this._protocolVersion = protocolVersion;

  String? _supportsOIDCLogin;
  String? get supportsOIDCLogin => _$this._supportsOIDCLogin;
  set supportsOIDCLogin(String? supportsOIDCLogin) =>
      _$this._supportsOIDCLogin = supportsOIDCLogin;

  bool? _supportsPasswordLogin;
  bool? get supportsPasswordLogin => _$this._supportsPasswordLogin;
  set supportsPasswordLogin(bool? supportsPasswordLogin) =>
      _$this._supportsPasswordLogin = supportsPasswordLogin;

  String? _version;
  String? get version => _$this._version;
  set version(String? version) => _$this._version = version;

  PingBodyBuilder() {
    PingBody._defaults(this);
  }

  PingBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _dollarSchema = $v.dollarSchema;
      _isSetup = $v.isSetup;
      _protocolVersion = $v.protocolVersion;
      _supportsOIDCLogin = $v.supportsOIDCLogin;
      _supportsPasswordLogin = $v.supportsPasswordLogin;
      _version = $v.version;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PingBody other) {
    _$v = other as _$PingBody;
  }

  @override
  void update(void Function(PingBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PingBody build() => _build();

  _$PingBody _build() {
    final _$result = _$v ??
        _$PingBody._(
          dollarSchema: dollarSchema,
          isSetup: BuiltValueNullFieldError.checkNotNull(
              isSetup, r'PingBody', 'isSetup'),
          protocolVersion: BuiltValueNullFieldError.checkNotNull(
              protocolVersion, r'PingBody', 'protocolVersion'),
          supportsOIDCLogin: BuiltValueNullFieldError.checkNotNull(
              supportsOIDCLogin, r'PingBody', 'supportsOIDCLogin'),
          supportsPasswordLogin: BuiltValueNullFieldError.checkNotNull(
              supportsPasswordLogin, r'PingBody', 'supportsPasswordLogin'),
          version: BuiltValueNullFieldError.checkNotNull(
              version, r'PingBody', 'version'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
