import "dart:math";

import "package:flixur/utils.dart";
import "package:iconify_design/iconify_design.dart";
import "package:material_ui/material_ui.dart";

// Default icon set to use for icons.
const _defaultSet = "ph";

/// Icon to use if another icon fails to load.
const _errIcon = "$_defaultSet:x-bold";

class Iconify extends StatelessWidget {
  new(
    /// Icon name to use.
    /// If a prefix is not provided, the default will be prepended.
    String iconName, {
    super.key,
    this.size = 24,
    this.color,
  }) : icon = !iconName.contains(":") ? "$_defaultSet:$iconName" : iconName;

  final String icon;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    // this keeps the icon in the center so it doesnt stretch
    return Center(
      child: IconifyIcon(
        icon: icon,
        size: size,
        color: color,
        placeholder: SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: max(1, size / 12),
            color: color,
          ),
        ),
        errorWidget: icon != _errIcon
            ? Iconify(_errIcon, size: size, color: context.colors.error)
            // if we cant load icons AT ALL then fall back to a textual X
            : Container(
                alignment: .center,
                width: size,
                height: size,
                child: Text(
                  "X",
                  textAlign: .center,
                  style: .new(
                    fontWeight: .w900,
                    color: context.colors.error,
                    fontSize: size - 2,
                    height: 1,
                  ),
                ),
              ),
      ),
    );
  }
}
