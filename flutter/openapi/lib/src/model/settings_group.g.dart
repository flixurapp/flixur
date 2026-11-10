// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_group.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SettingsGroup extends SettingsGroup {
  @override
  final String? icon;
  @override
  final String id;
  @override
  final int order;

  factory _$SettingsGroup([void Function(SettingsGroupBuilder)? updates]) =>
      (SettingsGroupBuilder()..update(updates))._build();

  _$SettingsGroup._({this.icon, required this.id, required this.order})
      : super._();
  @override
  SettingsGroup rebuild(void Function(SettingsGroupBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SettingsGroupBuilder toBuilder() => SettingsGroupBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SettingsGroup &&
        icon == other.icon &&
        id == other.id &&
        order == other.order;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, icon.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, order.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SettingsGroup')
          ..add('icon', icon)
          ..add('id', id)
          ..add('order', order))
        .toString();
  }
}

class SettingsGroupBuilder
    implements Builder<SettingsGroup, SettingsGroupBuilder> {
  _$SettingsGroup? _$v;

  String? _icon;
  String? get icon => _$this._icon;
  set icon(String? icon) => _$this._icon = icon;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  int? _order;
  int? get order => _$this._order;
  set order(int? order) => _$this._order = order;

  SettingsGroupBuilder() {
    SettingsGroup._defaults(this);
  }

  SettingsGroupBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _icon = $v.icon;
      _id = $v.id;
      _order = $v.order;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SettingsGroup other) {
    _$v = other as _$SettingsGroup;
  }

  @override
  void update(void Function(SettingsGroupBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SettingsGroup build() => _build();

  _$SettingsGroup _build() {
    final _$result = _$v ??
        _$SettingsGroup._(
          icon: icon,
          id: BuiltValueNullFieldError.checkNotNull(id, r'SettingsGroup', 'id'),
          order: BuiltValueNullFieldError.checkNotNull(
              order, r'SettingsGroup', 'order'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
