// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting_value_entry.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SettingValueEntry extends SettingValueEntry {
  @override
  final String? dollarSchema;
  @override
  final DateTime updatedAt;
  @override
  final String value;

  factory _$SettingValueEntry(
          [void Function(SettingValueEntryBuilder)? updates]) =>
      (SettingValueEntryBuilder()..update(updates))._build();

  _$SettingValueEntry._(
      {this.dollarSchema, required this.updatedAt, required this.value})
      : super._();
  @override
  SettingValueEntry rebuild(void Function(SettingValueEntryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SettingValueEntryBuilder toBuilder() =>
      SettingValueEntryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SettingValueEntry &&
        dollarSchema == other.dollarSchema &&
        updatedAt == other.updatedAt &&
        value == other.value;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, dollarSchema.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SettingValueEntry')
          ..add('dollarSchema', dollarSchema)
          ..add('updatedAt', updatedAt)
          ..add('value', value))
        .toString();
  }
}

class SettingValueEntryBuilder
    implements Builder<SettingValueEntry, SettingValueEntryBuilder> {
  _$SettingValueEntry? _$v;

  String? _dollarSchema;
  String? get dollarSchema => _$this._dollarSchema;
  set dollarSchema(String? dollarSchema) => _$this._dollarSchema = dollarSchema;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  String? _value;
  String? get value => _$this._value;
  set value(String? value) => _$this._value = value;

  SettingValueEntryBuilder() {
    SettingValueEntry._defaults(this);
  }

  SettingValueEntryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _dollarSchema = $v.dollarSchema;
      _updatedAt = $v.updatedAt;
      _value = $v.value;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SettingValueEntry other) {
    _$v = other as _$SettingValueEntry;
  }

  @override
  void update(void Function(SettingValueEntryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SettingValueEntry build() => _build();

  _$SettingValueEntry _build() {
    final _$result = _$v ??
        _$SettingValueEntry._(
          dollarSchema: dollarSchema,
          updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt, r'SettingValueEntry', 'updatedAt'),
          value: BuiltValueNullFieldError.checkNotNull(
              value, r'SettingValueEntry', 'value'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
