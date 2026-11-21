// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plugins_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PluginsBody extends PluginsBody {
  @override
  final String? dollarSchema;
  @override
  final BuiltList<PluginManifest> list;

  factory _$PluginsBody([void Function(PluginsBodyBuilder)? updates]) =>
      (PluginsBodyBuilder()..update(updates))._build();

  _$PluginsBody._({this.dollarSchema, required this.list}) : super._();
  @override
  PluginsBody rebuild(void Function(PluginsBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PluginsBodyBuilder toBuilder() => PluginsBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PluginsBody &&
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
    return (newBuiltValueToStringHelper(r'PluginsBody')
          ..add('dollarSchema', dollarSchema)
          ..add('list', list))
        .toString();
  }
}

class PluginsBodyBuilder implements Builder<PluginsBody, PluginsBodyBuilder> {
  _$PluginsBody? _$v;

  String? _dollarSchema;
  String? get dollarSchema => _$this._dollarSchema;
  set dollarSchema(String? dollarSchema) => _$this._dollarSchema = dollarSchema;

  ListBuilder<PluginManifest>? _list;
  ListBuilder<PluginManifest> get list =>
      _$this._list ??= ListBuilder<PluginManifest>();
  set list(ListBuilder<PluginManifest>? list) => _$this._list = list;

  PluginsBodyBuilder() {
    PluginsBody._defaults(this);
  }

  PluginsBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _dollarSchema = $v.dollarSchema;
      _list = $v.list.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PluginsBody other) {
    _$v = other as _$PluginsBody;
  }

  @override
  void update(void Function(PluginsBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PluginsBody build() => _build();

  _$PluginsBody _build() {
    _$PluginsBody _$result;
    try {
      _$result = _$v ??
          _$PluginsBody._(
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
            r'PluginsBody', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
