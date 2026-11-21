//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/plugin_manifest.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'plugins_body.g.dart';

/// PluginsBody
///
/// Properties:
/// * [dollarSchema] - A URL to the JSON Schema for this object.
/// * [list]
@BuiltValue()
abstract class PluginsBody implements Built<PluginsBody, PluginsBodyBuilder> {
  /// A URL to the JSON Schema for this object.
  @BuiltValueField(wireName: r'$schema')
  String? get dollarSchema;

  @BuiltValueField(wireName: r'list')
  BuiltList<PluginManifest> get list;

  PluginsBody._();

  factory PluginsBody([void updates(PluginsBodyBuilder b)]) = _$PluginsBody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PluginsBodyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PluginsBody> get serializer => _$PluginsBodySerializer();
}

class _$PluginsBodySerializer implements PrimitiveSerializer<PluginsBody> {
  @override
  final Iterable<Type> types = const [PluginsBody, _$PluginsBody];

  @override
  final String wireName = r'PluginsBody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PluginsBody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.dollarSchema != null) {
      yield r'$schema';
      yield serializers.serialize(
        object.dollarSchema,
        specifiedType: const FullType(String),
      );
    }
    yield r'list';
    yield serializers.serialize(
      object.list,
      specifiedType: const FullType(BuiltList, [FullType(PluginManifest)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PluginsBody object, {
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
    required PluginsBodyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'$schema':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.dollarSchema = valueDes;
          break;
        case r'list':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BuiltList, [FullType(PluginManifest)]),
          ) as BuiltList<PluginManifest>;
          result.list.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PluginsBody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PluginsBodyBuilder();
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
