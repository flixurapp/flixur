// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_definition.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SettingsDefinitionKindEnum _$settingsDefinitionKindEnum_bool_ =
    const SettingsDefinitionKindEnum._('bool_');
const SettingsDefinitionKindEnum _$settingsDefinitionKindEnum_int_ =
    const SettingsDefinitionKindEnum._('int_');
const SettingsDefinitionKindEnum _$settingsDefinitionKindEnum_float =
    const SettingsDefinitionKindEnum._('float');
const SettingsDefinitionKindEnum _$settingsDefinitionKindEnum_string =
    const SettingsDefinitionKindEnum._('string');
const SettingsDefinitionKindEnum _$settingsDefinitionKindEnum_enum_ =
    const SettingsDefinitionKindEnum._('enum_');
const SettingsDefinitionKindEnum _$settingsDefinitionKindEnum_stringlist =
    const SettingsDefinitionKindEnum._('stringlist');

SettingsDefinitionKindEnum _$settingsDefinitionKindEnumValueOf(String name) {
  switch (name) {
    case 'bool_':
      return _$settingsDefinitionKindEnum_bool_;
    case 'int_':
      return _$settingsDefinitionKindEnum_int_;
    case 'float':
      return _$settingsDefinitionKindEnum_float;
    case 'string':
      return _$settingsDefinitionKindEnum_string;
    case 'enum_':
      return _$settingsDefinitionKindEnum_enum_;
    case 'stringlist':
      return _$settingsDefinitionKindEnum_stringlist;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SettingsDefinitionKindEnum> _$settingsDefinitionKindEnumValues =
    BuiltSet<SettingsDefinitionKindEnum>(const <SettingsDefinitionKindEnum>[
  _$settingsDefinitionKindEnum_bool_,
  _$settingsDefinitionKindEnum_int_,
  _$settingsDefinitionKindEnum_float,
  _$settingsDefinitionKindEnum_string,
  _$settingsDefinitionKindEnum_enum_,
  _$settingsDefinitionKindEnum_stringlist,
]);

Serializer<SettingsDefinitionKindEnum> _$settingsDefinitionKindEnumSerializer =
    _$SettingsDefinitionKindEnumSerializer();

class _$SettingsDefinitionKindEnumSerializer
    implements PrimitiveSerializer<SettingsDefinitionKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'bool_': 'bool',
    'int_': 'int',
    'float': 'float',
    'string': 'string',
    'enum_': 'enum',
    'stringlist': 'stringlist',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'bool': 'bool_',
    'int': 'int_',
    'float': 'float',
    'string': 'string',
    'enum': 'enum_',
    'stringlist': 'stringlist',
  };

  @override
  final Iterable<Type> types = const <Type>[SettingsDefinitionKindEnum];
  @override
  final String wireName = 'SettingsDefinitionKindEnum';

  @override
  Object serialize(Serializers serializers, SettingsDefinitionKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SettingsDefinitionKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SettingsDefinitionKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$SettingsDefinition extends SettingsDefinition {
  @override
  final BoolProps? bool_;
  @override
  final EnumProps? enum_;
  @override
  final FloatProps? float;
  @override
  final String id;
  @override
  final IntProps? int_;
  @override
  final SettingsDefinitionKindEnum kind;
  @override
  final int order;
  @override
  final StringProps? string;
  @override
  final StringListProps? stringList;

  factory _$SettingsDefinition(
          [void Function(SettingsDefinitionBuilder)? updates]) =>
      (SettingsDefinitionBuilder()..update(updates))._build();

  _$SettingsDefinition._(
      {this.bool_,
      this.enum_,
      this.float,
      required this.id,
      this.int_,
      required this.kind,
      required this.order,
      this.string,
      this.stringList})
      : super._();
  @override
  SettingsDefinition rebuild(
          void Function(SettingsDefinitionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SettingsDefinitionBuilder toBuilder() =>
      SettingsDefinitionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SettingsDefinition &&
        bool_ == other.bool_ &&
        enum_ == other.enum_ &&
        float == other.float &&
        id == other.id &&
        int_ == other.int_ &&
        kind == other.kind &&
        order == other.order &&
        string == other.string &&
        stringList == other.stringList;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, bool_.hashCode);
    _$hash = $jc(_$hash, enum_.hashCode);
    _$hash = $jc(_$hash, float.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, int_.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, order.hashCode);
    _$hash = $jc(_$hash, string.hashCode);
    _$hash = $jc(_$hash, stringList.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SettingsDefinition')
          ..add('bool_', bool_)
          ..add('enum_', enum_)
          ..add('float', float)
          ..add('id', id)
          ..add('int_', int_)
          ..add('kind', kind)
          ..add('order', order)
          ..add('string', string)
          ..add('stringList', stringList))
        .toString();
  }
}

class SettingsDefinitionBuilder
    implements Builder<SettingsDefinition, SettingsDefinitionBuilder> {
  _$SettingsDefinition? _$v;

  BoolPropsBuilder? _bool_;
  BoolPropsBuilder get bool_ => _$this._bool_ ??= BoolPropsBuilder();
  set bool_(BoolPropsBuilder? bool_) => _$this._bool_ = bool_;

  EnumPropsBuilder? _enum_;
  EnumPropsBuilder get enum_ => _$this._enum_ ??= EnumPropsBuilder();
  set enum_(EnumPropsBuilder? enum_) => _$this._enum_ = enum_;

  FloatPropsBuilder? _float;
  FloatPropsBuilder get float => _$this._float ??= FloatPropsBuilder();
  set float(FloatPropsBuilder? float) => _$this._float = float;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  IntPropsBuilder? _int_;
  IntPropsBuilder get int_ => _$this._int_ ??= IntPropsBuilder();
  set int_(IntPropsBuilder? int_) => _$this._int_ = int_;

  SettingsDefinitionKindEnum? _kind;
  SettingsDefinitionKindEnum? get kind => _$this._kind;
  set kind(SettingsDefinitionKindEnum? kind) => _$this._kind = kind;

  int? _order;
  int? get order => _$this._order;
  set order(int? order) => _$this._order = order;

  StringPropsBuilder? _string;
  StringPropsBuilder get string => _$this._string ??= StringPropsBuilder();
  set string(StringPropsBuilder? string) => _$this._string = string;

  StringListPropsBuilder? _stringList;
  StringListPropsBuilder get stringList =>
      _$this._stringList ??= StringListPropsBuilder();
  set stringList(StringListPropsBuilder? stringList) =>
      _$this._stringList = stringList;

  SettingsDefinitionBuilder() {
    SettingsDefinition._defaults(this);
  }

  SettingsDefinitionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _bool_ = $v.bool_?.toBuilder();
      _enum_ = $v.enum_?.toBuilder();
      _float = $v.float?.toBuilder();
      _id = $v.id;
      _int_ = $v.int_?.toBuilder();
      _kind = $v.kind;
      _order = $v.order;
      _string = $v.string?.toBuilder();
      _stringList = $v.stringList?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SettingsDefinition other) {
    _$v = other as _$SettingsDefinition;
  }

  @override
  void update(void Function(SettingsDefinitionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SettingsDefinition build() => _build();

  _$SettingsDefinition _build() {
    _$SettingsDefinition _$result;
    try {
      _$result = _$v ??
          _$SettingsDefinition._(
            bool_: _bool_?.build(),
            enum_: _enum_?.build(),
            float: _float?.build(),
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'SettingsDefinition', 'id'),
            int_: _int_?.build(),
            kind: BuiltValueNullFieldError.checkNotNull(
                kind, r'SettingsDefinition', 'kind'),
            order: BuiltValueNullFieldError.checkNotNull(
                order, r'SettingsDefinition', 'order'),
            string: _string?.build(),
            stringList: _stringList?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'bool_';
        _bool_?.build();
        _$failedField = 'enum_';
        _enum_?.build();
        _$failedField = 'float';
        _float?.build();

        _$failedField = 'int_';
        _int_?.build();

        _$failedField = 'string';
        _string?.build();
        _$failedField = 'stringList';
        _stringList?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SettingsDefinition', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
