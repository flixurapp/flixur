// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_settings_profile_value_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateSettingsProfileValueRequest
    extends UpdateSettingsProfileValueRequest {
  @override
  final String? dollarSchema;
  @override
  final String value;

  factory _$UpdateSettingsProfileValueRequest(
          [void Function(UpdateSettingsProfileValueRequestBuilder)? updates]) =>
      (UpdateSettingsProfileValueRequestBuilder()..update(updates))._build();

  _$UpdateSettingsProfileValueRequest._(
      {this.dollarSchema, required this.value})
      : super._();
  @override
  UpdateSettingsProfileValueRequest rebuild(
          void Function(UpdateSettingsProfileValueRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateSettingsProfileValueRequestBuilder toBuilder() =>
      UpdateSettingsProfileValueRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateSettingsProfileValueRequest &&
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
    return (newBuiltValueToStringHelper(r'UpdateSettingsProfileValueRequest')
          ..add('dollarSchema', dollarSchema)
          ..add('value', value))
        .toString();
  }
}

class UpdateSettingsProfileValueRequestBuilder
    implements
        Builder<UpdateSettingsProfileValueRequest,
            UpdateSettingsProfileValueRequestBuilder> {
  _$UpdateSettingsProfileValueRequest? _$v;

  String? _dollarSchema;
  String? get dollarSchema => _$this._dollarSchema;
  set dollarSchema(String? dollarSchema) => _$this._dollarSchema = dollarSchema;

  String? _value;
  String? get value => _$this._value;
  set value(String? value) => _$this._value = value;

  UpdateSettingsProfileValueRequestBuilder() {
    UpdateSettingsProfileValueRequest._defaults(this);
  }

  UpdateSettingsProfileValueRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _dollarSchema = $v.dollarSchema;
      _value = $v.value;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateSettingsProfileValueRequest other) {
    _$v = other as _$UpdateSettingsProfileValueRequest;
  }

  @override
  void update(
      void Function(UpdateSettingsProfileValueRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateSettingsProfileValueRequest build() => _build();

  _$UpdateSettingsProfileValueRequest _build() {
    final _$result = _$v ??
        _$UpdateSettingsProfileValueRequest._(
          dollarSchema: dollarSchema,
          value: BuiltValueNullFieldError.checkNotNull(
              value, r'UpdateSettingsProfileValueRequest', 'value'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
