// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_server_setting_value_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateServerSettingValueRequest
    extends UpdateServerSettingValueRequest {
  @override
  final String? dollarSchema;
  @override
  final String value;

  factory _$UpdateServerSettingValueRequest(
          [void Function(UpdateServerSettingValueRequestBuilder)? updates]) =>
      (UpdateServerSettingValueRequestBuilder()..update(updates))._build();

  _$UpdateServerSettingValueRequest._({this.dollarSchema, required this.value})
      : super._();
  @override
  UpdateServerSettingValueRequest rebuild(
          void Function(UpdateServerSettingValueRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateServerSettingValueRequestBuilder toBuilder() =>
      UpdateServerSettingValueRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateServerSettingValueRequest &&
        dollarSchema == other.dollarSchema &&
        value == other.value;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, dollarSchema.hashCode);
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateServerSettingValueRequest')
          ..add('dollarSchema', dollarSchema)
          ..add('value', value))
        .toString();
  }
}

class UpdateServerSettingValueRequestBuilder
    implements
        Builder<UpdateServerSettingValueRequest,
            UpdateServerSettingValueRequestBuilder> {
  _$UpdateServerSettingValueRequest? _$v;

  String? _dollarSchema;
  String? get dollarSchema => _$this._dollarSchema;
  set dollarSchema(String? dollarSchema) => _$this._dollarSchema = dollarSchema;

  String? _value;
  String? get value => _$this._value;
  set value(String? value) => _$this._value = value;

  UpdateServerSettingValueRequestBuilder() {
    UpdateServerSettingValueRequest._defaults(this);
  }

  UpdateServerSettingValueRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _dollarSchema = $v.dollarSchema;
      _value = $v.value;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateServerSettingValueRequest other) {
    _$v = other as _$UpdateServerSettingValueRequest;
  }

  @override
  void update(void Function(UpdateServerSettingValueRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateServerSettingValueRequest build() => _build();

  _$UpdateServerSettingValueRequest _build() {
    final _$result = _$v ??
        _$UpdateServerSettingValueRequest._(
          dollarSchema: dollarSchema,
          value: BuiltValueNullFieldError.checkNotNull(
              value, r'UpdateServerSettingValueRequest', 'value'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
