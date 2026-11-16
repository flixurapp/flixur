import "package:flixur/ui/cards/common.dart";
import "package:material_ui/material_ui.dart";

class ArtistCard({
  final String imageURL =
      "https://i.scdn.co/image/ab6761610000e5ebdf2728294ff77dd11eeb18fb",
  super.key,
}) extends BaseCard {
  this
    : super(
        image: ClipOval(child: Image.network(imageURL, fit: .cover)),
        text: "Tyler the Creator",
        onTap: () => debugCardSetBackground(imageURL),
      );
}
