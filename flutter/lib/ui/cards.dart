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
        image: ClipRRect(
          borderRadius: .circular(8),
          child: Image.network(
            "https://i.scdn.co/image/ab67616d0000b273791e5ad29bbd6253aa453293",
            fit: .cover,
          ),
        ),
        text: "MYCELiUM",
        subtext: "Aluna",
      );
}
