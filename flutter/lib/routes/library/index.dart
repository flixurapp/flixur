import "dart:math";

import "package:flixur/settings.dart";
import "package:flixur/ui/cards/album.dart";
import "package:flixur/ui/cards/artist.dart";
import "package:flixur/ui/cards/collection.dart";
import "package:flixur/ui/cards/common.dart";
import "package:flixur/ui/cards/playlist.dart";
import "package:flixur/ui/cards/queue.dart";
import "package:material_ui/material_ui.dart";

class const LibraryView({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SettingsValue<int>(
      "ui.library.cardsPerRow",
      builder: (context, perRow) => CardsGrid(
        rowCount: perRow,
        children: List.generate(100, (index) {
          return switch (index % 5) {
            0 => ArtistCard(),
            1 => AlbumCard(),
            2 => PlaylistCard(),
            3 => CollectionCard(),
            _ => QueueCard(),
          };
        }),
      ),
    );
  }
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
                    (CardSizing.minWidth + spacing))
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
          mainAxisExtent: cardWidth + CardSizing.textBlockExtent,
          children: children,
        );
      },
    );
  }
}
