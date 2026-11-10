// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_definitions_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SettingsDefinitionsBody extends SettingsDefinitionsBody {
  @override
  final String? dollarSchema;
  @override
  final BuiltList<SettingsGroup> groups;
  @override
  final BuiltList<SettingsDefinition> list;

  factory _$SettingsDefinitionsBody(
          [void Function(SettingsDefinitionsBodyBuilder)? updates]) =>
      (SettingsDefinitionsBodyBuilder()..update(updates))._build();

  _$SettingsDefinitionsBody._(
      {this.dollarSchema, required this.groups, required this.list})
      : super._();
  @override
  SettingsDefinitionsBody rebuild(
          void Function(SettingsDefinitionsBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SettingsDefinitionsBodyBuilder toBuilder() =>
      SettingsDefinitionsBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SettingsDefinitionsBody &&
        dollarSchema == other.dollarSchema &&
        groups == other.groups &&
        list == other.list;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, dollarSchema.hashCode);
    _$hash = $jc(_$hash, groups.hashCode);
    _$hash = $jc(_$hash, list.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SettingsDefinitionsBody')
          ..add('dollarSchema', dollarSchema)
          ..add('groups', groups)
          ..add('list', list))
        .toString();
  }
}

class SettingsDefinitionsBodyBuilder
    implements
        Builder<SettingsDefinitionsBody, SettingsDefinitionsBodyBuilder> {
  _$SettingsDefinitionsBody? _$v;

  String? _dollarSchema;
  String? get dollarSchema => _$this._dollarSchema;
  set dollarSchema(String? dollarSchema) => _$this._dollarSchema = dollarSchema;

  ListBuilder<SettingsGroup>? _groups;
  ListBuilder<SettingsGroup> get groups =>
      _$this._groups ??= ListBuilder<SettingsGroup>();
  set groups(ListBuilder<SettingsGroup>? groups) => _$this._groups = groups;

  ListBuilder<SettingsDefinition>? _list;
  ListBuilder<SettingsDefinition> get list =>
      _$this._list ??= ListBuilder<SettingsDefinition>();
  set list(ListBuilder<SettingsDefinition>? list) => _$this._list = list;

  SettingsDefinitionsBodyBuilder() {
    SettingsDefinitionsBody._defaults(this);
  }

  SettingsDefinitionsBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _dollarSchema = $v.dollarSchema;
      _groups = $v.groups.toBuilder();
      _list = $v.list.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SettingsDefinitionsBody other) {
    _$v = other as _$SettingsDefinitionsBody;
  }

  @override
  void update(void Function(SettingsDefinitionsBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SettingsDefinitionsBody build() => _build();

  _$SettingsDefinitionsBody _build() {
    _$SettingsDefinitionsBody _$result;
    try {
      _$result = _$v ??
          _$SettingsDefinitionsBody._(
            dollarSchema: dollarSchema,
            groups: groups.build(),
            list: list.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'groups';
        groups.build();
        _$failedField = 'list';
        list.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SettingsDefinitionsBody', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
