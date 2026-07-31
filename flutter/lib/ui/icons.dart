import "dart:math";

import "package:flixur/utils.dart";
import "package:flutter/material.dart";
import "package:iconify_design/iconify_design.dart";

// Default icon set to use for icons.
const _defaultSet = "ph";

/// Icon to use if another icon fails to load.
const _errIcon = "$_defaultSet:x-bold";

class Iconify extends StatelessWidget {
  Iconify(String iconName, {super.key, this.size = 24, this.color})
    : icon = !iconName.contains(":") ? "$_defaultSet:$iconName" : iconName;

  /// Icon name to use, if prefix is not provided, the default will be appended.
  final String icon;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconifyIcon(
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
    );
  }
}
