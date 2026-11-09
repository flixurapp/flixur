import "package:flixur/ui/cards/common.dart";
import "package:material_ui/material_ui.dart";

class PlaylistCard({super.key}) extends BaseCard {
  this
    : super(
        image: CustomPaint(
          foregroundPainter: _ShadowPainter(),
          child: ClipPath(
            clipper: _ImageClipper(),
            child: LayoutBuilder(
              builder: (context, constraints) {
                /// Width of the image.
                final width = constraints.maxWidth;

                /// Width of a fold edge.
                final edge = width * (1 - _PlaylistFold.foldRatio);

                // dart format off
                /// Matrix to mirror/rotate the image for the fold.
                final mirror = Matrix4(
                  0, 1, 0, 0,
                  1, 0, 0, 0,
                  0, 0, 1, 0,
                  edge, -edge, 0, 1,
                );
                // dart format on

                const url = "https://i.postimg.cc/3xdSL2nV/image.png";
                return Stack(
                  fit: .expand,
                  children: [
                    Image.network(url, fit: .cover),
                    ClipPath(
                      clipper: _FoldClipper(),
                      child: Transform(
                        transform: mirror,
                        child: Image.network(url, fit: .cover),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        text: "High Vibes",
        subtext: "2 days, 16 hours",
      );
}

class _PlaylistFold {
  /// Percentage of the image's rendered size that each fold edge takes up.
  static const double foldRatio = 0.3;

  /// Corner radius of the fold tip, relative to the fold size.
  static const double tipRadius = 0.1;

  /// Surface of the visible image, clips off the top corner.
  static Path image(Size size) {
    final fold = size.width * foldRatio;
    return Path()
      ..moveTo(0, 0)
      ..lineTo(size.width - fold, 0)
      ..lineTo(size.width, fold)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  /// The clip for the fold itself, with the rounded tip.
  static Path fold(Size size) {
    final fold = size.width * foldRatio;
    final tip = fold * tipRadius;
    return Path()
      ..moveTo(size.width - fold, 0)
      ..lineTo(size.width, fold)
      ..lineTo(size.width - fold + tip, fold)
      ..quadraticBezierTo(
        size.width - fold, // left edge of the notch
        fold, // bottom edge of the notch
        size.width - fold,
        fold - tip,
      )
      ..close();
  }
}

/// Clipper to remove the top corner from the image.
class _ImageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) => _PlaylistFold.image(size);
  @override
  bool shouldReclip(_ImageClipper oldClipper) => false;
}

/// Clips the image down to the folded-over flap.
class _FoldClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) => _PlaylistFold.fold(size);
  @override
  bool shouldReclip(_FoldClipper oldClipper) => false;
}

/// Draws the fold shadow over the image.
class _ShadowPainter extends CustomPainter {
  /// Dark shadow under the fold.
  static const double shadowOpacity = 0.4;

  /// White highlight shadow on top of the dark one, for darker images.
  static const double highlightOpacity = 0.3;

  /// White transparent layer painted over the fold.
  static const double overlayOpacity = 0.15;

  /// Blur distance, relative to the size of the fold.
  static const double blurRatio = 0.25;

  @override
  void paint(Canvas canvas, Size size) {
    final fold = _PlaylistFold.fold(size);
    final foldWidth = size.width * _PlaylistFold.foldRatio;
    // offset the shadow toward the cut corner to keep the edges neat
    final shadowOffset = Offset(-foldWidth * -0.1, foldWidth * -0.1);
    final shadowBlur = foldWidth * blurRatio;

    canvas
      ..save()
      // combine the difference between the image and fold so that the
      // shadow can only exist on the image surface and wont overflow
      ..clipPath(Path.combine(.difference, _PlaylistFold.image(size), fold))
      ..drawPath(
        fold.shift(shadowOffset),
        Paint()
          ..color = Colors.black.withValues(alpha: shadowOpacity)
          ..maskFilter = MaskFilter.blur(.normal, shadowBlur),
      )
      ..drawPath(
        fold.shift(shadowOffset),
        Paint()
          ..color = Colors.white.withValues(alpha: highlightOpacity)
          ..maskFilter = MaskFilter.blur(.normal, shadowBlur),
      )
      ..restore()
      ..drawPath(
        fold,
        Paint()..color = Colors.white.withValues(alpha: overlayOpacity),
      );
  }

  @override
  bool shouldRepaint(_ShadowPainter oldPainter) => false;
}
