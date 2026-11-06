import "package:flixur/ui/icons.dart";
import "package:flixur/ui/main_nav/common.dart";
import "package:flixur/utils.dart";
import "package:material_ui/material_ui.dart";

//TODO: wire into an actual setting
/// Whether the rail starts expanded.
const railExpandedDefaultSetting = false;

/// Main side navigation rail for wide layouts.
class MainNavRail extends StatefulWidget with MainNavWidget {
  const MainNavRail({
    required this.parent,
    required this.onSelected,
    super.key,
  });

  static const collapsedWidth = 64.0;
  static const double expandedWidth = collapsedWidth * 3.5;
  static const itemHeight = 48.0;

  @override
  final MainNavWrapper parent;
  @override
  final ValueChanged<MainNavSection> onSelected;

  @override
  State<MainNavRail> createState() => _MainNavRailState();
}

class _MainNavRailState extends State<MainNavRail> {
  bool expanded = railExpandedDefaultSetting;

  void toggleExpanded() => setState(() => expanded = !expanded);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: colors.mantle,
      child: SafeArea(
        child: AnimatedContainer(
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
              // expand/collapse button
              Semantics(
                button: true,
                label: expanded
                    ? t.navigation.rail.collapse
                    : t.navigation.rail.expand,
                child: InkWell(
                  mouseCursor: SystemMouseCursors.click,
                  onTap: toggleExpanded,
                  child: SizedBox(
                    height: MainNavRail.itemHeight,
                    child: AnimatedRotation(
                      duration: mainNavAnimationDuration,
                      turns: expanded ? 0 : -1 / 2,
                      child: Iconify(
                        "caret-double-left",
                        size: mainNavIconSize * 0.8,
                        color: colors.textMuted,
                      ),
                    ),
                  ),
                ),
              ),

              for (final section in widget.parent.shownSections)
                _MainNavRailItem(
                  parent: widget,
                  section: section,
                  expanded: expanded,
                ),
              // "hidden" sections go at the bottom
              const Spacer(),
              for (final section in widget.parent.hiddenSections)
                _MainNavRailItem(
                  parent: widget,
                  section: section,
                  expanded: expanded,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MainNavRailItem extends MainNavItem {
  const _MainNavRailItem({
    required super.parent,
    required super.section,
    required this.expanded,
    super.axis = .vertical,
  });

  final bool expanded;

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
