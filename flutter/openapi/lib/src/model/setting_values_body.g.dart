// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting_values_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SettingValuesBody extends SettingValuesBody {
  @override
  final String? dollarSchema;
  @override
  final BuiltMap<String, SettingValueEntry> values;

  factory _$SettingValuesBody(
          [void Function(SettingValuesBodyBuilder)? updates]) =>
      (SettingValuesBodyBuilder()..update(updates))._build();

  _$SettingValuesBody._({this.dollarSchema, required this.values}) : super._();
  @override
  SettingValuesBody rebuild(void Function(SettingValuesBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SettingValuesBodyBuilder toBuilder() =>
      SettingValuesBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SettingValuesBody &&
        dollarSchema == other.dollarSchema &&
        values == other.values;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, dollarSchema.hashCode);
    _$hash = $jc(_$hash, values.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SettingValuesBody')
          ..add('dollarSchema', dollarSchema)
          ..add('values', values))
        .toString();
  }
}

class SettingValuesBodyBuilder
    implements Builder<SettingValuesBody, SettingValuesBodyBuilder> {
  _$SettingValuesBody? _$v;

  String? _dollarSchema;
  String? get dollarSchema => _$this._dollarSchema;
  set dollarSchema(String? dollarSchema) => _$this._dollarSchema = dollarSchema;

  MapBuilder<String, SettingValueEntry>? _values;
  MapBuilder<String, SettingValueEntry> get values =>
      _$this._values ??= MapBuilder<String, SettingValueEntry>();
  set values(MapBuilder<String, SettingValueEntry>? values) =>
      _$this._values = values;

  SettingValuesBodyBuilder() {
    SettingValuesBody._defaults(this);
  }

  SettingValuesBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _dollarSchema = $v.dollarSchema;
      _values = $v.values.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SettingValuesBody other) {
    _$v = other as _$SettingValuesBody;
  }

  @override
  void update(void Function(SettingValuesBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SettingValuesBody build() => _build();

  _$SettingValuesBody _build() {
    _$SettingValuesBody _$result;
    try {
      _$result = _$v ??
          _$SettingValuesBody._(
            dollarSchema: dollarSchema,
            values: values.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'values';
        values.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SettingValuesBody', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
