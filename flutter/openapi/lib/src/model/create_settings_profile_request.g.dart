// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_settings_profile_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreateSettingsProfileRequest extends CreateSettingsProfileRequest {
  @override
  final String? dollarSchema;
  @override
  final String name;

  factory _$CreateSettingsProfileRequest(
          [void Function(CreateSettingsProfileRequestBuilder)? updates]) =>
      (CreateSettingsProfileRequestBuilder()..update(updates))._build();

  _$CreateSettingsProfileRequest._({this.dollarSchema, required this.name})
      : super._();
  @override
  CreateSettingsProfileRequest rebuild(
          void Function(CreateSettingsProfileRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateSettingsProfileRequestBuilder toBuilder() =>
      CreateSettingsProfileRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateSettingsProfileRequest &&
        dollarSchema == other.dollarSchema &&
        name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, dollarSchema.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateSettingsProfileRequest')
          ..add('dollarSchema', dollarSchema)
          ..add('name', name))
        .toString();
  }
}

class CreateSettingsProfileRequestBuilder
    implements
        Builder<CreateSettingsProfileRequest,
            CreateSettingsProfileRequestBuilder> {
  _$CreateSettingsProfileRequest? _$v;

  String? _dollarSchema;
  String? get dollarSchema => _$this._dollarSchema;
  set dollarSchema(String? dollarSchema) => _$this._dollarSchema = dollarSchema;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  CreateSettingsProfileRequestBuilder() {
    CreateSettingsProfileRequest._defaults(this);
  }

  CreateSettingsProfileRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _dollarSchema = $v.dollarSchema;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateSettingsProfileRequest other) {
    _$v = other as _$CreateSettingsProfileRequest;
  }

  @override
  void update(void Function(CreateSettingsProfileRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateSettingsProfileRequest build() => _build();

  _$CreateSettingsProfileRequest _build() {
    final _$result = _$v ??
        _$CreateSettingsProfileRequest._(
          dollarSchema: dollarSchema,
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'CreateSettingsProfileRequest', 'name'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
