import "package:flixur/ui/cards/common.dart";
import "package:material_ui/material_ui.dart";

class ArtistCard({super.key}) extends BaseCard {
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
