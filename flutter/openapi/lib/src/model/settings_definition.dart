//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/bool_props.dart';
import 'package:openapi/src/model/int_props.dart';
import 'package:openapi/src/model/enum_props.dart';
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/string_list_props.dart';
import 'package:openapi/src/model/float_props.dart';
import 'package:openapi/src/model/string_props.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'settings_definition.g.dart';

/// SettingsDefinition
///
/// Properties:
/// * [bool_]
/// * [enum_]
/// * [float]
/// * [id]
/// * [int_]
/// * [kind]
/// * [order]
/// * [string]
/// * [stringList]
@BuiltValue()
abstract class SettingsDefinition
    implements Built<SettingsDefinition, SettingsDefinitionBuilder> {
  @BuiltValueField(wireName: r'bool')
  BoolProps? get bool_;

  @BuiltValueField(wireName: r'enum')
  EnumProps? get enum_;

  @BuiltValueField(wireName: r'float')
  FloatProps? get float;

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'int')
  IntProps? get int_;

  @BuiltValueField(wireName: r'kind')
  SettingsDefinitionKindEnum get kind;
  // enum kindEnum {  bool,  int,  float,  string,  enum,  stringlist,  };

  @BuiltValueField(wireName: r'order')
  int get order;

  @BuiltValueField(wireName: r'string')
  StringProps? get string;

  @BuiltValueField(wireName: r'stringList')
  StringListProps? get stringList;

  SettingsDefinition._();

  factory SettingsDefinition([void updates(SettingsDefinitionBuilder b)]) =
      _$SettingsDefinition;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SettingsDefinitionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SettingsDefinition> get serializer =>
      _$SettingsDefinitionSerializer();
}

class _$SettingsDefinitionSerializer
    implements PrimitiveSerializer<SettingsDefinition> {
  @override
  final Iterable<Type> types = const [SettingsDefinition, _$SettingsDefinition];

  @override
  final String wireName = r'SettingsDefinition';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SettingsDefinition object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.bool_ != null) {
      yield r'bool';
      yield serializers.serialize(
        object.bool_,
        specifiedType: const FullType(BoolProps),
      );
    }
    if (object.enum_ != null) {
      yield r'enum';
      yield serializers.serialize(
        object.enum_,
        specifiedType: const FullType(EnumProps),
      );
    }
    if (object.float != null) {
      yield r'float';
      yield serializers.serialize(
        object.float,
        specifiedType: const FullType(FloatProps),
      );
    }
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    if (object.int_ != null) {
      yield r'int';
      yield serializers.serialize(
        object.int_,
        specifiedType: const FullType(IntProps),
      );
    }
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(SettingsDefinitionKindEnum),
    );
    yield r'order';
    yield serializers.serialize(
      object.order,
      specifiedType: const FullType(int),
    );
    if (object.string != null) {
      yield r'string';
      yield serializers.serialize(
        object.string,
        specifiedType: const FullType(StringProps),
      );
    }
    if (object.stringList != null) {
      yield r'stringList';
      yield serializers.serialize(
        object.stringList,
        specifiedType: const FullType(StringListProps),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SettingsDefinition object, {
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
    required SettingsDefinitionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'bool':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BoolProps),
          ) as BoolProps?;
          if (valueDes == null) continue;
          result.bool_.replace(valueDes);
          break;
        case r'enum':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(EnumProps),
          ) as EnumProps?;
          if (valueDes == null) continue;
          result.enum_.replace(valueDes);
          break;
        case r'float':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(FloatProps),
          ) as FloatProps?;
          if (valueDes == null) continue;
          result.float.replace(valueDes);
          break;
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'int':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(IntProps),
          ) as IntProps?;
          if (valueDes == null) continue;
          result.int_.replace(valueDes);
          break;
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SettingsDefinitionKindEnum),
          ) as SettingsDefinitionKindEnum;
          result.kind = valueDes;
          break;
        case r'order':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.order = valueDes;
          break;
        case r'string':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(StringProps),
          ) as StringProps?;
          if (valueDes == null) continue;
          result.string.replace(valueDes);
          break;
        case r'stringList':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(StringListProps),
          ) as StringListProps?;
          if (valueDes == null) continue;
          result.stringList.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SettingsDefinition deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SettingsDefinitionBuilder();
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

class SettingsDefinitionKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'bool')
  static const SettingsDefinitionKindEnum bool_ =
      _$settingsDefinitionKindEnum_bool_;
  @BuiltValueEnumConst(wireName: r'int')
  static const SettingsDefinitionKindEnum int_ =
      _$settingsDefinitionKindEnum_int_;
  @BuiltValueEnumConst(wireName: r'float')
  static const SettingsDefinitionKindEnum float =
      _$settingsDefinitionKindEnum_float;
  @BuiltValueEnumConst(wireName: r'string')
  static const SettingsDefinitionKindEnum string =
      _$settingsDefinitionKindEnum_string;
  @BuiltValueEnumConst(wireName: r'enum')
  static const SettingsDefinitionKindEnum enum_ =
      _$settingsDefinitionKindEnum_enum_;
  @BuiltValueEnumConst(wireName: r'stringlist')
  static const SettingsDefinitionKindEnum stringlist =
      _$settingsDefinitionKindEnum_stringlist;

  static Serializer<SettingsDefinitionKindEnum> get serializer =>
      _$settingsDefinitionKindEnumSerializer;

  const SettingsDefinitionKindEnum._(String name) : super(name);

  static BuiltSet<SettingsDefinitionKindEnum> get values =>
      _$settingsDefinitionKindEnumValues;
  static SettingsDefinitionKindEnum valueOf(String name) =>
      _$settingsDefinitionKindEnumValueOf(name);
}
