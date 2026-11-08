import "package:flixur/ui/theme.dart";
import "package:material_ui/material_ui.dart";

// temporary
// ignore_for_file: prefer_const_constructors_in_immutables

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
        fontSize: !muted ? 16 : 14,
        fontWeight: .w400,
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
