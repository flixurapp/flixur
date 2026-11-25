import "package:flixur/utils.dart";
import "package:material_ui/material_ui.dart";

class const FlixurButton({
  final VoidCallback? onPressed,
  final Widget? icon,
  final Widget? label,
  final Color? backgroundColor,
  final Color? foregroundColor,
  final Color? tint,
  final Size? size,
  final double borderWidth = 0,
  final BorderRadiusGeometry? borderRadius,
  final EdgeInsetsGeometry? padding,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const disabledAlpha = 0.4;
    final bg = backgroundColor ?? context.colors.mantle;
    final fg = foregroundColor ?? context.colors.text;
    final borderColor = tint ?? bg;

    return FilledButton(
      onPressed: onPressed,
      style: .new(
        backgroundColor: .all(bg),
        iconSize: .all(24),
        foregroundColor: .resolveWith(
          (s) => switch (s.mainState) {
            .disabled => fg.withValues(alpha: disabledAlpha),
            _ => fg,
          },
        ),
        iconColor: .resolveWith(
          (s) => switch (s.mainState) {
            .disabled => fg.withValues(alpha: disabledAlpha),
            _ => fg,
          },
        ),
        shape: borderWidth > 0
            ? .resolveWith(
                (s) => LinearBorder.bottom(
                  side: .new(
                    color: switch (s.mainState) {
                      .disabled => borderColor.withValues(alpha: disabledAlpha),
                      _ => borderColor,
                    },
                    width: borderWidth,
                  ),
                ),
              )
            : .all(RoundedRectangleBorder(borderRadius: borderRadius ?? .zero)),
        surfaceTintColor: .all(tint),
        // custom size requires no padding, let the Row() center elements
        padding: size != null ? .all(.zero) : .all(padding),
        fixedSize: size != null ? .all(size) : null,
      ),
      child: Row(
        spacing: 6,
        mainAxisAlignment: .center,
        children: [?icon, ?label],
      ),
    );
  }
}

/// A [FlixurButton] that is standalone from other UI elements.
class const FlixurFloatingButton({
  final VoidCallback? onPressed,
  final Widget? icon,
  final Widget? label,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => FlixurButton(
    onPressed: onPressed,
    icon: icon,
    label: label,
    borderRadius: .circular(6),
    padding: const .symmetric(vertical: 14, horizontal: 14),
  );
}
