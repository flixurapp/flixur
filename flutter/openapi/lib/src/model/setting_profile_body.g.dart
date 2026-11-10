// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting_profile_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SettingProfileBody extends SettingProfileBody {
  @override
  final String? dollarSchema;
  @override
  final DateTime createdAt;
  @override
  final String id;
  @override
  final String name;

  factory _$SettingProfileBody(
          [void Function(SettingProfileBodyBuilder)? updates]) =>
      (SettingProfileBodyBuilder()..update(updates))._build();

  _$SettingProfileBody._(
      {this.dollarSchema,
      required this.createdAt,
      required this.id,
      required this.name})
      : super._();
  @override
  SettingProfileBody rebuild(
          void Function(SettingProfileBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SettingProfileBodyBuilder toBuilder() =>
      SettingProfileBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SettingProfileBody &&
        dollarSchema == other.dollarSchema &&
        createdAt == other.createdAt &&
        id == other.id &&
        name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, dollarSchema.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SettingProfileBody')
          ..add('dollarSchema', dollarSchema)
          ..add('createdAt', createdAt)
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class SettingProfileBodyBuilder
    implements Builder<SettingProfileBody, SettingProfileBodyBuilder> {
  _$SettingProfileBody? _$v;

  String? _dollarSchema;
  String? get dollarSchema => _$this._dollarSchema;
  set dollarSchema(String? dollarSchema) => _$this._dollarSchema = dollarSchema;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  SettingProfileBodyBuilder() {
    SettingProfileBody._defaults(this);
  }

  SettingProfileBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _dollarSchema = $v.dollarSchema;
      _createdAt = $v.createdAt;
      _id = $v.id;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SettingProfileBody other) {
    _$v = other as _$SettingProfileBody;
  }

  @override
  void update(void Function(SettingProfileBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SettingProfileBody build() => _build();

  _$SettingProfileBody _build() {
    final _$result = _$v ??
        _$SettingProfileBody._(
          dollarSchema: dollarSchema,
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'SettingProfileBody', 'createdAt'),
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'SettingProfileBody', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'SettingProfileBody', 'name'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
