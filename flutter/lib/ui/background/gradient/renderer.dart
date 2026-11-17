import "dart:ui" as ui;

import "package:flixur/settings.dart";
import "package:flixur/utils.dart";
import "package:flutter/foundation.dart" show listEquals;
import "package:material_ui/material_ui.dart";

/// Sigma to blur the background by.
const blurDistance = 4.0;

/// Alpha stepped down for every index.
/// first item = 1 / last = 0
double _stepAlpha(int index, int count) => (1 - index / count).clamp(0, 1);

/// Gradient background renderer.
class const GradientRenderer({required final List<Color> colors, super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final viewport = constraints.biggest;
        final painter = ImageFiltered(
          imageFilter: ui.ImageFilter.blur(
            sigmaX: blurDistance,
            sigmaY: blurDistance,
          ),
          child: CustomPaint(
            size: .infinite,
            painter: _GradientPainter(
              colors: colors,
              base: HSLColor.fromColor(context.colors.base)
                  // lock saturation so theme changes dont mess with the image
                  .withSaturation(0.05)
                  .withLightness(
                    Settings.getValue<double>("ui.background.brightness"),
                  )
                  .toColor(),
            ),
          ),
        );

        // fallback for infinite viewport constraint
        if (!viewport.isFinite) return SizedBox.expand(child: painter);

        // we have to paint the color bigger than the screen to offset
        // the blur edges being transparent
        final oversize =
            viewport + const Offset(blurDistance * 3, blurDistance * 3);
        return SizedBox.expand(
          child: ClipRect(
            child: OverflowBox(
              minWidth: oversize.width,
              maxWidth: oversize.width,
              minHeight: oversize.height,
              maxHeight: oversize.height,
              child: SizedBox(
                width: oversize.width,
                height: oversize.height,
                child: painter,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GradientPainter({
  required final List<Color> colors,
  required final Color base,
}) extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // dark base layer
    canvas.drawRect(rect, Paint()..color = base);

    final count = colors.length;
    if (count < 2) return;

    // mimics how the web version did the gradients
    // diagonal bands fading out across the screen
    final pairs = count ~/ 2;
    for (var i = 0; i < pairs; i++) {
      final begin = i.isEven ? Alignment.topLeft : Alignment.topRight;
      final end = i.isEven ? Alignment.bottomRight : Alignment.bottomLeft;
      canvas.drawRect(
        rect,
        Paint()
          ..blendMode = .overlay
          ..shader = ui.Gradient.linear(
            begin.withinRect(rect),
            end.withinRect(rect),
            [
              colors[i].withValues(alpha: _stepAlpha(i, count)),
              colors[i + pairs].withValues(alpha: _stepAlpha(i + pairs, count)),
            ],
          ),
      );
    }

    // failover for odd color count
    // saturates it a bit more with the last color again
    if (count.isOdd) {
      canvas.drawRect(
        rect,
        Paint()
          ..blendMode = .overlay
          ..color = colors.last.withValues(alpha: _stepAlpha(count - 1, count)),
      );
    }
  }

  @override
  bool shouldRepaint(_GradientPainter oldDelegate) =>
      !listEquals(oldDelegate.colors, colors) || oldDelegate.base != base;
}
