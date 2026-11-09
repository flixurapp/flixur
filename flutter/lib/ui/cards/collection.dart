import "dart:math";

import "package:flixur/ui/cards/common.dart";
import "package:material_ui/material_ui.dart";

/// Each circle's punch-out width, percent relative to the overall image width.
const _ringPunchRatio = 2;

/// (left, top, diameter) definitions for each circle count in the card.
/// The units are whole percentages relative to the image size. (100 is max)
const List<List<(double, double, double)>> _circleDefinitions = [
  [(8, 8, 84)], // 1
  [(6, 6, 68), (38, 38, 60)], // 2
  [(4, 4, 66), (38, 24, 58), (14, 48, 52)], // 3
  [(4, 4, 64), (44, 20, 56), (10, 48, 50), (48, 60, 40)], // 4
];

class CollectionCard({super.key}) extends BaseCard {
  this
    : super(
        image: LayoutBuilder(
          builder: (context, constraints) {
            final images = [
              "https://i.scdn.co/image/ab67616d0000b27311e55e4aa68150f5a0bfa22f",
              "https://i.scdn.co/image/ab67616d0000b273d9985092cd88bffd97653b58",
              "https://i.scdn.co/image/ab67616d0000b273124e9249fada4ff3c3a0739c",
              "https://i.scdn.co/image/ab67616d0000b27325c28f3c9fbdbab1a88dd619",
            ];

            // ignore empty lists and just draw nothing
            if (images.length <= 0) return const SizedBox.shrink();

            final width = constraints.maxWidth;
            final ringPunchSize = width * _ringPunchRatio / 100;

            // grab 1-4 circles based on the amount of images
            final layout =
                _circleDefinitions[min(
                      images.length,
                      _circleDefinitions.length,
                    ) -
                    1];

            // create rectangles for each selected circle
            final circles = [
              for (final (left, top, diameter) in layout)
                Rect.fromLTWH(
                  left * width / 100,
                  top * width / 100,
                  diameter * width / 100,
                  diameter * width / 100,
                ),
            ];

            return Stack(
              children: [
                // draw circles bottom-up
                for (var i = circles.length - 1; i >= 0; i--)
                  Positioned.fromRect(
                    rect: circles[i],
                    child: ClipPath(
                      clipper: _PunchClipper(
                        punches: [
                          // the circles above this one clip it
                          // inflated by their punch size
                          for (final circle in circles.take(i))
                            circle
                                .inflate(ringPunchSize)
                                .shift(-circles[i].topLeft),
                        ],
                      ),
                      child: Image.network(images[i], fit: .cover),
                    ),
                  ),
              ],
            );
          },
        ),
        text: "brayden's collection",
        subtext: "42 albums",
      );
}

/// Clips a circle down to the part not covered by the circles drawn
/// above it, as given by [punches] relative to the circle's own box.
class _PunchClipper({required final List<Rect> punches})
    extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final clip = Path()..addOval(Offset.zero & size);
    if (punches.isEmpty) return clip;

    final punch = Path();
    punches.forEach(punch.addOval);

    return Path.combine(.difference, clip, punch);
  }

  @override
  bool shouldReclip(_PunchClipper oldClipper) => false;
}
