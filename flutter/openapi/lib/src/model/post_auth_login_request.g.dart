// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_auth_login_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PostAuthLoginRequest extends PostAuthLoginRequest {
  @override
  final String? dollarSchema;
  @override
  final String password;
  @override
  final String username;

  factory _$PostAuthLoginRequest(
          [void Function(PostAuthLoginRequestBuilder)? updates]) =>
      (PostAuthLoginRequestBuilder()..update(updates))._build();

  _$PostAuthLoginRequest._(
      {this.dollarSchema, required this.password, required this.username})
      : super._();
  @override
  PostAuthLoginRequest rebuild(
          void Function(PostAuthLoginRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PostAuthLoginRequestBuilder toBuilder() =>
      PostAuthLoginRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PostAuthLoginRequest &&
        dollarSchema == other.dollarSchema &&
        password == other.password &&
        username == other.username;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, dollarSchema.hashCode);
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jc(_$hash, username.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PostAuthLoginRequest')
          ..add('dollarSchema', dollarSchema)
          ..add('password', password)
          ..add('username', username))
        .toString();
  }
}

class PostAuthLoginRequestBuilder
    implements Builder<PostAuthLoginRequest, PostAuthLoginRequestBuilder> {
  _$PostAuthLoginRequest? _$v;

  String? _dollarSchema;
  String? get dollarSchema => _$this._dollarSchema;
  set dollarSchema(String? dollarSchema) => _$this._dollarSchema = dollarSchema;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  String? _username;
  String? get username => _$this._username;
  set username(String? username) => _$this._username = username;

  PostAuthLoginRequestBuilder() {
    PostAuthLoginRequest._defaults(this);
  }

  PostAuthLoginRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _dollarSchema = $v.dollarSchema;
      _password = $v.password;
      _username = $v.username;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PostAuthLoginRequest other) {
    _$v = other as _$PostAuthLoginRequest;
  }

  @override
  void update(void Function(PostAuthLoginRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PostAuthLoginRequest build() => _build();

  _$PostAuthLoginRequest _build() {
    final _$result = _$v ??
        _$PostAuthLoginRequest._(
          dollarSchema: dollarSchema,
          password: BuiltValueNullFieldError.checkNotNull(
              password, r'PostAuthLoginRequest', 'password'),
          username: BuiltValueNullFieldError.checkNotNull(
              username, r'PostAuthLoginRequest', 'username'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
