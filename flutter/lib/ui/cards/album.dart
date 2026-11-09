import "package:flixur/ui/cards/common.dart";
import "package:material_ui/material_ui.dart";

class AlbumCard({super.key}) extends BaseCard {
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
