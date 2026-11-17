import "dart:math";

import "package:flixur/settings.dart";
import "package:flixur/ui/cards/album.dart";
import "package:flixur/ui/cards/artist.dart";
import "package:flixur/ui/cards/collection.dart";
import "package:flixur/ui/cards/common.dart";
import "package:flixur/ui/cards/playlist.dart";
import "package:flixur/ui/cards/queue.dart";
import "package:flixur/utils.dart";
import "package:material_ui/material_ui.dart";

class const LibraryView({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SettingsValue<int>(
      "ui.library.cardsPerRow",
      builder: (context, perRow) => CardsGrid(
        rowCount: perRow,
        children: [
          // white ahh
          AlbumCard(
            imageURL: "https://thumb.wikimedia.org/wikipedia/commons/thumb/1/13/Example_of_a_blank_white_square.jpg/960px-Example_of_a_blank_white_square.jpg",
          ),
          ...[
            "https://i.scdn.co/image/ab67616d0000b273791e5ad29bbd6253aa453293",
            "https://i.scdn.co/image/ab6761610000e5ebdf2728294ff77dd11eeb18fb",
            "https://i.scdn.co/image/ab67616d0000b27311e55e4aa68150f5a0bfa22f",
            "https://i.scdn.co/image/ab67616d0000b273d9985092cd88bffd97653b58",
            "https://i.scdn.co/image/ab67616d0000b273124e9249fada4ff3c3a0739c",
            "https://i.scdn.co/image/ab67616d0000b27325c28f3c9fbdbab1a88dd619",
            "https://i.postimg.cc/3xdSL2nV/image.png",
            "https://i.scdn.co/image/ab67616d0000b27349e234b2a0b7503d2df7ba7f",
            "https://i.scdn.co/image/ab67616d0000b273aa03006b65521b34514eeb87",
            "https://i.scdn.co/image/ab67616d0000b2733a80a2a102e7bf2543b943de",
            "https://i.scdn.co/image/ab67616d0000b27351fc529ab704873f80b8779f",
            "https://i.scdn.co/image/ab6761610000e5eb1f3a898eda73082c4618e541",
            "https://i.scdn.co/image/ab67616d0000b273632fd92fb614b42882063126",
            "https://i.scdn.co/image/ab67616d0000b273c9910b44cbbaf1f971fc6a54",
            "https://i.scdn.co/image/ab67616d0000b2732e8670913dc839242d6f34a1",
            "https://i.scdn.co/image/ab67616d0000b2738813be08f1660b92c2f9256b",
            "https://i.scdn.co/image/ab67616d0000b273bcf683bad9ca8297e76f2408",
            "https://i.scdn.co/image/ab67616d0000b27339ead112a2805b2eeeb2bc06",
            "https://i.scdn.co/image/ab67616d0000b2730b51f8d91f3a21e8426361ae",
            "https://i.scdn.co/image/ab67616d0000b2734123c0f9b6689205d20f350f",
            "https://i.scdn.co/image/ab6761610000e5ebb4f233bce153b6c192ff5ba6",
            "https://i.scdn.co/image/ab6761610000e5eb46ca9032b068b254b054bda9",
            "https://i.scdn.co/image/ab67616d0000b273f92feff277e875d7e6f6302e",
            "https://i.scdn.co/image/ab67616d0000b27344a11299feef1f49e23172f9",
            "https://i.scdn.co/image/ab67616d0000b273a03dc4c9f744dcf8c7c292f6",
            "https://i.scdn.co/image/ab67616d0000b2731c0ffd4defc59598a0748248",
            "https://i.scdn.co/image/ab67616d0000b27399bdff832dfeb1545beac0c9",
            "https://i.scdn.co/image/ab67616d0000b2737f3c5b49e47932ef8c00ea17",
            "https://i.scdn.co/image/ab67616d0000b27393844705a9f375b857203617",
            "https://i.scdn.co/image/ab67616d0000b27388e3822cccfb8f2832c70c2e",
          ].map((e) => AlbumCard(imageURL: e)),
          ...List.generate(100, (index) {
            return switch (index % 5) {
              0 => ArtistCard(),
              1 => AlbumCard(),
              2 => PlaylistCard(),
              3 => CollectionCard(),
              _ => QueueCard(),
            };
          }),
        ],
      ),
    );
  }
}

/// Creates a grid of scrollable cards.
class const CardsGrid({
  required final int rowCount,
  required final List<Widget> children,
  final EdgeInsets padding = const .all(10),
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
          padding: padding + context.safeBottomPadding,
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
