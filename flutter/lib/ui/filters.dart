import "dart:ui" show lerpDouble;

import "package:flutter/rendering.dart";
import "package:material_ui/material_ui.dart";

/// Render proxy that darkens its child.
/// When [progress] is zero, no filter is pushed at all.
class const Darken({
  /// Darkening animation progress from 0 (nothing) to 1 (complete).
  required final double progress,

  /// Darkness scale applied to the child when [progress] is complete.
  required final double amount,
  required super.child,
  super.key,
}) extends SingleChildRenderObjectWidget {
  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderDarken(progress, amount);

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    (renderObject as _RenderDarken)
      ..progress = progress
      ..amount = amount;
  }
}

class _RenderDarken(var double _progress, var double _amount)
    extends RenderProxyBox {
  double get progress => _progress;
  set progress(double value) {
    if (_progress == value) return;
    _progress = value;
    markNeedsPaint();
  }

  double get amount => _amount;
  set amount(double value) {
    if (_amount == value) return;
    _amount = value;
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // ignore filter if no progress
    if (progress <= 0) {
      context.paintChild(child!, offset);
      return;
    }

    // darken the color by the value
    final value = lerpDouble(1, amount, progress)!;
    context.pushColorFilter(
      offset,
      // dart format off
      ColorFilter.matrix([
        value, 0, 0, 0, 0,
        0, value, 0, 0, 0,
        0, 0, value, 0, 0,
        0, 0, 0, 1, 0,
      ]),
      // dart format on
      super.paint,
    );
  }
}
