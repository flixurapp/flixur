// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'string_list_props.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StringListProps extends StringListProps {
  @override
  final BuiltList<ChoiceSpec>? choices;
  @override
  final BuiltList<String>? default_;
  @override
  final int? maxItems;

  factory _$StringListProps([void Function(StringListPropsBuilder)? updates]) =>
      (StringListPropsBuilder()..update(updates))._build();

  _$StringListProps._({this.choices, this.default_, this.maxItems}) : super._();
  @override
  StringListProps rebuild(void Function(StringListPropsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StringListPropsBuilder toBuilder() => StringListPropsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StringListProps &&
        choices == other.choices &&
        default_ == other.default_ &&
        maxItems == other.maxItems;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, choices.hashCode);
    _$hash = $jc(_$hash, default_.hashCode);
    _$hash = $jc(_$hash, maxItems.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StringListProps')
          ..add('choices', choices)
          ..add('default_', default_)
          ..add('maxItems', maxItems))
        .toString();
  }
}

class StringListPropsBuilder
    implements Builder<StringListProps, StringListPropsBuilder> {
  _$StringListProps? _$v;

  ListBuilder<ChoiceSpec>? _choices;
  ListBuilder<ChoiceSpec> get choices =>
      _$this._choices ??= ListBuilder<ChoiceSpec>();
  set choices(ListBuilder<ChoiceSpec>? choices) => _$this._choices = choices;

  ListBuilder<String>? _default_;
  ListBuilder<String> get default_ =>
      _$this._default_ ??= ListBuilder<String>();
  set default_(ListBuilder<String>? default_) => _$this._default_ = default_;

  int? _maxItems;
  int? get maxItems => _$this._maxItems;
  set maxItems(int? maxItems) => _$this._maxItems = maxItems;

  StringListPropsBuilder() {
    StringListProps._defaults(this);
  }

  StringListPropsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _choices = $v.choices?.toBuilder();
      _default_ = $v.default_?.toBuilder();
      _maxItems = $v.maxItems;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StringListProps other) {
    _$v = other as _$StringListProps;
  }

  @override
  void update(void Function(StringListPropsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StringListProps build() => _build();

  _$StringListProps _build() {
    _$StringListProps _$result;
    try {
      _$result = _$v ??
          _$StringListProps._(
            choices: _choices?.build(),
            default_: _default_?.build(),
            maxItems: maxItems,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'choices';
        _choices?.build();
        _$failedField = 'default_';
        _default_?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'StringListProps', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
