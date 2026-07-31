// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_auth_setup_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PostAuthSetupRequest extends PostAuthSetupRequest {
  @override
  final String? dollarSchema;
  @override
  final String code;
  @override
  final String password;
  @override
  final String username;

  factory _$PostAuthSetupRequest(
          [void Function(PostAuthSetupRequestBuilder)? updates]) =>
      (PostAuthSetupRequestBuilder()..update(updates))._build();

  _$PostAuthSetupRequest._(
      {this.dollarSchema,
      required this.code,
      required this.password,
      required this.username})
      : super._();
  @override
  PostAuthSetupRequest rebuild(
          void Function(PostAuthSetupRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PostAuthSetupRequestBuilder toBuilder() =>
      PostAuthSetupRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PostAuthSetupRequest &&
        dollarSchema == other.dollarSchema &&
        code == other.code &&
        password == other.password &&
        username == other.username;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, dollarSchema.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jc(_$hash, username.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PostAuthSetupRequest')
          ..add('dollarSchema', dollarSchema)
          ..add('code', code)
          ..add('password', password)
          ..add('username', username))
        .toString();
  }
}

class PostAuthSetupRequestBuilder
    implements Builder<PostAuthSetupRequest, PostAuthSetupRequestBuilder> {
  _$PostAuthSetupRequest? _$v;

  String? _dollarSchema;
  String? get dollarSchema => _$this._dollarSchema;
  set dollarSchema(String? dollarSchema) => _$this._dollarSchema = dollarSchema;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  String? _username;
  String? get username => _$this._username;
  set username(String? username) => _$this._username = username;

  PostAuthSetupRequestBuilder() {
    PostAuthSetupRequest._defaults(this);
  }

  PostAuthSetupRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _dollarSchema = $v.dollarSchema;
      _code = $v.code;
      _password = $v.password;
      _username = $v.username;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PostAuthSetupRequest other) {
    _$v = other as _$PostAuthSetupRequest;
  }

  @override
  void update(void Function(PostAuthSetupRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PostAuthSetupRequest build() => _build();

  _$PostAuthSetupRequest _build() {
    final _$result = _$v ??
        _$PostAuthSetupRequest._(
          dollarSchema: dollarSchema,
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'PostAuthSetupRequest', 'code'),
          password: BuiltValueNullFieldError.checkNotNull(
              password, r'PostAuthSetupRequest', 'password'),
          username: BuiltValueNullFieldError.checkNotNull(
              username, r'PostAuthSetupRequest', 'username'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
