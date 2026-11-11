import "package:flixur/settings.dart";
import "package:flixur/ui/icons.dart";
import "package:flixur/ui/main_nav/common.dart";
import "package:flixur/ui/theme.dart";
import "package:material_ui/material_ui.dart";

/// Main bottom navigation bar.
class const MainNavBottom({
  required super.parent,
  required super.onSelected,
  super.key,
}) extends MainNavWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.mantle,
      child: SafeArea(
        child: SettingsValue<List<String>>(
          "ui.nav.shownSections",
          builder: (context, _) => SettingsValue<bool>(
            "ui.nav.bottomLabels",
            builder: (context, showLabels) => Row(
              children: [
                for (final section in parent.shownSections)
                  Expanded(
                    child: _MainNavBottomItem(
                      parent: this,
                      section: section,
                      showLabels: showLabels,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class const _MainNavBottomItem({
  required super.parent,
  required super.section,
  required final bool showLabels,
  super.axis = .horizontal,
}) extends MainNavItem {
  @override
  double get height => showLabels ? 74 : 64;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final iconColor = selected ? colors.text : colors.textMuted;

    return builder([
      MainNavItemHighlighter(axis: .horizontal, enabled: selected),
      Expanded(
        child: Iconify(section.icon, size: mainNavIconSize, color: iconColor),
      ),
      if (showLabels) ...[
        Text(
          section.label,
          style: TextStyle(
            fontSize: 11,
            color: iconColor,
            fontWeight: selected ? .w600 : .w400,
          ),
        ),
        const SizedBox(height: 4),
      ],
    ]);
  }
}
