// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_token_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SessionTokenBody extends SessionTokenBody {
  @override
  final String? dollarSchema;
  @override
  final String sessionToken;

  factory _$SessionTokenBody(
          [void Function(SessionTokenBodyBuilder)? updates]) =>
      (SessionTokenBodyBuilder()..update(updates))._build();

  _$SessionTokenBody._({this.dollarSchema, required this.sessionToken})
      : super._();
  @override
  SessionTokenBody rebuild(void Function(SessionTokenBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SessionTokenBodyBuilder toBuilder() =>
      SessionTokenBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SessionTokenBody &&
        dollarSchema == other.dollarSchema &&
        sessionToken == other.sessionToken;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, dollarSchema.hashCode);
    _$hash = $jc(_$hash, sessionToken.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SessionTokenBody')
          ..add('dollarSchema', dollarSchema)
          ..add('sessionToken', sessionToken))
        .toString();
  }
}

class SessionTokenBodyBuilder
    implements Builder<SessionTokenBody, SessionTokenBodyBuilder> {
  _$SessionTokenBody? _$v;

  String? _dollarSchema;
  String? get dollarSchema => _$this._dollarSchema;
  set dollarSchema(String? dollarSchema) => _$this._dollarSchema = dollarSchema;

  String? _sessionToken;
  String? get sessionToken => _$this._sessionToken;
  set sessionToken(String? sessionToken) => _$this._sessionToken = sessionToken;

  SessionTokenBodyBuilder() {
    SessionTokenBody._defaults(this);
  }

  SessionTokenBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _dollarSchema = $v.dollarSchema;
      _sessionToken = $v.sessionToken;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SessionTokenBody other) {
    _$v = other as _$SessionTokenBody;
  }

  @override
  void update(void Function(SessionTokenBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SessionTokenBody build() => _build();

  _$SessionTokenBody _build() {
    final _$result = _$v ??
        _$SessionTokenBody._(
          dollarSchema: dollarSchema,
          sessionToken: BuiltValueNullFieldError.checkNotNull(
              sessionToken, r'SessionTokenBody', 'sessionToken'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
