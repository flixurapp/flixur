import "dart:math";

import "package:flixur/ui/cards/common.dart";
import "package:material_ui/material_ui.dart";

/// How much smaller each layer gets as they go back.
const _sizeStepRatio = 4.0;

/// Vertical gap between the two layers, shrinks by 1 with each layer.
const _spreadRatio = 5.0;

/// Size of the punch-out between layers.
const _punchRatio = 1;

class QueueCard({super.key}) extends BaseCard {
  this
    : super(
        image: LayoutBuilder(
          builder: (context, constraints) {
            const images = [
              "https://i.scdn.co/image/ab67616d0000b27349e234b2a0b7503d2df7ba7f",
              "https://i.scdn.co/image/ab67616d0000b273aa03006b65521b34514eeb87",
              "https://i.scdn.co/image/ab67616d0000b2733a80a2a102e7bf2543b943de",
              "https://i.scdn.co/image/ab67616d0000b27351fc529ab704873f80b8779f",
            ];

            // ignore empty lists and just draw nothing
            if (images.length <= 0) return const SizedBox.shrink();

            final width = constraints.maxWidth;
            final punchSize = width * _punchRatio / 100;

            // grab 1-4 layers from the back of the list
            final count = min(images.length, 4);
            final kept = images.sublist(images.length - count);

            // build the stack front to back
            final layers = <(double, double, double)>[];
            var left = 0.0;
            var top = [for (var i = 0; i < count - 1; i++) _spreadRatio - i]
                .fold<double>(0, (sum, gap) => sum + gap);
            var size = 100.0;
            for (var i = 0; i < count; i++) {
              layers.add((left, top, size));
              left += _sizeStepRatio / 2;
              top -= _spreadRatio - i;
              size -= _sizeStepRatio;
            }

            // reverse so index 0 is the back of the stack
            // then construct rectangles for each
            final rects = [
              for (final (left, top, size) in layers.reversed)
                Rect.fromLTWH(
                  left * width / 100,
                  top * width / 100,
                  size * width / 100,
                  size * width / 100,
                ),
            ];

            return Stack(
              children: [
                // draw the stack back to front
                for (var i = 0; i < rects.length; i++)
                  Positioned.fromRect(
                    rect: rects[i],
                    child: ClipPath(
                      clipper: _QueuePunchClipper(
                        punches: [
                          // the layers in front of this one punch into it,
                          // inflated by the punch gap
                          for (final front in rects.skip(i + 1))
                            RRect.fromRectAndRadius(
                              front.inflate(punchSize).shift(-rects[i].topLeft),
                              Radius.circular(front.width / 10),
                            ),
                        ],
                      ),
                      child: Image.network(kept[i], fit: .cover),
                    ),
                  ),
              ],
            );
          },
        ),
        subtext: "7/17/26 4:15pm",
      );
}

/// Clips a layer down to the part not covered by the layers drawn in front
/// of it, as given by [punches] relative to the layer's own box.
class _QueuePunchClipper({required final List<RRect> punches})
    extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final clip = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          Radius.circular(size.width / 10),
        ),
      );
    if (punches.isEmpty) return clip;

    final punch = Path();
    punches.forEach(punch.addRRect);

    return Path.combine(.difference, clip, punch);
  }

  @override
  bool shouldReclip(_QueuePunchClipper oldClipper) => false;
}
