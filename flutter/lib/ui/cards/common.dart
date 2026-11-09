import "package:flixur/utils.dart";
import "package:material_ui/material_ui.dart";

class CardSizing {
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

class BaseCard({
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
        fontSize: !muted ? CardSizing.textFontSize : CardSizing.subtextFontSize,
        fontWeight: .w400,
        height: CardSizing.lineHeight,
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
