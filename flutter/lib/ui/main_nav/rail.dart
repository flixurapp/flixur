import "package:flixur/settings.dart";
import "package:flixur/ui/icons.dart";
import "package:flixur/ui/main_nav/common.dart";
import "package:flixur/utils.dart";
import "package:material_ui/material_ui.dart";

/// Main side navigation rail for wide layouts.
class const MainNavRail({
  required super.parent,
  required super.onSelected,
  super.key,
}) extends MainNavWidget {
  static const collapsedWidth = 64.0;
  static const double expandedWidth = collapsedWidth * 3.5;
  static const itemHeight = 48.0;

  /// Whether the nav rail is expanded.
  static final isExpanded = ValueNotifier<bool>(
    Settings.getValue<bool>("ui.navigation.railDefaultExpanded"),
  );

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: colors.mantle,
      child: SafeArea(
        right: false,
        child: SettingsValue<List<String>>(
          "ui.navigation.shownSections",
          builder: (context, _) => ValueListenableBuilder(
            valueListenable: isExpanded,
            builder: (context, expanded, _) => AnimatedContainer(
              duration: mainNavAnimationDuration,
              curve: Curves.easeOutCubic,
              width: expanded
                  ? MainNavRail.expandedWidth
                  : MainNavRail.collapsedWidth,
              // keeps some space between the button and page
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: colors.mantle)),
              ),
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  for (final section in parent.shownSections)
                    _MainNavRailItem(
                      parent: this,
                      section: section,
                      expanded: expanded,
                    ),
                  // "hidden" sections go at the bottom
                  const Spacer(),
                  for (final section in parent.hiddenSections)
                    _MainNavRailItem(
                      parent: this,
                      section: section,
                      expanded: expanded,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class const _MainNavRailItem({
  required super.parent,
  required super.section,
  required final bool expanded,
  super.axis = .vertical,
}) extends MainNavItem {
  @override
  double get height => MainNavRail.itemHeight;

  static const _paddingBox = SizedBox(
    width:
        ((MainNavRail.collapsedWidth - mainNavIconSize) / 2) -
        MainNavItemHighlighter.size,
  );

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final iconColor = selected ? colors.text : colors.textMuted;

    return builder([
      MainNavItemHighlighter(axis: .vertical, enabled: selected),
      _paddingBox,
      Iconify(section.icon, size: mainNavIconSize, color: iconColor),
      _paddingBox,
      Flexible(
        child: ClipRect(
          child: AnimatedOpacity(
            duration: mainNavAnimationDuration,
            opacity: expanded ? 1 : 0,
            child: Text(
              section.label,
              maxLines: 1,
              softWrap: false,
              overflow: .clip,
              style: TextStyle(
                fontSize: MainNavRail.itemHeight / 3,
                color: iconColor,
                fontWeight: selected ? .w600 : .w400,
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}
