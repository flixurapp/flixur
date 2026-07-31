// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_error.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const APIErrorCodeEnum _$aPIErrorCodeEnum_DATABASE_ERROR =
    const APIErrorCodeEnum._('DATABASE_ERROR');
const APIErrorCodeEnum _$aPIErrorCodeEnum_INCORRECT_PASSWORD =
    const APIErrorCodeEnum._('INCORRECT_PASSWORD');
const APIErrorCodeEnum _$aPIErrorCodeEnum_INCORRECT_USERNAME =
    const APIErrorCodeEnum._('INCORRECT_USERNAME');
const APIErrorCodeEnum _$aPIErrorCodeEnum_INVALID_INPUT =
    const APIErrorCodeEnum._('INVALID_INPUT');
const APIErrorCodeEnum _$aPIErrorCodeEnum_TOO_LONG =
    const APIErrorCodeEnum._('TOO_LONG');
const APIErrorCodeEnum _$aPIErrorCodeEnum_TOO_SHORT =
    const APIErrorCodeEnum._('TOO_SHORT');

APIErrorCodeEnum _$aPIErrorCodeEnumValueOf(String name) {
  switch (name) {
    case 'DATABASE_ERROR':
      return _$aPIErrorCodeEnum_DATABASE_ERROR;
    case 'INCORRECT_PASSWORD':
      return _$aPIErrorCodeEnum_INCORRECT_PASSWORD;
    case 'INCORRECT_USERNAME':
      return _$aPIErrorCodeEnum_INCORRECT_USERNAME;
    case 'INVALID_INPUT':
      return _$aPIErrorCodeEnum_INVALID_INPUT;
    case 'TOO_LONG':
      return _$aPIErrorCodeEnum_TOO_LONG;
    case 'TOO_SHORT':
      return _$aPIErrorCodeEnum_TOO_SHORT;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<APIErrorCodeEnum> _$aPIErrorCodeEnumValues =
    BuiltSet<APIErrorCodeEnum>(const <APIErrorCodeEnum>[
  _$aPIErrorCodeEnum_DATABASE_ERROR,
  _$aPIErrorCodeEnum_INCORRECT_PASSWORD,
  _$aPIErrorCodeEnum_INCORRECT_USERNAME,
  _$aPIErrorCodeEnum_INVALID_INPUT,
  _$aPIErrorCodeEnum_TOO_LONG,
  _$aPIErrorCodeEnum_TOO_SHORT,
]);

Serializer<APIErrorCodeEnum> _$aPIErrorCodeEnumSerializer =
    _$APIErrorCodeEnumSerializer();

class _$APIErrorCodeEnumSerializer
    implements PrimitiveSerializer<APIErrorCodeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'DATABASE_ERROR': 'DATABASE_ERROR',
    'INCORRECT_PASSWORD': 'INCORRECT_PASSWORD',
    'INCORRECT_USERNAME': 'INCORRECT_USERNAME',
    'INVALID_INPUT': 'INVALID_INPUT',
    'TOO_LONG': 'TOO_LONG',
    'TOO_SHORT': 'TOO_SHORT',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'DATABASE_ERROR': 'DATABASE_ERROR',
    'INCORRECT_PASSWORD': 'INCORRECT_PASSWORD',
    'INCORRECT_USERNAME': 'INCORRECT_USERNAME',
    'INVALID_INPUT': 'INVALID_INPUT',
    'TOO_LONG': 'TOO_LONG',
    'TOO_SHORT': 'TOO_SHORT',
  };

  @override
  final Iterable<Type> types = const <Type>[APIErrorCodeEnum];
  @override
  final String wireName = 'APIErrorCodeEnum';

  @override
  Object serialize(Serializers serializers, APIErrorCodeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  APIErrorCodeEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      APIErrorCodeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$APIError extends APIError {
  @override
  final String? dollarSchema;
  @override
  final APIErrorCodeEnum code;
  @override
  final String? detail;

  factory _$APIError([void Function(APIErrorBuilder)? updates]) =>
      (APIErrorBuilder()..update(updates))._build();

  _$APIError._({this.dollarSchema, required this.code, this.detail})
      : super._();
  @override
  APIError rebuild(void Function(APIErrorBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  APIErrorBuilder toBuilder() => APIErrorBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is APIError &&
        dollarSchema == other.dollarSchema &&
        code == other.code &&
        detail == other.detail;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, dollarSchema.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, detail.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'APIError')
          ..add('dollarSchema', dollarSchema)
          ..add('code', code)
          ..add('detail', detail))
        .toString();
  }
}

class APIErrorBuilder implements Builder<APIError, APIErrorBuilder> {
  _$APIError? _$v;

  String? _dollarSchema;
  String? get dollarSchema => _$this._dollarSchema;
  set dollarSchema(String? dollarSchema) => _$this._dollarSchema = dollarSchema;

  APIErrorCodeEnum? _code;
  APIErrorCodeEnum? get code => _$this._code;
  set code(APIErrorCodeEnum? code) => _$this._code = code;

  String? _detail;
  String? get detail => _$this._detail;
  set detail(String? detail) => _$this._detail = detail;

  APIErrorBuilder() {
    APIError._defaults(this);
  }

  APIErrorBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _dollarSchema = $v.dollarSchema;
      _code = $v.code;
      _detail = $v.detail;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(APIError other) {
    _$v = other as _$APIError;
  }

  @override
  void update(void Function(APIErrorBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  APIError build() => _build();

  _$APIError _build() {
    final _$result = _$v ??
        _$APIError._(
          dollarSchema: dollarSchema,
          code:
              BuiltValueNullFieldError.checkNotNull(code, r'APIError', 'code'),
          detail: detail,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
