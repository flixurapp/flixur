//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'settings_group.g.dart';

/// SettingsGroup
///
/// Properties:
/// * [icon]
/// * [id]
/// * [order]
@BuiltValue()
abstract class SettingsGroup
    implements Built<SettingsGroup, SettingsGroupBuilder> {
  @BuiltValueField(wireName: r'icon')
  String? get icon;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'order')
  int get order;

  SettingsGroup._();

  factory SettingsGroup([void updates(SettingsGroupBuilder b)]) =
      _$SettingsGroup;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SettingsGroupBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SettingsGroup> get serializer =>
      _$SettingsGroupSerializer();
}

class _$SettingsGroupSerializer implements PrimitiveSerializer<SettingsGroup> {
  @override
  final Iterable<Type> types = const [SettingsGroup, _$SettingsGroup];

  @override
  final String wireName = r'SettingsGroup';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SettingsGroup object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.icon != null) {
      yield r'icon';
      yield serializers.serialize(
        object.icon,
        specifiedType: const FullType(String),
      );
    }
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'order';
    yield serializers.serialize(
      object.order,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SettingsGroup object, {
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
    required SettingsGroupBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'icon':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.icon = valueDes;
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'order':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.order = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SettingsGroup deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SettingsGroupBuilder();
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
