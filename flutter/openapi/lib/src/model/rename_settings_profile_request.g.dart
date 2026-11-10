// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rename_settings_profile_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RenameSettingsProfileRequest extends RenameSettingsProfileRequest {
  @override
  final String? dollarSchema;
  @override
  final String name;

  factory _$RenameSettingsProfileRequest(
          [void Function(RenameSettingsProfileRequestBuilder)? updates]) =>
      (RenameSettingsProfileRequestBuilder()..update(updates))._build();

  _$RenameSettingsProfileRequest._({this.dollarSchema, required this.name})
      : super._();
  @override
  RenameSettingsProfileRequest rebuild(
          void Function(RenameSettingsProfileRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RenameSettingsProfileRequestBuilder toBuilder() =>
      RenameSettingsProfileRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RenameSettingsProfileRequest &&
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
    return (newBuiltValueToStringHelper(r'RenameSettingsProfileRequest')
          ..add('dollarSchema', dollarSchema)
          ..add('name', name))
        .toString();
  }
}

class RenameSettingsProfileRequestBuilder
    implements
        Builder<RenameSettingsProfileRequest,
            RenameSettingsProfileRequestBuilder> {
  _$RenameSettingsProfileRequest? _$v;

  String? _dollarSchema;
  String? get dollarSchema => _$this._dollarSchema;
  set dollarSchema(String? dollarSchema) => _$this._dollarSchema = dollarSchema;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  RenameSettingsProfileRequestBuilder() {
    RenameSettingsProfileRequest._defaults(this);
  }

  RenameSettingsProfileRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _dollarSchema = $v.dollarSchema;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RenameSettingsProfileRequest other) {
    _$v = other as _$RenameSettingsProfileRequest;
  }

  @override
  void update(void Function(RenameSettingsProfileRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RenameSettingsProfileRequest build() => _build();

  _$RenameSettingsProfileRequest _build() {
    final _$result = _$v ??
        _$RenameSettingsProfileRequest._(
          dollarSchema: dollarSchema,
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'RenameSettingsProfileRequest', 'name'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
