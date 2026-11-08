import "package:flixur/ui/cards.dart";
import "package:material_ui/material_ui.dart";

// TODO: wire to setting
const _cardsPerRow = 6;

class LibraryView extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return CardsGrid(
      rowCount: _cardsPerRow,
      children: List.generate(100, (index) {
        return switch (index % 3) {
          0 => ArtistCard(),
          1 => AlbumCard(),
          _ => PlaylistCard(),
        };
      }),
    );
  }
}
