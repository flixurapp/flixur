import "package:flixur/router.dart" show router;
import "package:flixur/ui/cards/common.dart";
import "package:material_ui/material_ui.dart";

class AlbumCard({
  final String imageURL =
      "https://i.scdn.co/image/ab67616d0000b273791e5ad29bbd6253aa453293",
  super.key,
}) extends BaseCard {
  this
    : super(
        image: LayoutBuilder(
          builder: (context, constraints) => ClipRRect(
            borderRadius: .circular(constraints.maxWidth / 12),
            child: Image.network(imageURL, fit: .cover),
          ),
        ),
        text: "MYCELiUM",
        subtext: "Aluna",
        onTap: () => router.goNamed("home"),
        onPlay: () => debugCardSetBackground(imageURL),
      );
}
