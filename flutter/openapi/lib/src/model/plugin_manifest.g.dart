// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plugin_manifest.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PluginManifestFeaturesEnum _$pluginManifestFeaturesEnum_MUSIC_METADATA =
    const PluginManifestFeaturesEnum._('MUSIC_METADATA');

PluginManifestFeaturesEnum _$pluginManifestFeaturesEnumValueOf(String name) {
  switch (name) {
    case 'MUSIC_METADATA':
      return _$pluginManifestFeaturesEnum_MUSIC_METADATA;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PluginManifestFeaturesEnum> _$pluginManifestFeaturesEnumValues =
    BuiltSet<PluginManifestFeaturesEnum>(const <PluginManifestFeaturesEnum>[
  _$pluginManifestFeaturesEnum_MUSIC_METADATA,
]);

Serializer<PluginManifestFeaturesEnum> _$pluginManifestFeaturesEnumSerializer =
    _$PluginManifestFeaturesEnumSerializer();

class _$PluginManifestFeaturesEnumSerializer
    implements PrimitiveSerializer<PluginManifestFeaturesEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'MUSIC_METADATA': 'MUSIC_METADATA',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'MUSIC_METADATA': 'MUSIC_METADATA',
  };

  @override
  final Iterable<Type> types = const <Type>[PluginManifestFeaturesEnum];
  @override
  final String wireName = 'PluginManifestFeaturesEnum';

  @override
  Object serialize(Serializers serializers, PluginManifestFeaturesEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PluginManifestFeaturesEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PluginManifestFeaturesEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PluginManifest extends PluginManifest {
  @override
  final String author;
  @override
  final String? bin;
  @override
  final BuiltList<String>? dependencies;
  @override
  final String description;
  @override
  final BuiltList<PluginManifestFeaturesEnum>? features;
  @override
  final String icon;
  @override
  final String id;
  @override
  final String name;
  @override
  final String url;
  @override
  final String version;

  factory _$PluginManifest([void Function(PluginManifestBuilder)? updates]) =>
      (PluginManifestBuilder()..update(updates))._build();

  _$PluginManifest._(
      {required this.author,
      this.bin,
      this.dependencies,
      required this.description,
      this.features,
      required this.icon,
      required this.id,
      required this.name,
      required this.url,
      required this.version})
      : super._();
  @override
  PluginManifest rebuild(void Function(PluginManifestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PluginManifestBuilder toBuilder() => PluginManifestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PluginManifest &&
        author == other.author &&
        bin == other.bin &&
        dependencies == other.dependencies &&
        description == other.description &&
        features == other.features &&
        icon == other.icon &&
        id == other.id &&
        name == other.name &&
        url == other.url &&
        version == other.version;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, author.hashCode);
    _$hash = $jc(_$hash, bin.hashCode);
    _$hash = $jc(_$hash, dependencies.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, features.hashCode);
    _$hash = $jc(_$hash, icon.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PluginManifest')
          ..add('author', author)
          ..add('bin', bin)
          ..add('dependencies', dependencies)
          ..add('description', description)
          ..add('features', features)
          ..add('icon', icon)
          ..add('id', id)
          ..add('name', name)
          ..add('url', url)
          ..add('version', version))
        .toString();
  }
}

class PluginManifestBuilder
    implements Builder<PluginManifest, PluginManifestBuilder> {
  _$PluginManifest? _$v;

  String? _author;
  String? get author => _$this._author;
  set author(String? author) => _$this._author = author;

  String? _bin;
  String? get bin => _$this._bin;
  set bin(String? bin) => _$this._bin = bin;

  ListBuilder<String>? _dependencies;
  ListBuilder<String> get dependencies =>
      _$this._dependencies ??= ListBuilder<String>();
  set dependencies(ListBuilder<String>? dependencies) =>
      _$this._dependencies = dependencies;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  ListBuilder<PluginManifestFeaturesEnum>? _features;
  ListBuilder<PluginManifestFeaturesEnum> get features =>
      _$this._features ??= ListBuilder<PluginManifestFeaturesEnum>();
  set features(ListBuilder<PluginManifestFeaturesEnum>? features) =>
      _$this._features = features;

  String? _icon;
  String? get icon => _$this._icon;
  set icon(String? icon) => _$this._icon = icon;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  String? _version;
  String? get version => _$this._version;
  set version(String? version) => _$this._version = version;

  PluginManifestBuilder() {
    PluginManifest._defaults(this);
  }

  PluginManifestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _author = $v.author;
      _bin = $v.bin;
      _dependencies = $v.dependencies?.toBuilder();
      _description = $v.description;
      _features = $v.features?.toBuilder();
      _icon = $v.icon;
      _id = $v.id;
      _name = $v.name;
      _url = $v.url;
      _version = $v.version;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PluginManifest other) {
    _$v = other as _$PluginManifest;
  }

  @override
  void update(void Function(PluginManifestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PluginManifest build() => _build();

  _$PluginManifest _build() {
    _$PluginManifest _$result;
    try {
      _$result = _$v ??
          _$PluginManifest._(
            author: BuiltValueNullFieldError.checkNotNull(
                author, r'PluginManifest', 'author'),
            bin: bin,
            dependencies: _dependencies?.build(),
            description: BuiltValueNullFieldError.checkNotNull(
                description, r'PluginManifest', 'description'),
            features: _features?.build(),
            icon: BuiltValueNullFieldError.checkNotNull(
                icon, r'PluginManifest', 'icon'),
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'PluginManifest', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'PluginManifest', 'name'),
            url: BuiltValueNullFieldError.checkNotNull(
                url, r'PluginManifest', 'url'),
            version: BuiltValueNullFieldError.checkNotNull(
                version, r'PluginManifest', 'version'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'dependencies';
        _dependencies?.build();

        _$failedField = 'features';
        _features?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PluginManifest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
