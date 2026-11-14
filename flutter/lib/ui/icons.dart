import "dart:async";
import "dart:math";

import "package:flixur/utils.dart";
import "package:hive_ce_flutter/hive_ce_flutter.dart";
import "package:iconify_design/iconify_design.dart";
import "package:material_ui/material_ui.dart";

const _boxName = "iconify_icons";

Future<void> initIconify() async {
  IconifyClientService.maxMemoryCacheIcons = 512;

  // open box and use it for the cache
  final box = await Hive.openBox<String>(_boxName);
  IconifyClientService.cacheGet = box.get;
  IconifyClientService.cacheSet = box.put;
}

// Default icon set to use for icons.
const _defaultSet = "ph";

/// Icon to use if another icon fails to load.
const _errIcon = "$_defaultSet:x-bold";

class const Iconify(
  /// Icon name to use.
  /// If a prefix is not provided, the default will be prepended.
  final String iconName, {
  final double? size,
  final Color? color,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (iconName.isEmpty) return const SizedBox.shrink();

    final icon = !iconName.contains(":") ? "$_defaultSet:$iconName" : iconName;
    final iconTheme = IconTheme.of(context);

    // inherit from icon theme if possible
    final effectiveSize = size ?? iconTheme.size ?? 24;
    final effectiveColor = color ?? iconTheme.color ?? context.colors.text;
    return IconifyIcon(
      icon: icon,
      size: effectiveSize,
      color: effectiveColor,
      placeholder: SizedBox(
        width: effectiveSize,
        height: effectiveSize,
        child: CircularProgressIndicator(
          strokeWidth: max(1, effectiveSize / 12),
          color: effectiveColor,
        ),
      ),
      errorWidget: icon != _errIcon
          ? Iconify(_errIcon, size: effectiveSize, color: context.colors.error)
          // if we cant load icons AT ALL then fall back to a textual X
          : Container(
              alignment: .center,
              width: effectiveSize,
              height: effectiveSize,
              child: Text(
                "X",
                textAlign: .center,
                style: .new(
                  fontWeight: .w900,
                  color: context.colors.error,
                  fontSize: effectiveSize - 2,
                  height: 1,
                ),
              ),
            ),
    );
  }
}
