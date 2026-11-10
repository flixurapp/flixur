// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_profiles_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SettingsProfilesBody extends SettingsProfilesBody {
  @override
  final String? dollarSchema;
  @override
  final BuiltList<SettingProfileBody> list;

  factory _$SettingsProfilesBody(
          [void Function(SettingsProfilesBodyBuilder)? updates]) =>
      (SettingsProfilesBodyBuilder()..update(updates))._build();

  _$SettingsProfilesBody._({this.dollarSchema, required this.list}) : super._();
  @override
  SettingsProfilesBody rebuild(
          void Function(SettingsProfilesBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SettingsProfilesBodyBuilder toBuilder() =>
      SettingsProfilesBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SettingsProfilesBody &&
        dollarSchema == other.dollarSchema &&
        list == other.list;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, dollarSchema.hashCode);
    _$hash = $jc(_$hash, list.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SettingsProfilesBody')
          ..add('dollarSchema', dollarSchema)
          ..add('list', list))
        .toString();
  }
}

class SettingsProfilesBodyBuilder
    implements Builder<SettingsProfilesBody, SettingsProfilesBodyBuilder> {
  _$SettingsProfilesBody? _$v;

  String? _dollarSchema;
  String? get dollarSchema => _$this._dollarSchema;
  set dollarSchema(String? dollarSchema) => _$this._dollarSchema = dollarSchema;

  ListBuilder<SettingProfileBody>? _list;
  ListBuilder<SettingProfileBody> get list =>
      _$this._list ??= ListBuilder<SettingProfileBody>();
  set list(ListBuilder<SettingProfileBody>? list) => _$this._list = list;

  SettingsProfilesBodyBuilder() {
    SettingsProfilesBody._defaults(this);
  }

  SettingsProfilesBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _dollarSchema = $v.dollarSchema;
      _list = $v.list.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SettingsProfilesBody other) {
    _$v = other as _$SettingsProfilesBody;
  }

  @override
  void update(void Function(SettingsProfilesBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SettingsProfilesBody build() => _build();

  _$SettingsProfilesBody _build() {
    _$SettingsProfilesBody _$result;
    try {
      _$result = _$v ??
          _$SettingsProfilesBody._(
            dollarSchema: dollarSchema,
            list: list.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'list';
        list.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SettingsProfilesBody', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
