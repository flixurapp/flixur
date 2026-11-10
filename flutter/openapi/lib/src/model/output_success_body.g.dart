// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'output_success_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OutputSuccessBody extends OutputSuccessBody {
  @override
  final String? dollarSchema;
  @override
  final bool success;

  factory _$OutputSuccessBody(
          [void Function(OutputSuccessBodyBuilder)? updates]) =>
      (OutputSuccessBodyBuilder()..update(updates))._build();

  _$OutputSuccessBody._({this.dollarSchema, required this.success}) : super._();
  @override
  OutputSuccessBody rebuild(void Function(OutputSuccessBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OutputSuccessBodyBuilder toBuilder() =>
      OutputSuccessBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OutputSuccessBody &&
        dollarSchema == other.dollarSchema &&
        success == other.success;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, dollarSchema.hashCode);
    _$hash = $jc(_$hash, success.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OutputSuccessBody')
          ..add('dollarSchema', dollarSchema)
          ..add('success', success))
        .toString();
  }
}

class OutputSuccessBodyBuilder
    implements Builder<OutputSuccessBody, OutputSuccessBodyBuilder> {
  _$OutputSuccessBody? _$v;

  String? _dollarSchema;
  String? get dollarSchema => _$this._dollarSchema;
  set dollarSchema(String? dollarSchema) => _$this._dollarSchema = dollarSchema;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  OutputSuccessBodyBuilder() {
    OutputSuccessBody._defaults(this);
  }

  OutputSuccessBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _dollarSchema = $v.dollarSchema;
      _success = $v.success;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OutputSuccessBody other) {
    _$v = other as _$OutputSuccessBody;
  }

  @override
  void update(void Function(OutputSuccessBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OutputSuccessBody build() => _build();

  _$OutputSuccessBody _build() {
    final _$result = _$v ??
        _$OutputSuccessBody._(
          dollarSchema: dollarSchema,
          success: BuiltValueNullFieldError.checkNotNull(
              success, r'OutputSuccessBody', 'success'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
