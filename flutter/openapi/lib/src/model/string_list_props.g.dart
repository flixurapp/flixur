// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'string_list_props.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StringListProps extends StringListProps {
  @override
  final bool? allowDuplicates;
  @override
  final BuiltList<ChoiceSpec>? choices;
  @override
  final BuiltList<String>? defaultValue;
  @override
  final int? maxItems;

  factory _$StringListProps([void Function(StringListPropsBuilder)? updates]) =>
      (StringListPropsBuilder()..update(updates))._build();

  _$StringListProps._(
      {this.allowDuplicates, this.choices, this.defaultValue, this.maxItems})
      : super._();
  @override
  StringListProps rebuild(void Function(StringListPropsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StringListPropsBuilder toBuilder() => StringListPropsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StringListProps &&
        allowDuplicates == other.allowDuplicates &&
        choices == other.choices &&
        defaultValue == other.defaultValue &&
        maxItems == other.maxItems;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, allowDuplicates.hashCode);
    _$hash = $jc(_$hash, choices.hashCode);
    _$hash = $jc(_$hash, defaultValue.hashCode);
    _$hash = $jc(_$hash, maxItems.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StringListProps')
          ..add('allowDuplicates', allowDuplicates)
          ..add('choices', choices)
          ..add('defaultValue', defaultValue)
          ..add('maxItems', maxItems))
        .toString();
  }
}

class StringListPropsBuilder
    implements Builder<StringListProps, StringListPropsBuilder> {
  _$StringListProps? _$v;

  bool? _allowDuplicates;
  bool? get allowDuplicates => _$this._allowDuplicates;
  set allowDuplicates(bool? allowDuplicates) =>
      _$this._allowDuplicates = allowDuplicates;

  ListBuilder<ChoiceSpec>? _choices;
  ListBuilder<ChoiceSpec> get choices =>
      _$this._choices ??= ListBuilder<ChoiceSpec>();
  set choices(ListBuilder<ChoiceSpec>? choices) => _$this._choices = choices;

  ListBuilder<String>? _defaultValue;
  ListBuilder<String> get defaultValue =>
      _$this._defaultValue ??= ListBuilder<String>();
  set defaultValue(ListBuilder<String>? defaultValue) =>
      _$this._defaultValue = defaultValue;

  int? _maxItems;
  int? get maxItems => _$this._maxItems;
  set maxItems(int? maxItems) => _$this._maxItems = maxItems;

  StringListPropsBuilder() {
    StringListProps._defaults(this);
  }

  StringListPropsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _allowDuplicates = $v.allowDuplicates;
      _choices = $v.choices?.toBuilder();
      _defaultValue = $v.defaultValue?.toBuilder();
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
            allowDuplicates: allowDuplicates,
            choices: _choices?.build(),
            defaultValue: _defaultValue?.build(),
            maxItems: maxItems,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'choices';
        _choices?.build();
        _$failedField = 'defaultValue';
        _defaultValue?.build();
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
