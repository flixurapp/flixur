import "package:flixur/ui/icons.dart";
import "package:flixur/ui/main_nav/common.dart";
import "package:flixur/ui/theme.dart";
import "package:material_ui/material_ui.dart";

//TODO: wire into an actual setting
/// Show text labels under each nav icon.
const bottomLabelsSetting = false;

/// Main bottom navigation bar.
class MainNavBottom extends StatelessWidget with MainNavWidget {
  const MainNavBottom({
    required this.parent,
    required this.onSelected,
    super.key,
  });

  @override
  final MainNavWrapper parent;
  @override
  final ValueChanged<MainNavSection> onSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.mantle,
      child: SafeArea(
        child: Row(
          children: [
            for (final section in parent.shownSections)
              Expanded(
                child: _MainNavBottomItem(parent: this, section: section),
              ),
          ],
        ),
      ),
    );
  }
}

class _MainNavBottomItem extends MainNavItem {
  const _MainNavBottomItem({
    required super.parent,
    required super.section,
    super.axis = .horizontal,
  });

  bool get showLabels => bottomLabelsSetting;

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
