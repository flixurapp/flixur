import "package:flixur/utils.dart";
import "package:material_ui/material_ui.dart";

class const FlixurButton({
  final VoidCallback? onPressed,
  final Widget? icon,
  final Widget? label,
  final Color? backgroundColor,
  final Color? tint,
  final Size? size,
  final double borderWidth = 0,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? context.colors.mantle;

    return FilledButton(
      onPressed: onPressed,
      style: .new(
        iconSize: .all(24),
        backgroundColor: .all(bg),
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
