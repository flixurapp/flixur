// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'float_props.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FloatProps extends FloatProps {
  @override
  final double default_;
  @override
  final double? max;
  @override
  final double? min;
  @override
  final double? recommendedMax;
  @override
  final double? recommendedMin;
  @override
  final double? step;

  factory _$FloatProps([void Function(FloatPropsBuilder)? updates]) =>
      (FloatPropsBuilder()..update(updates))._build();

  _$FloatProps._(
      {required this.default_,
      this.max,
      this.min,
      this.recommendedMax,
      this.recommendedMin,
      this.step})
      : super._();
  @override
  FloatProps rebuild(void Function(FloatPropsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FloatPropsBuilder toBuilder() => FloatPropsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FloatProps &&
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
    return (newBuiltValueToStringHelper(r'FloatProps')
          ..add('default_', default_)
          ..add('max', max)
          ..add('min', min)
          ..add('recommendedMax', recommendedMax)
          ..add('recommendedMin', recommendedMin)
          ..add('step', step))
        .toString();
  }
}

class FloatPropsBuilder implements Builder<FloatProps, FloatPropsBuilder> {
  _$FloatProps? _$v;

  double? _default_;
  double? get default_ => _$this._default_;
  set default_(double? default_) => _$this._default_ = default_;

  double? _max;
  double? get max => _$this._max;
  set max(double? max) => _$this._max = max;

  double? _min;
  double? get min => _$this._min;
  set min(double? min) => _$this._min = min;

  double? _recommendedMax;
  double? get recommendedMax => _$this._recommendedMax;
  set recommendedMax(double? recommendedMax) =>
      _$this._recommendedMax = recommendedMax;

  double? _recommendedMin;
  double? get recommendedMin => _$this._recommendedMin;
  set recommendedMin(double? recommendedMin) =>
      _$this._recommendedMin = recommendedMin;

  double? _step;
  double? get step => _$this._step;
  set step(double? step) => _$this._step = step;

  FloatPropsBuilder() {
    FloatProps._defaults(this);
  }

  FloatPropsBuilder get _$this {
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
  void replace(FloatProps other) {
    _$v = other as _$FloatProps;
  }

  @override
  void update(void Function(FloatPropsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FloatProps build() => _build();

  _$FloatProps _build() {
    final _$result = _$v ??
        _$FloatProps._(
          default_: BuiltValueNullFieldError.checkNotNull(
              default_, r'FloatProps', 'default_'),
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
