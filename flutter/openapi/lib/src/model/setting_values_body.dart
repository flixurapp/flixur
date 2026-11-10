//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/setting_value_entry.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'setting_values_body.g.dart';

/// SettingValuesBody
///
/// Properties:
/// * [dollarSchema] - A URL to the JSON Schema for this object.
/// * [values]
@BuiltValue()
abstract class SettingValuesBody
    implements Built<SettingValuesBody, SettingValuesBodyBuilder> {
  /// A URL to the JSON Schema for this object.
  @BuiltValueField(wireName: r'$schema')
  String? get dollarSchema;

  @BuiltValueField(wireName: r'values')
  BuiltMap<String, SettingValueEntry> get values;

  SettingValuesBody._();

  factory SettingValuesBody([void updates(SettingValuesBodyBuilder b)]) =
      _$SettingValuesBody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SettingValuesBodyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SettingValuesBody> get serializer =>
      _$SettingValuesBodySerializer();
}

class _$SettingValuesBodySerializer
    implements PrimitiveSerializer<SettingValuesBody> {
  @override
  final Iterable<Type> types = const [SettingValuesBody, _$SettingValuesBody];

  @override
  final String wireName = r'SettingValuesBody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SettingValuesBody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.dollarSchema != null) {
      yield r'$schema';
      yield serializers.serialize(
        object.dollarSchema,
        specifiedType: const FullType(String),
      );
    }
    yield r'values';
    yield serializers.serialize(
      object.values,
      specifiedType: const FullType(
          BuiltMap, [FullType(String), FullType(SettingValueEntry)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SettingValuesBody object, {
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
    required SettingValuesBodyBuilder result,
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
        case r'values':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltMap, [FullType(String), FullType(SettingValueEntry)]),
          ) as BuiltMap<String, SettingValueEntry>;
          result.values.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SettingValuesBody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SettingValuesBodyBuilder();
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
