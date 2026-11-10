// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'int_props.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$IntProps extends IntProps {
  @override
  final int default_;
  @override
  final int? max;
  @override
  final int? min;
  @override
  final int? recommendedMax;
  @override
  final int? recommendedMin;
  @override
  final int? step;

  factory _$IntProps([void Function(IntPropsBuilder)? updates]) =>
      (IntPropsBuilder()..update(updates))._build();

  _$IntProps._(
      {required this.default_,
      this.max,
      this.min,
      this.recommendedMax,
      this.recommendedMin,
      this.step})
      : super._();
  @override
  IntProps rebuild(void Function(IntPropsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  IntPropsBuilder toBuilder() => IntPropsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is IntProps &&
        default_ == other.default_ &&
        max == other.max &&
        min == other.min &&
        recommendedMax == other.recommendedMax &&
        recommendedMin == other.recommendedMin &&
        step == other.step;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, default_.hashCode);
    _$hash = $jc(_$hash, max.hashCode);
    _$hash = $jc(_$hash, min.hashCode);
    _$hash = $jc(_$hash, recommendedMax.hashCode);
    _$hash = $jc(_$hash, recommendedMin.hashCode);
    _$hash = $jc(_$hash, step.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'IntProps')
          ..add('default_', default_)
          ..add('max', max)
          ..add('min', min)
          ..add('recommendedMax', recommendedMax)
          ..add('recommendedMin', recommendedMin)
          ..add('step', step))
        .toString();
  }
}

class IntPropsBuilder implements Builder<IntProps, IntPropsBuilder> {
  _$IntProps? _$v;

  int? _default_;
  int? get default_ => _$this._default_;
  set default_(int? default_) => _$this._default_ = default_;

  int? _max;
  int? get max => _$this._max;
  set max(int? max) => _$this._max = max;

  int? _min;
  int? get min => _$this._min;
  set min(int? min) => _$this._min = min;

  int? _recommendedMax;
  int? get recommendedMax => _$this._recommendedMax;
  set recommendedMax(int? recommendedMax) =>
      _$this._recommendedMax = recommendedMax;

  int? _recommendedMin;
  int? get recommendedMin => _$this._recommendedMin;
  set recommendedMin(int? recommendedMin) =>
      _$this._recommendedMin = recommendedMin;

  int? _step;
  int? get step => _$this._step;
  set step(int? step) => _$this._step = step;

  IntPropsBuilder() {
    IntProps._defaults(this);
  }

  IntPropsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _default_ = $v.default_;
      _max = $v.max;
      _min = $v.min;
      _recommendedMax = $v.recommendedMax;
      _recommendedMin = $v.recommendedMin;
      _step = $v.step;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(IntProps other) {
    _$v = other as _$IntProps;
  }

  @override
  void update(void Function(IntPropsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  IntProps build() => _build();

  _$IntProps _build() {
    final _$result = _$v ??
        _$IntProps._(
          default_: BuiltValueNullFieldError.checkNotNull(
              default_, r'IntProps', 'default_'),
          max: max,
          min: min,
          recommendedMax: recommendedMax,
          recommendedMin: recommendedMin,
          step: step,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
