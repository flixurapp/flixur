import "dart:math";

import "package:flixur/ui/cards.dart";
import "package:material_ui/material_ui.dart";

class LibraryView extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => GridView.count(
        crossAxisCount: constraints.maxWidth ~/ 144,
        padding: const EdgeInsets.all(10),
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 100 / 144,
        children: List.generate(100, (index) {
          return Random().nextBool() ? ArtistCard() : AlbumCard();
        }),
      ),
    );
  }
}
