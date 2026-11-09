import "dart:math";

import "package:flixur/ui/theme.dart";
import "package:material_ui/material_ui.dart";

// temporary
// ignore_for_file: prefer_const_constructors_in_immutables

class _CardSizing {
  /// Vertical spacing between the image and the text.
  static const double imageSpacing = 4;

  /// Vertical spacing between the text/subtext.
  static const double textGap = 2;

  /// Minimum width of a single card.
  static const double minWidth = 100;

  /// Line height for card text.
  static const double lineHeight = 1.5;

  static const double textFontSize = 16;
  static const double subtextFontSize = 14;

  /// Worst-case scenario for text block height.
  static const double textBlockExtent =
      imageSpacing +
      textFontSize * lineHeight +
      textGap +
      subtextFontSize * lineHeight;
}

/// Creates a grid of scrollable cards.
class const CardsGrid({
  required final int rowCount,
  required final List<Widget> children,
  final EdgeInsetsGeometry padding = const .all(10),
  final double spacing = 10,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // highest card count that still leaves the minimum width per card
        final fits =
            ((constraints.maxWidth - padding.horizontal + spacing) /
                    (_CardSizing.minWidth + spacing))
                .floor();

        // minimum of 3 cards across unless the desired count is lower
        final perRow = max(1, min(rowCount, max(3, fits)));

        final cardWidth =
            (constraints.maxWidth -
                padding.horizontal -
                spacing * (perRow - 1)) /
            perRow;

        return GridView.count(
          crossAxisCount: perRow,
          padding: padding,
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
          // extent is the width (image 1:1 so image height) + text block height
          mainAxisExtent: cardWidth + _CardSizing.textBlockExtent,
          children: children,
        );
      },
    );
  }
}

class const _BaseCard({
  required final Widget image,
  final String? _text,
  final String? _subtext,
  super.key,
}) extends StatelessWidget {
  Text _createText(BuildContext context, String text, bool muted) {
    return Text(
      text,
      maxLines: 1,
      overflow: .ellipsis,
      style: TextStyle(
        fontSize: !muted
            ? _CardSizing.textFontSize
            : _CardSizing.subtextFontSize,
        fontWeight: .w400,
        height: _CardSizing.lineHeight,
        color: !muted ? context.colors.text : context.colors.textMuted,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          AspectRatio(aspectRatio: 1, child: image),
          if (_text != null) ...[
            const SizedBox(height: 4),
            _createText(context, _text, false),
          ],
          if (_subtext != null) ...[
            if (_text != null)
              const SizedBox(height: 2)
            else
              const SizedBox(height: 4),
            _createText(context, _subtext, true),
          ],
        ],
      ),
    );
  }
}

class ArtistCard({super.key}) extends _BaseCard {
  this
    : super(
        image: ClipOval(
          child: Image.network(
            "https://i.scdn.co/image/ab6761610000e5ebdf2728294ff77dd11eeb18fb",
            fit: .cover,
          ),
        ),
        text: "Tyler the Creator",
      );
}

class AlbumCard({super.key}) extends _BaseCard {
  this
    : super(
        image: LayoutBuilder(
          builder: (context, constraints) => ClipRRect(
            borderRadius: .circular(constraints.maxWidth / 12),
            child: Image.network(
              "https://i.scdn.co/image/ab67616d0000b273791e5ad29bbd6253aa453293",
              fit: .cover,
            ),
          ),
        ),
        text: "MYCELiUM",
        subtext: "Aluna",
      );
}

class PlaylistCard({super.key}) extends _BaseCard {
  this
    : super(
        image: CustomPaint(
          foregroundPainter: _PlaylistCardPainter(),
          child: ClipPath(
            clipper: _PlaylistCardImageClipper(),
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
                      clipper: _PlaylistFoldClipper(),
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
class _PlaylistCardImageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) => _PlaylistFold.image(size);
  @override
  bool shouldReclip(_PlaylistCardImageClipper oldClipper) => false;
}

/// Clips the image down to the folded-over flap.
class _PlaylistFoldClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) => _PlaylistFold.fold(size);
  @override
  bool shouldReclip(_PlaylistFoldClipper oldClipper) => false;
}

/// Draws the fold shadow over the image.
class _PlaylistCardPainter extends CustomPainter {
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
  bool shouldRepaint(_PlaylistCardPainter oldPainter) => false;
}
