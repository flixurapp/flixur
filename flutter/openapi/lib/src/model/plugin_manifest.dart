//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'plugin_manifest.g.dart';

/// PluginManifest
///
/// Properties:
/// * [author]
/// * [bin]
/// * [color]
/// * [dependencies]
/// * [description]
/// * [features]
/// * [icon]
/// * [id]
/// * [name]
/// * [url]
/// * [version]
@BuiltValue()
abstract class PluginManifest
    implements Built<PluginManifest, PluginManifestBuilder> {
  @BuiltValueField(wireName: r'author')
  String get author;

  @BuiltValueField(wireName: r'bin')
  String? get bin;

  @BuiltValueField(wireName: r'color')
  String get color;

  @BuiltValueField(wireName: r'dependencies')
  BuiltList<String>? get dependencies;

  @BuiltValueField(wireName: r'description')
  String get description;

  @BuiltValueField(wireName: r'features')
  BuiltList<PluginManifestFeaturesEnum>? get features;
  // enum featuresEnum {  MUSIC_METADATA,  ARTIST_COVERS,  ALBUM_COVERS,  };

  @BuiltValueField(wireName: r'icon')
  String get icon;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'url')
  String get url;

  @BuiltValueField(wireName: r'version')
  String get version;

  PluginManifest._();

  factory PluginManifest([void updates(PluginManifestBuilder b)]) =
      _$PluginManifest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PluginManifestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PluginManifest> get serializer =>
      _$PluginManifestSerializer();
}

class _$PluginManifestSerializer
    implements PrimitiveSerializer<PluginManifest> {
  @override
  final Iterable<Type> types = const [PluginManifest, _$PluginManifest];

  @override
  final String wireName = r'PluginManifest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PluginManifest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'author';
    yield serializers.serialize(
      object.author,
      specifiedType: const FullType(String),
    );
    if (object.bin != null) {
      yield r'bin';
      yield serializers.serialize(
        object.bin,
        specifiedType: const FullType(String),
      );
    }
    yield r'color';
    yield serializers.serialize(
      object.color,
      specifiedType: const FullType(String),
    );
    if (object.dependencies != null) {
      yield r'dependencies';
      yield serializers.serialize(
        object.dependencies,
        specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
      );
    }
    yield r'description';
    yield serializers.serialize(
      object.description,
      specifiedType: const FullType(String),
    );
    yield r'features';
    yield object.features == null
        ? null
        : serializers.serialize(
            object.features,
            specifiedType: const FullType.nullable(
                BuiltList, [FullType(PluginManifestFeaturesEnum)]),
          );
    yield r'icon';
    yield serializers.serialize(
      object.icon,
      specifiedType: const FullType(String),
    );
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'url';
    yield serializers.serialize(
      object.url,
      specifiedType: const FullType(String),
    );
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PluginManifest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PluginManifestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'author':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.author = valueDes;
          break;
        case r'bin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.bin = valueDes;
          break;
        case r'color':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.color = valueDes;
          break;
        case r'dependencies':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.dependencies.replace(valueDes);
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.description = valueDes;
          break;
        case r'features':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(
                BuiltList, [FullType(PluginManifestFeaturesEnum)]),
          ) as BuiltList<PluginManifestFeaturesEnum>?;
          if (valueDes == null) continue;
          result.features.replace(valueDes);
          break;
        case r'icon':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.icon = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.url = valueDes;
          break;
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.version = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PluginManifest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PluginManifestBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

class PluginManifestFeaturesEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'MUSIC_METADATA')
  static const PluginManifestFeaturesEnum MUSIC_METADATA =
      _$pluginManifestFeaturesEnum_MUSIC_METADATA;
  @BuiltValueEnumConst(wireName: r'ARTIST_COVERS')
  static const PluginManifestFeaturesEnum ARTIST_COVERS =
      _$pluginManifestFeaturesEnum_ARTIST_COVERS;
  @BuiltValueEnumConst(wireName: r'ALBUM_COVERS')
  static const PluginManifestFeaturesEnum ALBUM_COVERS =
      _$pluginManifestFeaturesEnum_ALBUM_COVERS;

  static Serializer<PluginManifestFeaturesEnum> get serializer =>
      _$pluginManifestFeaturesEnumSerializer;

  const PluginManifestFeaturesEnum._(String name) : super(name);

  static BuiltSet<PluginManifestFeaturesEnum> get values =>
      _$pluginManifestFeaturesEnumValues;
  static PluginManifestFeaturesEnum valueOf(String name) =>
      _$pluginManifestFeaturesEnumValueOf(name);
}
