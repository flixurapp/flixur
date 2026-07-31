// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ErrorModel extends ErrorModel {
  @override
  final String? dollarSchema;
  @override
  final String? detail;
  @override
  final BuiltList<ErrorDetail>? errors;
  @override
  final String? instance;
  @override
  final int? status;
  @override
  final String? title;
  @override
  final String? type;

  factory _$ErrorModel([void Function(ErrorModelBuilder)? updates]) =>
      (ErrorModelBuilder()..update(updates))._build();

  _$ErrorModel._(
      {this.dollarSchema,
      this.detail,
      this.errors,
      this.instance,
      this.status,
      this.title,
      this.type})
      : super._();
  @override
  ErrorModel rebuild(void Function(ErrorModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ErrorModelBuilder toBuilder() => ErrorModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ErrorModel &&
        dollarSchema == other.dollarSchema &&
        detail == other.detail &&
        errors == other.errors &&
        instance == other.instance &&
        status == other.status &&
        title == other.title &&
        type == other.type;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, dollarSchema.hashCode);
    _$hash = $jc(_$hash, detail.hashCode);
    _$hash = $jc(_$hash, errors.hashCode);
    _$hash = $jc(_$hash, instance.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ErrorModel')
          ..add('dollarSchema', dollarSchema)
          ..add('detail', detail)
          ..add('errors', errors)
          ..add('instance', instance)
          ..add('status', status)
          ..add('title', title)
          ..add('type', type))
        .toString();
  }
}

class ErrorModelBuilder implements Builder<ErrorModel, ErrorModelBuilder> {
  _$ErrorModel? _$v;

  String? _dollarSchema;
  String? get dollarSchema => _$this._dollarSchema;
  set dollarSchema(String? dollarSchema) => _$this._dollarSchema = dollarSchema;

  String? _detail;
  String? get detail => _$this._detail;
  set detail(String? detail) => _$this._detail = detail;

  ListBuilder<ErrorDetail>? _errors;
  ListBuilder<ErrorDetail> get errors =>
      _$this._errors ??= ListBuilder<ErrorDetail>();
  set errors(ListBuilder<ErrorDetail>? errors) => _$this._errors = errors;

  String? _instance;
  String? get instance => _$this._instance;
  set instance(String? instance) => _$this._instance = instance;

  int? _status;
  int? get status => _$this._status;
  set status(int? status) => _$this._status = status;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  ErrorModelBuilder() {
    ErrorModel._defaults(this);
  }

  ErrorModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _dollarSchema = $v.dollarSchema;
      _detail = $v.detail;
      _errors = $v.errors?.toBuilder();
      _instance = $v.instance;
      _status = $v.status;
      _title = $v.title;
      _type = $v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ErrorModel other) {
    _$v = other as _$ErrorModel;
  }

  @override
  void update(void Function(ErrorModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ErrorModel build() => _build();

  _$ErrorModel _build() {
    _$ErrorModel _$result;
    try {
      _$result = _$v ??
          _$ErrorModel._(
            dollarSchema: dollarSchema,
            detail: detail,
            errors: _errors?.build(),
            instance: instance,
            status: status,
            title: title,
            type: type,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'errors';
        _errors?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ErrorModel', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
