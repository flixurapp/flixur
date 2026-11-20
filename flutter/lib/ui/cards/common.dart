import "package:flixur/ui/background/background.dart";
import "package:flixur/ui/filters.dart";
import "package:flixur/ui/icons.dart";
import "package:flixur/utils.dart";
import "package:flutter_hooks/flutter_hooks.dart";
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

void debugCardSetBackground(String url) =>
    BackgroundState.setSource(BackgroundSourceImage(url));

/// Debug array to hold currently selected items.
final _debugSelected = <BaseCard>{};

// ignore: prefer_const_constructors_in_immutables child card classes cant be const
class BaseCard({
  required final Widget image,
  final String? _text,
  final String? _subtext,
  final VoidCallback? onTap,
  final VoidCallback? onPlay,
  final VoidCallback? onEdit,
  final VoidCallback? onMore,
  super.key,
}) extends HookWidget {
  bool get _parentHasSelection => _debugSelected.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final hovered = useState(false);
    final textHovered = useState(false);
    final animation = useAnimationController(
      duration: const Duration(milliseconds: 100),
    );

    final selected = useState(false);
    final isSelected = selected.value || _debugSelected.contains(this);

    // run animation based on hover state
    useEffect(() {
      if (hovered.value) {
        animation.forward();
      } else {
        animation.reverse();
      }
      return null;
    }, [hovered.value]);

    void toggleSelection() {
      if (selected.value = !isSelected) {
        _debugSelected.add(this);
      } else {
        _debugSelected.remove(this);
      }
    }

    final imageWrapper = AspectRatio(
      aspectRatio: 1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final isTooSmall = width <= 140;
          final playSize = width * (isTooSmall ? 0.4 : 0.3);
          return AnimatedBuilder(
            animation: animation,
            child: image,
            builder: (context, child) {
              final animationValue = Curves.easeOut.transform(animation.value);
              return Stack(
                fit: .expand,
                children: [
                  Darken(
                    progress: isSelected ? 1 : animationValue,
                    amount: isSelected ? 0.35 : 0.55,
                    child: child,
                  ),
                  Positioned.fill(
                    bottom: null,
                    left: null,
                    child: Opacity(
                      opacity: isSelected ? 1 : animationValue,
                      child: Padding(
                        padding: .all(width * 0.05),
                        child: _BaseCardButton(
                          size: playSize * 0.5,
                          icon: isSelected
                              ? const Iconify("check-circle")
                              : const Iconify("circle"),
                          tooltip: t.btn_select,
                          onPressed: toggleSelection,
                          ordinal: .tertiary,
                          overrideColor: isSelected
                              ? context.colors.tertiary
                              : null,
                        ),
                      ),
                    ),
                  ),
                  if (!_parentHasSelection && !isSelected)
                    Positioned.fill(
                      child: Opacity(
                        opacity: animationValue,
                        child: Padding(
                          padding: .all(width * 0.05),
                          child: Row(
                            mainAxisAlignment: isTooSmall ? .center : .start,
                            crossAxisAlignment: isTooSmall ? .center : .end,
                            children: [
                              _BaseCardButton(
                                size: playSize,
                                icon: const Iconify("play-fill"),
                                tooltip: t.btn_play,
                                onPressed: onPlay,
                              ),
                              if (!isTooSmall) ...[
                                const Spacer(),
                                _BaseCardButton(
                                  size: playSize * 0.6,
                                  icon: const Iconify("pencil-simple"),
                                  tooltip: t.btn_edit,
                                  onPressed: onEdit,
                                  ordinal: .secondary,
                                ),
                                SizedBox(width: width * 0.02),
                                _BaseCardButton(
                                  size: playSize * 0.6,
                                  icon: const Iconify("dots-three-bold"),
                                  tooltip: t.btn_more,
                                  onPressed: onMore,
                                  ordinal: .secondary,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );

    Widget createText({required bool isSubtext}) => MouseRegion(
      onEnter: (_) => textHovered.value = true,
      onExit: (_) => textHovered.value = false,
      child: Text(
        !isSubtext ? _text! : _subtext!,
        maxLines: 1,
        overflow: .ellipsis,
        style: TextStyle(
          fontSize: !isSubtext
              ? CardSizing.textFontSize
              : CardSizing.subtextFontSize,
          height: CardSizing.lineHeight,
          color: !isSubtext ? context.colors.text : context.colors.textMuted,
          decoration: !isSubtext && textHovered.value ? .underline : .none,
        ),
      ),
    );

    return InkWell(
      onTap: _parentHasSelection ? toggleSelection : onTap,
      onHover: (value) => hovered.value = value,
      mouseCursor: SystemMouseCursors.click,
      hoverColor: Colors.transparent,
      child: Semantics(
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            imageWrapper,
            if (_text != null) ...[
              const SizedBox(height: 4),
              createText(isSubtext: false),
            ],
            if (_subtext != null) ...[
              if (_text != null)
                const SizedBox(height: 2)
              else
                const SizedBox(height: 4),
              createText(isSubtext: true),
            ],
          ],
        ),
      ),
    );
  }
}

class const _BaseCardButton({
  required final double size,
  required final Widget icon,
  required final String tooltip,
  required final VoidCallback? onPressed,
  final AppColorOrdinal ordinal = .primary,
  final Color? overrideColor,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: tooltip,
    onPressed: onPressed,
    padding: .zero,
    iconSize: size * (ordinal == .primary ? 0.55 : 0.65),
    icon: icon,
    constraints: .tight(.new(size, size)),
    style: .new(
      iconColor: .all(overrideColor ?? context.colors.fromOrdinalOn(ordinal)),
      backgroundColor: .all(
        ordinal == .tertiary
            ? Colors.transparent
            : context.colors.fromOrdinal(ordinal),
      ),
      shape: .all(
        RoundedRectangleBorder(
          borderRadius: .circular(ordinal == .primary ? size / 2 : size / 5),
        ),
      ),
    ),
  );
}
