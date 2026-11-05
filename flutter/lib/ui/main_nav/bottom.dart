import "dart:async";

import "package:flixur/ui/icons.dart";
import "package:flixur/ui/main_nav/common.dart";
import "package:flixur/ui/theme.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

//TODO: wire into an actual setting
/// Show text labels under each nav icon.
const bottomLabelsSetting = true;

/// Main bottom navigation bar.
class MainNavBottom extends StatelessWidget {
  const MainNavBottom({
    required this.parent,
    required this.onSelected,
    super.key,
    this.showLabels = bottomLabelsSetting,
  });

  final MainNavWrapper parent;

  final ValueChanged<MainNavSection> onSelected;
  final bool showLabels;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.mantle,
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            for (final section in parent.shownSections)
              Expanded(
                child: MainNavBottomItem(parent: this, section: section),
              ),
          ],
        ),
      ),
    );
  }
}

class MainNavBottomItem extends StatelessWidget {
  const MainNavBottomItem({
    required this.parent,
    required this.section,
    super.key,
  });

  final MainNavBottom parent;
  final MainNavSection section;

  bool get selected => parent.parent.selected == section.id;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final iconColor = selected ? colors.text : colors.textMuted;

    return Semantics(
      label: section.label,
      selected: selected,
      inMutuallyExclusiveGroup: true,
      child: InkWell(
        onTap: () {
          unawaited(HapticFeedback.selectionClick());
          parent.onSelected(section);
        },
        child: SizedBox(
          height: parent.showLabels ? 74 : 64,
          child: Column(
            mainAxisAlignment: .center,
            children: [
              LayoutBuilder(
                builder: (context, constraints) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: selected ? constraints.maxWidth : 0,
                  height: 3,
                  decoration: BoxDecoration(
                    color: selected ? colors.primary : Colors.transparent,
                  ),
                ),
              ),
              Expanded(
                child: Iconify(
                  section.icon,
                  size: 32,
                  color: iconColor,
                ),
              ),
              if (parent.showLabels) ...[
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
            ],
          ),
        ),
      ),
    );
  }
}
