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
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? context.colors.mantle;
    final fg = foregroundColor ?? context.colors.text;

    return FilledButton(
      onPressed: onPressed,
      style: .new(
        backgroundColor: .all(bg),
        foregroundColor: .all(fg),
        iconSize: .all(24),
        iconColor: .all(fg),
        shape: .all(
          borderWidth > 0
              ? LinearBorder.bottom(
                  side: .new(color: tint ?? bg, width: borderWidth),
                )
              : const RoundedRectangleBorder(),
        ),
        surfaceTintColor: .all(tint),
        // custom size requires no padding, let the Row() center elements
        padding: size != null ? .all(.zero) : null,
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
